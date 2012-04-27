# coding: utf-8

module TagsHelper

  def link_icon_to(action, title, target, icon_options = {}, link_url_options = {}, link_html_options = {})
    icon_options[:title] = title
    link_to icon_tag(action, icon_options), target, link_url_options, link_html_options
  end

  def icon_tag(action, options = {})
    icon_size = ICON_SIZE[options.delete(:icon_size)] || ICON_SIZE[:tiny]
    icon_name = ACTION_TO_ICON[action.to_sym]
    icon_path = "/assets/must_have_icon_set/#{icon_name}/#{icon_name}_#{icon_size}.png"
    options[:width], options[:height] = icon_size.split("x")
    options[:src] = icon_path
    tag('img', options)
  end

  private

  ACTION_TO_ICON = {
      ok:       'Check',
      cancel:   'Cancel',
      add:      'Add',
      edit:     'Edit',
      view:     'Preview',
      delete:   'Delete',
      back:     'Undo'
  }

  ICON_SIZE = {
      tiny:     '16x16',
      small:    '24x24',
      normal:   '32x32',
      large:    '48x48',
      huge:     '256x256'
  }

end