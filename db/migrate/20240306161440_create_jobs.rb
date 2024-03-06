class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false, index: true
      t.text :description

      t.timestamps
    end
  end
end
