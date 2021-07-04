Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    # apiのurlにはバージョンに関する情報を加えるケースがある。apiを更新する場合にスイッチングしやすくするため。 下にnamespace :v2 doとか追記できる
    # api/vi/fuga_controller.rb api/v2/fuga_controller.rbと分類することができる。
    # only: %i[]で特定のルーティングしか生成できないようにすることができる。
    # put ...to:は~というrulに対してPUTリクエストが来たら、~#~のメソッドを呼ぶという意味。 get '~', to:'~#~'の書き方でもok
    namespace :v1 do
      resources :restaurants do
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace'
      resources :orders, only: %i[create]
    end
  end
end
