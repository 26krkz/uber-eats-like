module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        restaurants = Restaurant.all

        # status: :okがリクエストが成功したときに、200 OKと一緒にデータを返すようになる。
        render json: { restaurants: restaurants }, status: :ok
      end
    end
  end
end