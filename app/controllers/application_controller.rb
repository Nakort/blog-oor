class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_blog

  def init_blog
    @blog = Blog.new
  end

end
