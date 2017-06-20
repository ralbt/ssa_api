class BirdsController < ApplicationController
  before_action :set_bird, only: [:show, :destroy]
  def index
    @birds = Bird.visible.all  # Paginate when records are huge
    json_response(BirdsResponse.all(@birds), :ok)
  end

  def create
    bird = Bird.create!(bird_params)
    json_response(bird, :created)
  end

  def show
    json_response(@bird, :ok)
  end

  def destroy
    if @bird.delete
      json_response({id: @bird.id}, :ok)
    else
      json_response({id: @bird.id}, :unprocessable_entity)
    end
  end

  private
    def bird_params
      params.permit(:name, :family, :added, :visible, continents: [])
    end

    def set_bird
      @bird = Bird.find(params[:id])
    end
end
