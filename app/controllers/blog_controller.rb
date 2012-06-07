class BlogController < ApplicationController
  def index
    @blog = Blog.new
    post1 = @blog.new_post
    post1.title = "Post 1 "
    post1.body = "This is the first post"
    post1.publish
    post2 = @blog.new_post(title: "Post 2")
    post2.body = "This is the second post"
    post2.publish
  end
end
