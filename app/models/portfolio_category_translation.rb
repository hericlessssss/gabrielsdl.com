class PortfolioCategoryTranslation < ApplicationRecord
  belongs_to :portfolio_category

  validates :locale, presence: true, inclusion: { in: %w[pt en] }
  validates :name, presence: true
  validates :locale, uniqueness: { scope: :portfolio_category_id }
end
