class ConsumerTypesController < ApplicationController
  before_action :set_consumer_type, only: [:show, :edit, :update, :destroy]

  def index
    @consumer_types = ConsumerType.order(:name).all
  end

  def new
    @page_title = "New Consumer Type"
    @consumer_type = ConsumerType.new
  end

  def create
    @consumer_type = ConsumerType.new(consumer_type_params)
    set_editor
    if @consumer_type.valid?
      @consumer_type.save
      flash[:success] = 'Consumer type has been added.'
      redirect_to consumer_types_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    set_editor
    if @consumer_type.update_attributes(consumer_type_params)
      flash[:success] = 'Consumer type has been updated.'
      redirect_to consumer_types_path
    else
      render :edit
    end
  end

  def destroy

  end

  private
    def set_consumer_type
      @consumer_type = ConsumerType.find(params[:id])
    end

    def set_editor
      if current_user.present?
        if@consumer_type.new_record?
          @consumer_type.created_by = current_user.id
        end
        @consumer_type.last_updated_by = current_user.id
      end
    end

    def consumer_type_params
      params.require(:consumer_type).permit!
    end
end
