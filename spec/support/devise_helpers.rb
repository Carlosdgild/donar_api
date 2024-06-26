# frozen_string_literal: true

# # frozen_string_literal: true

module DeviseHelpers
  def sign_in_as(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end
end
