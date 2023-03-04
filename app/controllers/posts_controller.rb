class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]

  #instead of having nested image 1 withh all deatesa sn assosications with merge() just show url of image
  # GET /posts
  def index
    @posts = Post.all

    render json: @posts.each do |post|
        post.as_json(include: :images).merge(
        images: post.images.map {|image| url_for(image)}
      )
    end
  end

  # GET /posts/1
  def show
    render json: @post.as_json(include: :images).merge(
      images: @post.images.map {|image| url_for(image)}
    )
  end

  # POST /posts
  def create
    @post = Post.new(post_params.except(:images))
    images = params[:post][:images] 
    if images
      images.each {|image| @post.images.attach(image)}
    end

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    images = params[:post][:images] 
    if images
      images.each {|image| @post.images.attach(image)}
    end
    if @post.save(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(images: [])
    end
end
