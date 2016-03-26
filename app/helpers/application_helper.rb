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
      obj.send(attr).to_s(:long)
    elsif attr == 'mi'
      "#{obj.send(attr)}."
    else
      obj.send(attr)
    end
  end

end
