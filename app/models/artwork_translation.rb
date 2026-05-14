class ArtworkTranslation < ApplicationRecord
  belongs_to :artwork

  validates :locale, presence: true, inclusion: { in: %w[pt en] }
  validates :title, :alt_text, presence: true
  validates :locale, uniqueness: { scope: :artwork_id }
end
