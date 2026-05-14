class Project < ApplicationRecord
  STATUSES = %w[draft ongoing finished paused future].freeze
  VISIBILITIES = %w[public private].freeze

  belongs_to :portfolio_category
  belongs_to :cover_artwork, class_name: "Artwork", optional: true
  has_many :translations, class_name: "ProjectTranslation", dependent: :destroy
  has_many :artworks, dependent: :destroy

  validates :slug, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :visibility, presence: true, inclusion: { in: VISIBILITIES }
  validates :sort_order, numericality: { only_integer: true }

  scope :publicly_visible, -> { where(visibility: "public") }
  scope :featured, -> { where(is_featured: true) }
  scope :ordered, -> { order(:sort_order, :slug) }

  def title(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.title || slug.humanize
  end

  def summary(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.summary
  end
end
