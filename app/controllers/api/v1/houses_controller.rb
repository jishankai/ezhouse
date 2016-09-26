# coding: utf-8
module Api
  module V1
    class HousesController < ApplicationController
      prepend_before_action :get_model, :except => [:recommend, :search]
      before_action :get_house, :only => [:show, :edit, :update, :destroy]

      skip_before_action :verify_authenticity_token

      def index
        @houses = @model.houses

        render json: @houses
      end

      def show
        render json: @house
      end

      def create
        @house = @model.create_house!(house_params)
        if @house.save
          render json: @house
        else
          render json: @house.errors, status: :unprocessable_entity
        end
      end

      def update
        if @house.update_attributes(house_params)
          render json: @house
        else
          render json: @house.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @house.destroy
        head :no_content
      end

      def recommend
        @houses = Agent.where(:houses.exists => true)

        render json: @houses
      end

      def search
        @houses = Agent.where("houses.title": /.*#{params[:arg]}.*/).order_by(:created_at => -1)

        render json: @houses
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
        params.require(:house).permit(:text, :author, :kind)
      end
    end
  end
end
