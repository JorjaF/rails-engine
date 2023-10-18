class ErrorSerializer
  def self.serialize(error)
    return if error.nil?
    {
      error: error
    }
  end
end
