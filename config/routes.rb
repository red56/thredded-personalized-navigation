# frozen_string_literal: true

Thredded::Workgroup::Engine.routes.draw do
  controller "navs" do
    get "unread", action: :unread, as: :unread_nav
    get "following", action: :following, as: :following_nav
    get "all_topics", action: :all_topics, as: :all_topics_nav
    get "awaiting", action: :awaiting, as: :awaiting_nav
  end

  resources :topics, path: "w/topics", controller: "topics", only: [] do
    member do
      post "kick"
    end
  end

  put :mark_all_topics_read, to: "read_states#mark_all_topics_read", as: :mark_all_topics_read

  mount Thredded::Engine => "/"
end
