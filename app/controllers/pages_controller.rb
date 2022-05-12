class PagesController < ApplicationController
  # before_action :authenticate_user!, expect: [home]

  def home
    if current_user
      redirect_to posts_path
    end
  end

end
