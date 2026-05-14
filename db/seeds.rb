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
  [ "runika-page-1", "runika", sample_pages, "insum/Paginas sequenciais_/runika/ARUNIKA_PAGINA1_GABRIELSLIMA.jpg", 10 ],
  [ "runika-page-2", "runika", sample_pages, "insum/Paginas sequenciais_/runika/ARUNIKA_PAGINA2_GABRIELSLIMA.jpg", 11 ],
  [ "runika-page-3", "runika", sample_pages, "insum/Paginas sequenciais_/runika/ARUNIKA_PAGINA3_GABRIELSLIMA.jpg", 12 ],
  [ "the-punisher-page-1", "the-punisher", sample_pages, "insum/Paginas sequenciais_/the punisher (justiceiro)/THEPUNISHER_BIELSDL_PG1.jpg", 20 ],
  [ "the-punisher-page-2", "the-punisher", sample_pages, "insum/Paginas sequenciais_/the punisher (justiceiro)/THEPUNISHER_BIELSDL_PG2.jpg", 21 ],
  [ "the-punisher-page-3", "the-punisher", sample_pages, "insum/Paginas sequenciais_/the punisher (justiceiro)/THEPUNISHER_BIELSDL_PG3.jpg", 22 ],
  [ "conan", nil, illustrations, "insum/ilustrações e comissions/CONAN JPG FINALIZADO.jpg", 100 ],
  [ "venom-2025", nil, illustrations, "insum/ilustrações e comissions/VENOMGS2025PRINT.jpg", 101 ],
  [ "vampirella", nil, illustrations, "insum/ilustrações e comissions/VAMPIRELA ART FINAL JPG.jpg", 102 ]
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
