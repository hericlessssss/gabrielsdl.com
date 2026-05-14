require "application_system_test_case"

class PortfolioLightboxTest < ApplicationSystemTestCase
  test "visitor navigates portfolio images in the lightbox" do
    category = PortfolioCategory.create!(slug: "sample-pages", sort_order: 1).tap do |category|
      category.translations.create!(locale: "en", name: "Sample pages")
    end
    project = Project.create!(
      slug: "runika",
      portfolio_category: category,
      visibility: "public",
      status: "finished",
      sort_order: 1
    ).tap { |project| project.translations.create!(locale: "en", title: "Runika") }

    attach_artwork(project:, category:, slug: "runika-page-1", title: "Runika page 1", filename: "runika-page-1.jpg", sort_order: 1)
    attach_artwork(project:, category:, slug: "runika-page-2", title: "Runika page 2", filename: "runika-page-2.jpg", sort_order: 2)

    visit portfolio_path(locale: :en)
    click_button "Runika page 1"

    assert_selector "dialog[open]"
    assert_selector "figcaption", text: "RUNIKA PAGE 1"

    click_button "Next"
    assert_selector "figcaption", text: "RUNIKA PAGE 2"

    click_button "Previous"
    assert_selector "figcaption", text: "RUNIKA PAGE 1"

    click_button "Close"
    assert_no_selector "dialog[open]"
  end

  private

  def attach_artwork(project:, category:, slug:, title:, filename:, sort_order:)
    Artwork.create!(
      slug: slug,
      project: project,
      portfolio_category: category,
      visibility: "public",
      sort_order: sort_order
    ).tap do |artwork|
      artwork.translations.create!(locale: "en", title: title, alt_text: title)
      artwork.image.attach(
        io: Rails.root.join("app/assets/images/portfolio/#{filename}").open,
        filename: filename,
        content_type: "image/jpeg"
      )
    end
  end
end
