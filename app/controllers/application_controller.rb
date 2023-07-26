class ApplicationController < ActionController::API
  # render json
	include Jsonable

  # Pagination
  include Pagination::Paginate

  # Authorization
  # Pundit will call the `current_user` method to retrieve user
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_not_authorized
  rescue_from(ActiveRecord::RecordNotFound) { |error| handle_active_record_not_found_error(error) }
  rescue_from(TypeError) { |error| handle_type_error_error(error) }
  rescue_from(ArgumentError) { |error| handle_argument_error(error) }
  rescue_from(ActiveRecord::RecordInvalid) { |error| render_record_not_valid_error(error) }
  rescue_from(ActiveRecord::RecordNotUnique) { |error| handle_active_record_not_unique_error(error) }
  rescue_from(ActionController::ParameterMissing) { |error| handle_action_controller_parameter_missing_error(error) }
  rescue_from(ActionController::RoutingError) { |error| handle_action_controller_routing_error(error) }

  private

  # response with forbidden http code
  def user_not_not_authorized
    json_response({ message: 'Not authorized' }, :forbidden)
  end

  def handle_active_record_not_found_error(error)
    logger.error(error&.message)

    json_response({ message: "Couldn't find resource" }, :not_found)
  end

  def handle_type_error_error(error)
    logger.error(error&.message)

    json_response({ message: error&.message }, :bad_request)
  end

  def handle_argument_error(error)
    logger.error(error&.message)

    json_response({ message: error&.message }, :bad_request)
  end

  def render_record_not_valid_error(error)
    logger.error(error&.message)

    json_response({ message: error&.message }, :unprocessable_entity)
  end

  def handle_active_record_not_unique_error(error)
    logger.error(error&.message)

    json_response({ message: "A record already exists" }, :bad_request)
  end

  def handle_action_controller_parameter_missing_error(error)
    logger.error("Missing parameter #{error&.param}")

    json_response({ message: "Missing parameter #{error&.param}" }, :bad_request)
  end

  def handle_action_controller_routing_error(error)
    logger.error(error&.message)

    json_response({ message: error&.message }, :bad_request,)
  end
end
