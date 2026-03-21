class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all.order(:name).page(params[:page]).per(params[:per_page] || 20)

    render json: {
      data: @restaurants.as_json(except: [:created_at, :updated_at]),
      meta: pagination_meta(@restaurants)
    }
  end

  # GET /restaurants/:id
  def show
    render json: {
      data: @restaurant.as_json(
        except: [:created_at, :updated_at],
        include: {
          menu_items: { except: [:created_at, :updated_at, :restaurant_id] }
        }
      )
    }
  end

  # POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: { data: @restaurant.as_json(except: [:created_at, :updated_at]) }, status: :created
    else
      render_validation_errors(@restaurant)
    end
  end

  # PUT /restaurants/:id
  def update
    if @restaurant.update(restaurant_params)
      render json: { data: @restaurant.as_json(except: [:created_at, :updated_at]) }
    else
      render_validation_errors(@restaurant)
    end
  end

  # DELETE /restaurants/:id
  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Restaurant")
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :opening_hours)
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
