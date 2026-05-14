class CreateArtworks < ActiveRecord::Migration[8.1]
  def change
    create_table :artworks do |t|
      t.references :project, foreign_key: true
      t.references :portfolio_category, null: false, foreign_key: true
      t.string :slug, null: false
      t.string :dominant_color
      t.integer :sort_order, null: false, default: 0
      t.boolean :is_cover, null: false, default: false
      t.string :visibility, null: false, default: "public"

      t.timestamps
    end

    add_index :artworks, :slug, unique: true
    add_index :artworks, [ :visibility, :sort_order ]
  end
end
