require "resque"

class ChatController < ApplicationController
  before_action :set_app, only: [:create, :show, :update]
  before_action :set_chat, only: [:update, :show]

  def show
    render json: @chat, except: [:id, :app_id]
  end

  def update
    UpdateChatJob.perform_later @chat, chat_params
    render  status: :ok
  end

  def create
    c= Rails.cache.read(@app.token+"chat_count")

    count=(c||@app.chats_count || 0) + 1 

    CreateChatJob.perform_later @app, count
    
    Rails.cache.write(@app.token+"chat_count", count)

    render json: count, status: :ok
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
