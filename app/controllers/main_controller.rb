class MainController < ApplicationController
  layout 'plain'
  def index
  end

  def pages
    if params[:page_url] == 'runners'
      @runners = Registration.active.approved.where.not(registration_no: nil).order('registration_no ASC')
    end
    render "main/pages/#{params[:page_url].underscore}"
  end
end
