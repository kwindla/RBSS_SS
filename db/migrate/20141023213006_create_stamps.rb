class CreateStamps < ActiveRecord::Migration
  def change
    create_table :stamps do |t|
      t.string :name
      t.integer :use_count

      t.timestamps
    end
  end
end
