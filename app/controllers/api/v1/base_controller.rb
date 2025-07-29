class Api::V1::BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ArgumentError, with: :render_bad_request

  private

  def render_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def render_bad_request
    render json: { error: 'Invalid parameters' }, status: :bad_request
  end
end
