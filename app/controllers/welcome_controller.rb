# @todo rename WelcomeController to UrlController
class WelcomeController < ApplicationController
  def index
    @urls = Url.order(id: :desc).all
  end

  def sync
    urls = params[:urls]
    if urls
      urls.each do |url|
        Url.create(name: url)
      end
    end
    # Url.create(name: u)
    # end
    render json: {status: :ok}
  end


  def create
    # @todo maybe I need to implement this method for creating one item after
  end

end
