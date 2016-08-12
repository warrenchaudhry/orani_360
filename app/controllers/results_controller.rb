class ResultsController < ApplicationController
  layout 'plain'
  def index
    params[:cat] ||= '21K'
    @results = Result.where(category: params[:cat]).includes(:registration).references(:all).order('time_finished ASC')
    if params[:g].present? && %w(Male Female).include?(params[:g])
      @results = @results.where(gender: params[:g])
    end
    if params[:q].present?
      keyword = params[:q].strip.downcase
      @results = @results.where('TRIM(LOWER(registrations.first_name)) LIKE :keyword OR TRIM(LOWER(registrations.middle_name)) LIKE :keyword OR TRIM(LOWER(registrations.last_name)) LIKE :keyword OR TRIM(LOWER(registrations.registration_no)) LIKE :keyword OR TRIM(LOWER(registrations.grp_org_comp)) LIKE :keyword', keyword: "%#{keyword}%")
    end
  end
end
