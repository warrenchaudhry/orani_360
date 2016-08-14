class ResultsController < ApplicationController
  layout 'plain'
  def index
    @results = []
    if params[:cat].present? || params[:g].present? || params[:q].present?
      @results = Result.includes(:registration).references(:all).order('time_finished ASC')
    end
    if params[:cat].present? && %w(21K 10K).include?(params[:cat])
      @results = @results.where(category: params[:cat])
    end
    if params[:g].present? && %w(Male Female).include?(params[:g])
      @results = @results.where(gender: params[:g])
    end
    if params[:q].present?
      keyword = params[:q].strip.downcase
      @results = @results.where('TRIM(LOWER(registrations.first_name)) LIKE :keyword OR TRIM(LOWER(registrations.middle_name)) LIKE :keyword OR TRIM(LOWER(registrations.last_name)) LIKE :keyword OR TRIM(LOWER(registrations.registration_no)) LIKE :keyword OR TRIM(LOWER(registrations.grp_org_comp)) LIKE :keyword', keyword: "%#{keyword}%")
    end
  end

  def leaderboard
    @results = Result.includes(:registration).references(:all).order('time_finished ASC')
  end
end
