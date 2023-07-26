class RegistrationsController < Devise::RegistrationsController
  # Override devise create method
  def create
    build_resource(user_params)

    if resource.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # To override strong params from devise
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :last_name,
      :role
    )
  end
end
