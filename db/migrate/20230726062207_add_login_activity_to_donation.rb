class AddLoginActivityToDonation < ActiveRecord::Migration[6.1]
  def change
    add_reference :donations, :login_activity, foreign_key: true
  end
end
