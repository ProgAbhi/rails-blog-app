class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :filter_by_tag, only: [:index]

  # Ensures only the owner can edit/update/delete
  def correct_user
    redirect_to blogs_path, alert: "Not authorized" unless @blog.user == current_user
  end

  # GET /blogs
  def index
    # @blogs is already set by filter_by_tag
  end

  # GET /blogs/1
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
    # Prepare nested fields for form
    @blog.blog_tags.build.build_tag
  end

  # GET /blogs/1/edit
  def edit
    if @blog.blog_tags.empty?
      @blog.blog_tags.build.build_tag
    end
  end

  # POST /blogs
  def create
    @blog = current_user.blogs.build(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  def destroy
    @blog.destroy!
    respond_to do |format|
      format.html { redirect_to blogs_path, status: :see_other, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(
        :title, :description, :image,
        blog_tags_attributes: [
          :id, :rank, :_destroy,
          tag_attributes: [:id, :name]
        ]
      )
    end

    # Filter blogs based on selected tag
    def filter_by_tag
      if params[:tag_id].present?
        @blogs = Blog.joins(:tags).where(tags: { id: params[:tag_id] }).distinct
      else
        @blogs = Blog.all
      end
    end
end
