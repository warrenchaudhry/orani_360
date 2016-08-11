class UrlConstraint
  def matches?(request)
    params = request.path_parameters

    return false unless %w(about contact-us downloads runners results).include? params[:page_url]
    true
  end
end