class AppController < ApplicationController
  before_action :set_app, only: [:show, :update]

  def show
    render json: @app , except: [:id]
  end

  def update
    @app.lock!
    if @app.update(app_params)
      render status: :ok
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end

  def create
    @app = App.new(app_params)

    if @app.save
      render json: {token:@app.token}, status: :created, location: @app 
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end
  private
    # Use callbacks to share app setup or constraints between actions.
    def set_app
      @app = App.find_by( token: params[:id])
      if !@app 
        render json: { error: "app not found"}, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:name )
    end
end
