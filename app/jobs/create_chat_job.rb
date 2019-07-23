class CreateChatJob < ApplicationJob
  queue_as :critical
  
  def perform(app ,count)
    app.lock!
    chat = Chat.new()
    chat.app=app
    chat.number=count
    if chat.save
      app.update(chats_count: count)
    end
  end

end
