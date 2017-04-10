class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.jsonb :options, default: {}

      t.timestamps
    end
  end
end
