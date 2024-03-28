require "open-uri"
require "nokogiri"
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @user = current_user

    html_file = URI.open(@post.url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    @bigger_photo = html_doc.at_css(".post-header__image-container .image__img").attribute("src").value
  end
end
