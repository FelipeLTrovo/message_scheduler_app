class MessagesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_message, only: %i[ show update destroy ]

  def index
    @messages = current_user.messages
    render 'messages/index', formats: :json, handlers: :jbuilder
  end

  def show
    render json: @message
  end

  def create
    @message = current_user.messages.build(message_params)
    
    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy!
  end

  private

  def set_message
    @message = current_user.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:text, :scheduled_date, :whatsapp_number, :id)
  end
end