class HousesController < ApplicationController
  prepend_before_action :get_model
  before_action :get_house, :only => [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @houses = @model.houses
    respond_with([@model,@houses])
  end

  def show
    respond_with([@model,@house])
  end

  def new
    respond_with([@model,@house = House.new(:parent => params[:parent])])
  end

  def edit
    respond_with([@model,@house])
  end

  def create
    @house = @model.houses.create!(house_params)
    if @house.save
      flash[:notice] = 'House was successfully created.'
    else
      flash[:error] = 'House wasn\'t created.'
    end
    respond_with(@model)
  end

  def update
    if @house.update_attributes(house_params)
      flash[:notice] = 'House was successfully updated.'
    else
      flash[:error] = 'House wasn\'t deleted.'
    end
    respond_with([@model,@house], :location => @model)
  end

  def destroy
    @house.destroy
    respond_with(@model)
  end

  private

  def get_model
    @model = params.each do |name, value|
      if name =~ /(.+)_id$/
        break $1.classify.camelize.constantize.find(value)
      end
    end
  end

  def get_house
    @house = @model.houses.find(params[:id])
  end

  def house_params
    params.require(:house).permit(:thumbs, :title, :price, :description, :model, :area, :toward, :type, :floor, :unit_price, :location)
  end

end
