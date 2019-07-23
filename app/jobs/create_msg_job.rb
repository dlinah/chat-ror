class CreateMsgJob < ApplicationJob
  queue_as :critical

  def perform(chat,count,msg )
    chat.lock!
    begin
      message = Message.new(msg)
      message.chat=chat
      message.number=count
      if message.save
        chat.update(messages_count: count)
        EsSyncJob.perform_later message.to_json( :only => [:body, :chat_id,:number,:id] ) 
      end
    rescue Exception => e
      puts 'error', e.inspect
    end
    
  end
  def create
    @chat.lock!
    count=(@chat.messages_count || 0) + 1 
    @message = Message.new(message_params)
    @message.chat=@chat
    @message.number=count
    if @message.save
      @chat.update(messages_count: count)
      EsSyncJob.perform_later @message.to_json( :only => [:body, :chat_id,:number,:id] ) 
      render json: @message.number, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
 
end
