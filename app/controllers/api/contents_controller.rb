module Api
  class ContentsController < ApplicationController
    before_action :set_content, only: [ :show, :update, :destroy ]

    # GET /api/contents
    def index
      if params[:site_id].present?
        @contents = Content.where(site_id: params[:site_id])
      else
        @contents = Content.all
      end
      render json: @contents
    end

    # GET /api/contents/:id
    def show
      render json: @content
    end

    # POST /api/contents
    def create
      @content = Content.new(content_params)

      if @content.save
        render json: @content, status: :created
      else
        render json: { errors: @content.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/contents/:id
    def update
      if @content.update(content_params)
        render json: @content
      else
        render json: { errors: @content.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/contents/:id
    def destroy
      @content.destroy
      head :no_content
    end

    private

    def set_content
      @content = Content.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Content not found" }, status: :not_found
    end

    def content_params
      params.require(:content).permit(:site_id, :path, :content)
    end
  end
end
