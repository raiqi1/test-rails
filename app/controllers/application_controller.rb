class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_api_key!, if: :api_key_required?

  private

  def api_key_required?
    ENV["API_KEY"].present?
  end

  def authenticate_api_key!
    provided = request.headers["X-API-Key"] ||
               request.headers["Authorization"]&.delete_prefix("Bearer ")

    unless provided == ENV["API_KEY"]
      render json: { error: "Unauthorized. Provide a valid API key via X-API-Key header." },
             status: :unauthorized
    end
  end

  def render_not_found(resource = "Resource")
    render json: { error: "#{resource} not found" }, status: :not_found
  end

  def render_validation_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
