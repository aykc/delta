class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.jsonb :options, default: {}

      t.timestamps
    end
  end
end
