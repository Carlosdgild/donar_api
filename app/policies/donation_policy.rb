class DonationPolicy < ApplicationPolicy
  def index?
    # if more roles are allowed, this could be different
    user.admin?
  end

  def create?
    true
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        # scope that can be used if more roles are allowed
        scope.where(user_id: user.id)
      end
    end
  end
end
