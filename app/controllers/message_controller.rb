class MessageController < ApplicationController
  before_action :set_app, only: [:create, :show, :update]
  before_action :set_chat, only: [:create, :update, :show]
  before_action :set_message, only: [:update, :show]

  def show
    render json: @message[0], except: [:id, :chat_id]
  end

  def update
    @message.lock!
    if @message.update(message_params)
      render  status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
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
      render json: @message.number, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
  private
    # Use callbacks to share app setup or constraints between actions.
    def set_app
      @app = App.find_by( token: params[:app_id])
      if !@app 
        render json: { error: "app not found"}, status: :not_found
      end
    end
    def set_chat
      @chat = Chat.where("number = ? AND app_id = ?", params[:chat_id], @app.id)[0]
      if !@chat
        render json: { error: "chat not found"}, status: :not_found
      end
    end
    def set_message
      @message = Message.where("number = ? AND chat_id = ?", params[:id], @chat.id)
      if !@message 
        render json: { error: "message not found"}, status: :not_found
      end
    end
    def message_params
      # permited field is to be determined
      params.require(:message).permit(:body)
    end
end
