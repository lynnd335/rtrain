class MainController < ApplicationController
    def show
    	render template: "main/#{params[:page]}"
    end
  end  