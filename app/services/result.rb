class Result
  attr_reader :object, :success, :message

  def initialize(object, success, message = nil)
    @object = object
    @success = success
    @message = message
  end
end
