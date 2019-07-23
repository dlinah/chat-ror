require('ESrequest')
require 'json'
require "resque"

class MessageController < ApplicationController
  before_action :set_app, only: [:create, :show, :update, :search]
  before_action :set_chat, only: [:create, :update, :show, :search]
  before_action :set_message, only: [:update, :show]

  def show
    render json: @message[0], except: [:id, :chat_id]
  end

  def update
    UpdateMsgJob.perform_later @message[0], message_params
    render  status: :ok
  end

  def create
    c = Rails.cache.read(@chat.id.to_s+"msgs_count")
    count=(c || @chat.messages_count || 0) + 1 
    CreateMsgJob.perform_later @chat, count, message_params
    Rails.cache.write(@chat.id.to_s+"msgs_count", count)
    render json: count, status: :ok
  end

  def search
    query = {
      query: {
        bool: {
          must: [
            {
              term: {
                chat_id: @chat.id
              }
            },
            {
              query_string: {
            query: "*#{params[:text]}*",
            fields: [
              "body"
            ]
          }
            }
          ]
        }
      }
    }
    res = ESrequest :search ,query.to_json
    render json: res, status: :success
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
