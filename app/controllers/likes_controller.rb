class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(likes_params)
    unless @like.save
      flash[:alert] = @like.errors.full_messages.to_sentence
    end

    redirect_back(fallback_location: '@like.post')
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    likeable = @like.likeable

    @like.destroy
    redirect_back(fallback_location: '@like.post')
  end

  private

  def likes_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
