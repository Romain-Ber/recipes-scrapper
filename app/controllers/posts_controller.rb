require "open-uri"
require "nokogiri"
class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  def index
    @posts = Post.order(id: :desc)
    @post = Post.new
  end

  def show
    @comments = @post.comments
    @user = current_user

    html_file = URI.open(@post.url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    @bigger_photo = html_doc.at_css(".post-header__image-container .image__img").attribute("src").value
  end

  def create
    @post = Post.new(post_params)
    begin
      html_file = URI.open(@post.url).read
      html_doc = Nokogiri::HTML.parse(html_file)
      @post.title = html_doc.at_css(".post-header__title .heading-1").text
      @post.content = html_doc.at_css(".editor-content").text
      @post.photo = html_doc.at_css(".post-header__image-container .image__img").attribute("src").value
      @post.user = current_user
      if @post.save
        redirect_to @post, notice: "Recipe article referenced successfully!"
      else
        redirect_to @posts, notice: "Invalid recipe article url!"
      end
    rescue StandardError
      redirect_to posts_path, notice: "Invalid recipe article url or article not found!"
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url)
  end
end
