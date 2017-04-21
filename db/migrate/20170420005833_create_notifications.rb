class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :username
      t.text :text
      t.string :touser
      t.string :msgtype
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
