module ApplicationHelper
  def navigation_link(label, path, active:)
    link_to label,
      path,
      aria: { current: ("page" if active) },
      class: class_names("nav-link", "nav-link-active": active)
  end
end
