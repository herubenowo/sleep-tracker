class ApplicationMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env["request_start_time"] = Time.now if env["request_start_time"].nil?

    @app.call(env)
  end
end
