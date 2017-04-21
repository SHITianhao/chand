class CreateNotifocations < ActiveRecord::Migration
  def change
    create_table :notifocations do |t|
      t.string :username
      t.string :text
      t.string :fromuser
      t.string :msgtype

      t.timestamps
    end
  end
end
