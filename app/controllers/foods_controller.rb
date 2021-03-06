class FoodsController < ApplicationController
  before_action :load_foods, only: :show
  before_action :load_meta_data_for_current_food, only: :show
  
  def show
    @q = Food.ransack(params[:q])
    view = @food.view.nil? ? 0 : @food.view
    @food_relation = Food.filter_food_category(@food.food_category)
    @food.view = view + 1
    @food.save
  end

  def index
    @q = Food.ransack(params[:q])
    @new_foods = Food.newfood
    @hot_foods = Food.hotfood
    @hot_sale  = Food.hotsale
    @categories = FoodCategory.all
    @foods = Food.all
    if params[:q]
      @foods = @q.result
    elsif params[:food_category]
      @foods = Food.filter_food_category(params[:food_category])
    else
      @foods = Food.all
    end
    
    respond_to do |format|
      format.js
      format.html
    end
  end

  private
  
  def load_meta_data_for_current_food
    @comments = Comment.load_comment(@food).except_reply.select_fields
      .order_by_created_at
  end

  def load_foods
    @categories = FoodCategory.all
    @food = Food.find_by(id: params[:id]) || not_found
  end

  def food_params
      params.require(:food).permit :name, :img_url, :price,
                                   :rating_avg, :description, :food_category_id
  end

end
