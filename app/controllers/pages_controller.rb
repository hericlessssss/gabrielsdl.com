class PagesController < ApplicationController
  def redirect_to_default_locale
    redirect_to localized_root_path(locale: I18n.default_locale)
  end

  def home
    @featured_projects = Project.publicly_visible.featured.ordered.includes(:translations, :artworks).limit(3)
    @recent_artworks = Artwork.publicly_visible.ordered.includes(:translations, image_attachment: :blob).limit(8)
  end

  def about
  end
end
