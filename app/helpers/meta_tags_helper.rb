module MetaTagsHelper
  def page_title
    content_for(:title).presence || t("site.title")
  end

  def page_description
    content_for(:description).presence || t("site.description")
  end

  def alternate_locale_url(locale)
    url_for(params.permit!.to_h.merge(locale: locale, only_path: false))
  end
end
