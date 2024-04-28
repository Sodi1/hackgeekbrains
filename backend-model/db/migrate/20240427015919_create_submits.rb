class CreateSubmits < ActiveRecord::Migration[7.1]
  def change
    create_table :submits do |t|
      t.text :file_content
      t.timestamps
    end
  end
end
