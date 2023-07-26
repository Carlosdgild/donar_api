class CreateLoginActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :login_activities do |t|
      t.string :user_agent
      t.string :address_ip
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
