class UpdateChatJob < ApplicationJob
  queue_as :high

  def perform(chat,params)
    chat.lock!
    chat.update(params)
  end
end
