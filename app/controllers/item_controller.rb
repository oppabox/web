class ItemController < ApplicationController
  def view
    @item = Item.where(:path => params[:name]).first
  end
end
