# frozen_string_literal: true
require_dependency File.expand_path("../../app/controllers/thredded/posts_controller", Thredded::Engine.called_from)

module Thredded
  module PostsControllerWhichRedirects
    def create
      post = parent_topic.posts.build(post_params)
      authorize_creating post
      post.save!
      user = thredded_current_user
      UserTopicReadState.touch!(user.id, post.postable_id, post, post.page(user: user))
      flash[:notice] = generate_flash_for(post)

      if params[:post_referer].present?
        redirect_to params[:post_referer]
      else
        redirect_to unread_nav_path
      end
    end

    private

    def after_mark_as_unread
      if post.private_topic_post?
        redirect_to private_topics_path
      else
        redirect_to thredded_workgroup.unread_nav_path
      end
    end

    def generate_flash_for(post)
      path_to_post = messageboard_topic_path(parent_topic.messageboard, parent_topic, anchor: "post_#{post.id}")
      # rubocop:disable Rails/OutputSafety
      "Successfully replied to #{view_context.link_to(parent_topic.title, path_to_post)}".html_safe
      # rubocop:enable Rails/OutputSafety
    end
  end

  class PostsController
    prepend ::Thredded::PostsControllerWhichRedirects
  end
end
