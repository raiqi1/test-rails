class MenuItemsController < ApplicationController
  before_action :set_restaurant, only: [:index, :create]
  before_action :set_menu_item, only: [:update, :destroy]

  # GET /restaurants/:restaurant_id/menu_items
  def index
    @menu_items = @restaurant.menu_items.order(:name)

    @menu_items = @menu_items.where(category: params[:category]) if params[:category].present?
    @menu_items = @menu_items.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?

    @menu_items = @menu_items.page(params[:page]).per(params[:per_page] || 20)

    render json: {
      data: @menu_items.as_json(except: [:created_at, :updated_at, :restaurant_id]),
      meta: pagination_meta(@menu_items)
    }
  end

  # POST /restaurants/:restaurant_id/menu_items
  def create
    @menu_item = @restaurant.menu_items.new(menu_item_params)

    if @menu_item.save
      render json: { data: @menu_item.as_json(except: [:created_at, :updated_at]) }, status: :created
    else
      render_validation_errors(@menu_item)
    end
  end

  # PUT /menu_items/:id
  def update
    if @menu_item.update(menu_item_params)
      render json: { data: @menu_item.as_json(except: [:created_at, :updated_at]) }
    else
      render_validation_errors(@menu_item)
    end
  end

  # DELETE /menu_items/:id
  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Restaurant")
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Menu item")
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category, :is_available)
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end
