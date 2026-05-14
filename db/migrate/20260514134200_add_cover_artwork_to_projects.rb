class AddCoverArtworkToProjects < ActiveRecord::Migration[8.1]
  def change
    add_reference :projects, :cover_artwork, foreign_key: { to_table: :artworks }
  end
end
