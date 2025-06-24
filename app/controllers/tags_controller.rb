class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = Tag.all
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tags_path, notice: "Tag updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_path, notice: "Tag deleted successfully"
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
