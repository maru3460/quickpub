module Api
  class SitesController < ApplicationController
    before_action :set_site, only: [:show, :update, :destroy]
    
    # GET /api/sites
    def index
      @sites = Site.all
      render json: @sites
    end
    
    # GET /api/sites/:id
    def show
      render json: @site
    end
    
    # POST /api/sites
    def create
      @site = Site.new(site_params)
      
      if @site.save
        render json: @site, status: :created
      else
        render json: { errors: @site.errors }, status: :unprocessable_entity
      end
    end
    
    # PATCH/PUT /api/sites/:id
    def update
      if @site.update(site_params)
        render json: @site
      else
        render json: { errors: @site.errors }, status: :unprocessable_entity
      end
    end
    
    # DELETE /api/sites/:id
    def destroy
      @site.destroy
      head :no_content
    end
    
    private
    
    def set_site
      @site = Site.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Site not found' }, status: :not_found
    end
    
    def site_params
      params.require(:site).permit(:name, :description, :subdomain)
    end
  end
end