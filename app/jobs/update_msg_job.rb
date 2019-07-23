class UpdateMsgJob < ApplicationJob
  queue_as :high

  def perform(message,params)
    message.lock!
    message.update(params)
  end
end
