class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  #before_action :set_editor, only: [:create, :update, :destroy]

  def index
    @customers = Customer.order(:last_name).all
  end

  def new
    @customer = Customer.new
    @customer.contact_numbers.build
  end

  def create
    @customer = Customer.new(customer_params)
    set_editor
    if @customer.valid?
      @customer.save
      flash[:success] = 'Customer has been added'
      redirect_to customers_path
    else
      p @customer.errors.full_messages
      render :new
    end
  end

  def edit

  end

  def update
    set_editor
    if @customer.update_attributes(customer_params)
      flash[:success] = 'Customer has been updated'
      redirect_to customers_path
    else
      render :edit
    end
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def set_editor
      if current_user.present?
        if @customer.new_record?
          @customer.created_by = current_user.id
        end
        @customer.last_updated_by = current_user.id
      end
    end

    def customer_params
      params.require(:customer).permit!
    end
end
