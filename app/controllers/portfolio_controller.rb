class PortfolioController < ApplicationController
  def index
    @categories = PortfolioCategory.active.ordered.includes(:translations)
    @current_category = @categories.find { |category| category.slug == params[:category] }
    @artworks = Artwork.publicly_visible.ordered.includes(:translations, image_attachment: :blob)
    @artworks = @artworks.where(portfolio_category: @current_category) if @current_category
  end
end
