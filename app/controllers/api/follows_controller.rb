class Api::FollowsController < ApplicationController

  def create
    FollowUser.new(params[:follow_user_id]).call(user: current_user)

    render json: {}, status: :no_content
  end

  def destroy
    UnfollowUser.new(params[:id]).call(user: current_user)

    render json: {}, status: :no_content
  end
end
