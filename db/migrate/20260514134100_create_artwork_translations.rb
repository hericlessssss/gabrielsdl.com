class CreateArtworkTranslations < ActiveRecord::Migration[8.1]
  def change
    create_table :artwork_translations do |t|
      t.references :artwork, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :title, null: false
      t.string :alt_text, null: false
      t.text :caption

      t.timestamps
    end

    add_index :artwork_translations,
      [ :artwork_id, :locale ],
      unique: true,
      name: "idx_artwork_translations_on_artwork_and_locale"
  end
end
