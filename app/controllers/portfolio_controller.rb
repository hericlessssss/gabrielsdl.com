class PortfolioController < ApplicationController
  def index
    @categories = PortfolioCategory.active.ordered.includes(:translations)
    @current_category = @categories.find { |category| category.slug == params[:category] }
    @artworks = Artwork.publicly_visible.project_pages_first.includes(:project, :translations, image_attachment: :blob)
    @artworks = @artworks.where(portfolio_category: @current_category) if @current_category
    @artwork_groups = @artworks.group_by { |artwork| artwork.project || artwork.portfolio_category }
  end
end
