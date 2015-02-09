class BoxController < ApplicationController
  def index 
    @box = Box.where(:path => params[:name]).first
    @items = @box.items
    @children = @box.children
  end
end
