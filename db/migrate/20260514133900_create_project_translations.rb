class CreateProjectTranslations < ActiveRecord::Migration[8.1]
  def change
    create_table :project_translations do |t|
      t.references :project, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :title, null: false
      t.text :summary

      t.timestamps
    end

    add_index :project_translations,
      [ :project_id, :locale ],
      unique: true,
      name: "idx_project_translations_on_project_and_locale"
  end
end
