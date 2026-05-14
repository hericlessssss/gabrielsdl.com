class PortfolioCategory < ApplicationRecord
  has_many :translations, class_name: "PortfolioCategoryTranslation", dependent: :destroy
  has_many :projects, dependent: :restrict_with_exception
  has_many :artworks, dependent: :restrict_with_exception

  validates :slug, presence: true, uniqueness: true
  validates :sort_order, numericality: { only_integer: true }

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(:sort_order, :slug) }

  def name(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.name || slug.humanize
  end
end
