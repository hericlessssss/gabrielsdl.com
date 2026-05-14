class CreatePortfolioCategoryTranslations < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolio_category_translations do |t|
      t.references :portfolio_category, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :portfolio_category_translations,
      [ :portfolio_category_id, :locale ],
      unique: true,
      name: "idx_category_translations_on_category_and_locale"
  end
end
