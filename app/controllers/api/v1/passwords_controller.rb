class Api::V1::PasswordsController < ApplicationController
  def count
    result = PasswordValidator.(file: params[:file])

    if result.success?
      render json: { result: result[:result] }
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end
end
