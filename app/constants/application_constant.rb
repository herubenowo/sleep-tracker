class ApplicationConstant
  def self.all
    r = []
    constants.each do |c|
      r << const_get(c).to_s
    end
    r
  end
end
