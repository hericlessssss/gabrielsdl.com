class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :portfolio_category, null: false, foreign_key: true
      t.string :slug, null: false
      t.integer :year
      t.string :status, null: false, default: "finished"
      t.string :visibility, null: false, default: "public"
      t.integer :sort_order, null: false, default: 0
      t.boolean :is_featured, null: false, default: false

      t.timestamps
    end

    add_index :projects, :slug, unique: true
    add_index :projects, [ :visibility, :sort_order ]
  end
end
