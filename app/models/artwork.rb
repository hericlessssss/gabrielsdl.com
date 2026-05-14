class Artwork < ApplicationRecord
  VISIBILITIES = %w[public private].freeze

  belongs_to :project, optional: true
  belongs_to :portfolio_category
  has_many :translations, class_name: "ArtworkTranslation", dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 900, 1200 ]
  end

  validates :slug, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: { in: VISIBILITIES }
  validates :sort_order, numericality: { only_integer: true }

  scope :publicly_visible, -> { where(visibility: "public") }
  scope :ordered, -> { order(:sort_order, :slug) }
  scope :project_pages_first, -> { order(Arel.sql("project_id NULLS LAST"), :sort_order, :slug) }

  def title(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.title || slug.tr("-", " ").titleize
  end

  def alt_text(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.alt_text || title(locale)
  end

  def caption(locale = I18n.locale)
    translations.find { |translation| translation.locale == locale.to_s }&.caption
  end
end
