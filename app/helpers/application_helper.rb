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

    if obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :datetime
      dt = obj.send(attr)

      val = "#{time_ago_in_words(obj.send(attr))} ago" rescue nil
    elsif obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :date
      dt = obj.send(attr)

      val = dt.to_s(:long) rescue nil
    elsif obj.class.column_names.include?(attr) && obj.column_for_attribute(attr).type == :boolean
      val = obj.send(attr) ? 'Yes' : 'No'
    elsif attr == 'mi'
      val = "#{obj.send(attr)}."
    elsif attr == 'email'
      val = mail_to obj.send(attr)
    else
      val = obj.send(attr)
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
            '<li class="active">' + action_name.capitalize + '</li>' +
            '</ol>'

    raw(html)
  end

end
