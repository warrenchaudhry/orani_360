class MainController < ApplicationController
  layout 'plain'
  def index
  end

  def pages
    render "main/pages/#{params[:page_url].underscore}"
  end
end
