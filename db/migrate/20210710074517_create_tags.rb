class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :book_tags do |t|
      t.string :tag_name

      t.timestamps
    end
  end
end
