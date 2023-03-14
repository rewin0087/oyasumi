class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  before_action :authenticate_user!

  attr_reader :current_user

   rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { data: { message: e.message } }, status: 404
  end

  private

  def context
    { current_user: current_user }
  end

  def authenticate_user!
    uuid = request.headers['HTTP_X_UID']

    @current_user = User.find_by(uuid: uuid)

    return render json: { message: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
