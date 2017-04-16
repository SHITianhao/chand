class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :hashtag_text
      t.integer :total_number, index: true, default: 0

      t.timestamps
    end
  end
end
