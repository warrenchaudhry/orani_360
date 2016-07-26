module ApplicationHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade in", role: 'alert') do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' },' arial-label': 'Close')
          concat message
      end)
    end
    nil
  end

  def add_new_resource_link
    link = link_to 'Add New <i class="fa fa-plus"></i>'.html_safe, url_for(controller: controller_name, action: 'new'), class: 'btn btn-sm btn-primary'
    raw(link)
  end

  def prettify_value(obj, attr)
    val = obj.send(attr)
    if obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :datetime
      val = "#{time_ago_in_words(val)} ago" rescue nil
    elsif obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :date
      val = val.to_s(:long) rescue nil
    elsif obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :boolean
      val = val ? 'Yes' : 'No'
    elsif attr == 'mi' && val.present?
      val = "#{val}."
    elsif attr == 'email' && val.present?
      val = mail_to val
    elsif attr == 'status' && val.present?
      val = val.capitalize
    end
    return '--' if val.blank?
    val
  end

  def sidebar_link(resource_name, label = nil, icon_class = nil)
    link_to send("admin_#{resource_name}_path"), class: (controller_name == resource_name ? 'active' : nil) do
      if icon_class.present?
        concat(content_tag(:i, nil, class: icon_class))
      end
      concat(content_tag(:span, label.present? ? label : resource_name.humanize.titleize, class: 'link-label'))
    end
  end

  def formalize_header(attr)
    if attr == 'editor'
      header = 'Last Updated By'
    elsif attr == 'display_name'
      header = 'Name'
    elsif attr == 'registration_no'
      header = 'Reg. No'
    elsif attr == 'date_registered'
      header = 'Registered At'
    elsif attr == 'last_login_from_ip_address'
      header = 'IP Address'
    else
      header = attr.humanize.titleize
    end
    header
  end

  def generate_breadcrumbs
    html = '<ol class="breadcrumb">' +
            '<li><a href='"#{admin_dashboards_path}"'><span class="fa fa-home"></span> Dashboard</a></li>' +
            '<li><a href='"#{url_for(controller: controller_name, action: 'index')}"'>' + controller_name.humanize.titleize + '</a></li>' +
            '<li class="active">' + (@page_action.present? ? @page_action.capitalize : action_name.humanize.capitalize) + '</li>' +
            '</ol>'

    raw(html)
  end

  def sortable(label, attr)
    sort_direction = params[:direction]
    sort_direction_params = sort_direction == 'DESC' ? 'ASC' : 'DESC'
    sort_icon_class = if params[:sort] == attr
                  sort_direction == 'DESC' ? 'fa fa-fw fa-sort-asc' : 'fa fa-fw fa-sort-desc'
                else
                  'fa fa-fw fa-sort unsorted'
                end
    link_to params.merge(sort: attr, direction: sort_direction_params) do
      concat(label)
      concat(content_tag(:i, nil, class: sort_icon_class))
    end
  end

end
