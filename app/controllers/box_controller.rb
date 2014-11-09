class BoxController < ApplicationController
  def index 
    @box = Box.where(:name => params[:name])
  end
end
