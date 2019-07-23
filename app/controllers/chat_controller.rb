class ChatController < ApplicationController
  before_action :set_app, only: [:create, :show, :update]
  before_action :set_chat, only: [:update, :show]

  def show
    render json: @chat, except: [:id, :app_id]
  end

  def update
    @chat.lock!
    if @chat.update(chat_params)
      render  status: :ok
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def create
    @app.lock!
    count=(@app.chats_count || 0) + 1 
    @chat = Chat.new()
    puts "@@@@@@@@@@@@@@"
     puts @app.inspect
    @chat.app=@app
    @chat.number=count
    if @chat.save
      @app.update(chats_count: count)
      render json: @chat.number, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
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
      @chat = Chat.where("number = ? AND app_id = ?", params[:id], @app.id)[0]
      if !@chat
        render json: { error: "chat not found"}, status: :not_found
      end
    end
    def chat_params
      # permited field is to be determined
      params.require(:chat).permit(:name)
    end
end
