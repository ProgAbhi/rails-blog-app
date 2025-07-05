class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :filter_by_tag, only: [:index]

  # POST /blogs/bulk_upload
  def bulk_upload
    if params[:file].present?
      # Ensure it's a CSV file by MIME type or extension
      if params[:file].content_type == "text/csv" || File.extname(params[:file].original_filename).downcase == ".csv"
        sanitized_filename = File.basename(params[:file].original_filename).gsub(/[^\w.\-]/, "_")
        file_path = Rails.root.join('tmp', sanitized_filename)

        File.open(file_path, 'wb') { |f| f.write(params[:file].read) }

        BulkBlogUploadWorker.perform_async(file_path.to_s, current_user.id)
        redirect_to blogs_path, notice: "Upload started! It will be processed shortly."
      else
        redirect_to blogs_path, alert: "Invalid file format. Please upload a valid CSV file."
      end
    else
      redirect_to blogs_path, alert: "Please upload a CSV file."
    end
  end

  # GET /blogs
  def index
    @total_blogs = Blog.count
    # @blogs is already set by filter_by_tag
  end

  # GET /blogs/1
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
    @blog.blog_tags.build.build_tag
  end

  # GET /blogs/1/edit
  def edit
    @blog.blog_tags.build.build_tag if @blog.blog_tags.empty?
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
    if @blog.destroy
      respond_to do |format|
        format.html { redirect_to blogs_path, status: :see_other, notice: "Blog was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to blogs_path, alert: "Failed to delete blog."
    end
  rescue => e
    logger.error "Blog delete failed: #{e.message}"
    redirect_to blogs_path, alert: "An error occurred while deleting the blog."
  end

  private

    def set_blog
      @blog = Blog.find_by(id: params[:id])
      redirect_to blogs_path, alert: "Blog not found." if @blog.nil?
    end

    def correct_user
      unless @blog&.user == current_user
        redirect_to blogs_path, alert: "Not authorized to perform this action."
      end
    end

    def blog_params
      params.require(:blog).permit(
        :title, :description, :image,
        blog_tags_attributes: [
          :id, :rank, :_destroy,
          tag_attributes: [:id, :name, :_destroy]
        ]
      )
    end

    # Filter blogs based on selected tag
    def filter_by_tag
      if params[:tag_id].present?
        @blogs = Blog.includes(:tags).joins(:tags).where(tags: { id: params[:tag_id] }).distinct
      else
        @blogs = Blog.includes(:tags).all
      end
    end
end
