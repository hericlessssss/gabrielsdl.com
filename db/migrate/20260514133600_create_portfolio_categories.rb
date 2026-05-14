class CreatePortfolioCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolio_categories do |t|
      t.string :slug, null: false
      t.integer :sort_order, null: false, default: 0
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end

    add_index :portfolio_categories, :slug, unique: true
  end
end
