class ProjectTranslation < ApplicationRecord
  belongs_to :project

  validates :locale, presence: true, inclusion: { in: %w[pt en] }
  validates :title, presence: true
  validates :locale, uniqueness: { scope: :project_id }
end
