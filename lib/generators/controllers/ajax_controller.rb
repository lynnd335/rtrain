class rt_mod_cap_plurController < ApplicationController
  before_action :set_rt_mod_low, only: [:show, :edit, :update, :destroy]

	def index
	  @rt_mod_low_plur = rt_mod_cap.all
	end

	def show
	  @rt_mod_low_plur = rt_mod_cap.all
	end

	def new
	    @rt_mod_low = rt_mod_cap.new
	end

	def edit
	    @rt_mod_low = rt_mod_cap.find(params[:id])
	end

	def create
	   @rt_mod_low_plur = rt_mod_cap.all
	   @rt_mod_low = rt_mod_cap.create(rt_mod_low_params)
	end

	def update
	    @rt_mod_low_plur = rt_mod_cap.all
	    @rt_mod_low = rt_mod_cap.find(params[:id])    
	    @rt_mod_low.update_attributes(rt_mod_low_params)
	end

	def delete
	    @rt_mod_low = rt_mod_cap.find(params[:id])
	end

	def destroy
	   @rt_mod_low_plur = rt_mod_cap.all
	   @rt_mod_low = rt_mod_cap.find(params[:id])
	   @rt_mod_low.destroy
	end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_rt_mod_low
      @rt_mod_low = rt_mod_cap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rt_mod_low_params
      params.require(:rt_mod_low).permit(<-- permit_cols -->)
    end
end	