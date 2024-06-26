class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: %i[show update destroy ]

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :id)
  end
end
