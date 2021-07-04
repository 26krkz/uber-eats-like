module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create replace]

      def index
        #LineFood.activeはmodels/line_food.rbのactiveを参照
        line_foods = LineFood.active
        if line_foods.exist?
          render json: {
            line_food_ids: line_foods.map { |line_food| line_food.id },
            restaurant: line_foods[0].restaurant,
            count: lime_foods.sum { |line_food| line_food[:count] },
            amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
        else
          render json: {}, status: :no_content # リクエストは成功したが空データ。204
        end
      end

      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exist?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable # status code 406 not acceptable
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: { line_food: @line_food }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: { line_food: @line_food }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private
      # 特定のコントローラーのみでしか呼ばれないアクションはprivate内で定義する。

      #Foodをひとつ抽出しインスタンス変数に代入することで参照できるようにする。インスタンス変数はグローバルに定義する時のみ使用。どこからでも参照可能なため。
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      # 上記のexist?で例外パターンに当てはまらない場合にはline_foodインスタンスを生成。新しく生成する場合と、同じfoodに関するline_foodが存在する場合で分ける。
      def set_line_food(ordered_food)
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = { count: ordered_food.count + params[:count], active: true }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end