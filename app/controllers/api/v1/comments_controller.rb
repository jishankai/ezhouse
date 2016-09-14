# coding: utf-8
module Api
  module V1
    class CommentsController < ApplicationController
      prepend_before_action :get_model
      before_action :get_comment, :only => [:show, :edit, :update, :destroy]

      skip_before_action :verify_authenticity_token

      def index
        @comments = @model.comments

        render json: @comments
      end

      def show
        render json: @comment
      end

      api :POST, "/api/v1/comments", "添加评论"
      param :agent_id, String, :desc => "被评论经纪人id", :required => true
      param :comment, Hash, :desc => "评论数据", :required => true do
        param :author, String, :desc => "用户电话", :required => true
        param :community, String, :desc => "带看小区"
        param :kind, ["nice", "common", "bad"], :desc => "评论种类", :required => true
        param :text, String, :desc => "评论内容", :required => true
      end
      def create
        @comment = @model.create_comment!(comment_params)
        if @comment.save
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update_attributes(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
        head :no_content
      end

      private

      def get_model
        @model = params.each do |name, value|
          if name =~ /(.+)_id$/
            break $1.classify.camelize.constantize.find(value)
          end
        end
      end

      def get_comment
        @comment = @model.comments.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:text, :author, :kind, :community)
      end
    end
  end
end
