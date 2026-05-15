def upsert_translation(record, attributes)
  translation = record.translations.find_or_initialize_by(locale: attributes.fetch(:locale))
  translation.update!(attributes)
end

categories = [
  [ "sample-pages", 10, { pt: "Sample pages", en: "Sample pages" } ],
  [ "illustrations", 20, { pt: "Ilustrações", en: "Illustrations" } ],
  [ "covers", 30, { pt: "Capas", en: "Covers" } ],
  [ "commissions", 40, { pt: "Commissions", en: "Commissions" } ]
]

categories.each do |slug, sort_order, names|
  category = PortfolioCategory.find_or_initialize_by(slug: slug)
  category.update!(sort_order: sort_order, is_active: true)

  names.each do |locale, name|
    upsert_translation(category, locale: locale.to_s, name: name)
  end
end

sample_pages = PortfolioCategory.find_by!(slug: "sample-pages")
illustrations = PortfolioCategory.find_by!(slug: "illustrations")

projects = [
  {
    slug: "runika",
    category: sample_pages,
    sort_order: 10,
    featured: true,
    title: { pt: "Runika", en: "Runika" },
    summary: {
      pt: "Sample pages com foco em narrativa urbana, atmosfera e leitura de página.",
      en: "Sample pages focused on urban storytelling, atmosphere, and page flow."
    }
  },
  {
    slug: "the-punisher",
    category: sample_pages,
    sort_order: 20,
    featured: true,
    title: { pt: "Justiceiro", en: "The Punisher" },
    summary: {
      pt: "Sample pages em preto e branco, com ação, ritmo e composição de página.",
      en: "Black-and-white sample pages with action, pacing, and page composition."
    }
  },
  {
    slug: "a-verdadeira-historia-do-bicho-papao",
    category: sample_pages,
    sort_order: 30,
    featured: false,
    title: {
      pt: "A verdadeira história do bicho-papão",
      en: "The True Story of the Boogeyman"
    },
    summary: {
      pt: "Sequência de páginas com clima de mistério e terror.",
      en: "A page sequence with mystery and horror atmosphere."
    }
  }
]

projects.each do |data|
  project = Project.find_or_initialize_by(slug: data.fetch(:slug))
  project.update!(
    portfolio_category: data.fetch(:category),
    status: "finished",
    visibility: "public",
    sort_order: data.fetch(:sort_order),
    is_featured: data.fetch(:featured)
  )

  data.fetch(:title).each do |locale, title|
    upsert_translation(
      project,
      locale: locale.to_s,
      title: title,
      summary: data.fetch(:summary).fetch(locale)
    )
  end
end

artworks = [
  [ "runika-page-1", "runika", sample_pages, "app/assets/images/portfolio/runika-page-1.jpg", 10 ],
  [ "runika-page-2", "runika", sample_pages, "app/assets/images/portfolio/runika-page-2.jpg", 11 ],
  [ "runika-page-3", "runika", sample_pages, "app/assets/images/portfolio/runika-page-3.jpg", 12 ],
  [ "the-punisher-page-1", "the-punisher", sample_pages, "app/assets/images/portfolio/the-punisher-page-1.jpg", 20 ],
  [ "the-punisher-page-2", "the-punisher", sample_pages, "app/assets/images/portfolio/the-punisher-page-2.jpg", 21 ],
  [ "the-punisher-page-3", "the-punisher", sample_pages, "app/assets/images/portfolio/the-punisher-page-3.jpg", 22 ],
  [ "bicho-papao-page-1", "a-verdadeira-historia-do-bicho-papao", sample_pages, "app/assets/images/portfolio/bicho-papao-page-1.jpg", 30 ],
  [ "bicho-papao-page-2", "a-verdadeira-historia-do-bicho-papao", sample_pages, "app/assets/images/portfolio/bicho-papao-page-2.jpg", 31 ],
  [ "bicho-papao-page-3", "a-verdadeira-historia-do-bicho-papao", sample_pages, "app/assets/images/portfolio/bicho-papao-page-3.jpg", 32 ],
  [ "conan", nil, illustrations, "app/assets/images/portfolio/conan.jpg", 100 ],
  [ "eric", nil, illustrations, "app/assets/images/portfolio/eric.jpg", 101 ],
  [ "illyana", nil, illustrations, "app/assets/images/portfolio/illyana.jpg", 102 ],
  [ "invencivel", nil, illustrations, "app/assets/images/portfolio/invencivel.jpg", 103 ],
  [ "jubileu", nil, illustrations, "app/assets/images/portfolio/jubileu.jpg", 104 ],
  [ "noturno", nil, illustrations, "app/assets/images/portfolio/noturno.jpg", 105 ],
  [ "print-1-dc-1", nil, illustrations, "app/assets/images/portfolio/print-1-dc-1.jpg", 106 ],
  [ "psylocke", nil, illustrations, "app/assets/images/portfolio/psylocke.jpg", 107 ],
  [ "spider-art", nil, illustrations, "app/assets/images/portfolio/spider-art.jpg", 108 ],
  [ "spiderpunk", nil, illustrations, "app/assets/images/portfolio/spiderpunk.jpg", 109 ],
  [ "storm", nil, illustrations, "app/assets/images/portfolio/storm.jpg", 110 ],
  [ "vampirella", nil, illustrations, "app/assets/images/portfolio/vampirella.jpg", 111 ],
  [ "venom-2025", nil, illustrations, "app/assets/images/portfolio/venom-2025.jpg", 112 ]
]

artworks.each do |slug, project_slug, category, relative_path, sort_order|
  artwork = Artwork.find_or_initialize_by(slug: slug)
  artwork.update!(
    project: project_slug.present? ? Project.find_by!(slug: project_slug) : nil,
    portfolio_category: category,
    visibility: "public",
    sort_order: sort_order,
    is_cover: sort_order % 10 == 0
  )

  title = slug.humanize
  {
    pt: "#{title} por Gabriel SDL",
    en: "#{title} by Gabriel SDL"
  }.each do |locale, localized_title|
    upsert_translation(
      artwork,
      locale: locale.to_s,
      title: localized_title,
      alt_text: localized_title,
      caption: nil
    )
  end

  file_path = Rails.root.join(relative_path)
  next unless file_path.exist? && !artwork.image.attached?

  artwork.image.attach(
    io: file_path.open("rb"),
    filename: file_path.basename.to_s,
    content_type: "image/jpeg"
  )
end

Project.find_by!(slug: "runika").update!(cover_artwork: Artwork.find_by(slug: "runika-page-1"))
Project.find_by!(slug: "the-punisher").update!(cover_artwork: Artwork.find_by(slug: "the-punisher-page-1"))
Project.find_by!(slug: "a-verdadeira-historia-do-bicho-papao").update!(cover_artwork: Artwork.find_by(slug: "bicho-papao-page-1"))
