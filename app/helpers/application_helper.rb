module ApplicationHelper
  def navigation_link(label, path, active:)
    link_to label,
      path,
      aria: { current: ("page" if active) },
      class: class_names("nav-link", "nav-link-active": active)
  end

  def comic_button_class(active: false, variant: :secondary, extra: nil)
    class_names(
      "comic-button",
      extra,
      "comic-button-primary": variant == :primary,
      "comic-button-active": active
    )
  end
end
