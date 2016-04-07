class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  rescue_from ActionController::UnknownFormat, with: :unknown_format

  private

  def unknown_format
    render json: { error: 'unsupported format is requested' }, status: :unprocessable_entity
  end
end
