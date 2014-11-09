class BoxController < ApplicationController
  def index 
    @box = Box.where(:name => params[:name])
    @items = Item.where(:name => params[:name])
  end
end
