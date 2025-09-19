# frozen_string_literal: true

if ENV["FIRESTORE_ENABLE"].present? && ENV["FIRESTORE_ENABLE"] == "true"
  require "google/cloud/firestore"
  require "grpc"
  module Firestore
    attr_accessor :connection_pool, :mutex

    @connection_pool = nil
    @mutex = Mutex.new

    class << self
      def client
        unless @connection_pool.present?
          self.configure
        end
        begin
          @connection_pool.checkout
        ensure
          @connection_pool.checkin
        end
      end

      def reinitialize!(error_message = "")
        Rails.logger.info("Need to reinitalize firestore client: #{error_message}")
        if @connection_pool.present? && need_shutdown?(error_message)
          shutdown_grpc_channel
          self.configure
        elsif @connection_pool.nil?
          self.configure
        end
      end

      def check_connection
        begin
          if @connection_pool.nil?
            self.configure
          end
          begin
            client = @connection_pool.checkout
            client.collection("test").doc("check-connection").get
            Rails.logger.info("Firestore connection: OK!")
          ensure
            @connection_pool.checkin
          end
        rescue StandardError => e
          Rails.logger.error("Error with firestore connection: #{e.message}")
          reinitialize!(e.message)
          self.check_connection
        end
      end

      private

      def configure
        self.shutdown_connection_pool unless @connection_pool.nil?
        max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
        @mutex.synchronize do
          @connection_pool = ConnectionPool.new(size: max_threads_count, timeout: 30) do
            initialize_client
          end
        end
      end

      def initialize_client
        gcs_timeout = (ENV["GCS_TIMEOUT"] || "120").to_i
        keep_alive = gcs_timeout * 1000

        Rails.logger.info("Begin to initialize firestore client")
        Google::Cloud::Firestore.new(
          credentials: ENV["FIRESTORE_CREDENTIALS"],
          project_id: ENV["FIRESTORE_PROJECT_ID"],
          timeout: gcs_timeout
        ) do |config|
          config.channel_args = {
            "grpc.keepalive_time_ms" => keep_alive
          }
        end
      rescue StandardError => e
        Rails.logger.error("Failed to initialize Firestore client: #{e.message}")
        nil
      end

      def shutdown_grpc_channel
        GRPC::Core::Channel.instance_variable_set(:@finalizer_queue, nil)
        ObjectSpace.each_object(GRPC::Core::Channel) do |channel|
          begin
            Rails.logger.info("Begin to close gRPC channel")
            channel.close
            Rails.logger.info("Closing gRPC channel succeed")
          rescue StandardError => e
            Rails.logger.error("Failed to close gRPC channel: #{e.message}")
          end
        end
      end

      def need_shutdown?(error_message)
        error_message = error_message.to_s.downcase
        if error_message.include?("grpc is in a broken state") || error_message.include?("connection reset by peer") ||
          error_message.include?("expired") || error_message.include?("timeout") || error_message.include?("exceeded")
          true
        else
          false
        end
      end

      def shutdown_connection_pool
        @mutex.synchronize do
          @connection_pool.shutdown do
            Rails.logger.info("Closing firestore connection pool")
          end
        end
      end
    end

    at_exit do
      self.shutdown_grpc_channel
      self.shutdown_connection_pool unless @connection_pool.nil?
    end
  end
end
