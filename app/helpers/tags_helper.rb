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

  def paging_tags(table_name, options = {})
    pager_string = "{positionFixed: false, container: $('#pager')}"
    header_options = []
    sortList = []
    options.each do |k,v|
      case v
        when :nosort
          header_options << "#{k}: { sorter: false }"
        when :sort
          sortList << "[#{k}, 0]"
        when :rsort
          sortList << "[#{k}, 1]"
      end
    end
    header_string = "headers: { #{header_options.join(', ')} }" unless header_options.empty?
    sortList_string = "sortList: [ #{sortList.join(', ')} ]" unless sortList.empty?
    sorter_options = ["widgets: ['zebra']"]
    sorter_options << header_string if header_string
    sorter_options << sortList_string if sortList_string
    sorter_string = ''
    sorter_string = "{ #{sorter_options.join(', ')} }" unless sorter_options.empty?

    javascript_text = "$(document).ready(function () {$('##{table_name}').tablesorter(#{sorter_string}).tablesorterPager(#{pager_string});});"

    output = javascript_tag javascript_text

    form = image_tag 'first.png', class: 'first'
    form += image_tag 'prev.png', class: 'prev'
    form += tag 'input', type: 'text', class: 'pagedisplay'
    form += image_tag 'next.png', class: 'next'
    form += image_tag 'last.png', class: 'last'
    form += raw ' per: '
    form += tag 'input', type: 'text', class: 'pagesize', value: '10'

    form = content_tag 'form' do
      form
    end

    output += content_tag 'div', id: 'pager', class: 'pager' do
      form
    end

    output

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