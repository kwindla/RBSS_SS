class CreateDlurls < ActiveRecord::Migration
  def change
    create_table :dlurls do |t|
    	t.string :address
      t.boolean :used
      t.string :artist

      t.timestamps
    end
  end
end
