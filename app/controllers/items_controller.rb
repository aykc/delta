class ItemsController < ApplicationController
  def index
    @items = Item.all
  end
  def show
    @item = Item.find params[:id]
  end
  def new
    @category = Category.find(params[:category_id])
    @item = Item.new(category_id: @category.id)
  end
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item
    else
      render 'new'
    end
    # render html: ("<pre>" + params.inspect + "</pre>").html_safe
  end

  public
    def item_params
      params.require(:item).permit(:id, :name, :category_id, options_attributes: [:id, :value])
    end
end
