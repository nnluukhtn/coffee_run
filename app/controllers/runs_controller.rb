class RunsController < ApplicationController

  # Call back
  skip_before_action :verify_authenticity_token
  before_action :validate_api_format, only: [:create, :update, :delete]
  before_action :valid_run_params_for_create, only: [:create]

  # POST /runs/create
  # POST /runs/create.json
  def create
    # Create new run
    run = Run.new(run_params)
    # Raise error if can not save
    raise "Can not create run" unless run.save

    # Generate shortener url
    bitly = Bitly.client.shorten(CONFIG["coffee_run_url"])
    raise "Can not generate shortener url" if bitly.nil? || bitly.short_url.blank?

    render json: { "ok": true, "url": bitly.short_url }, status: :ok
  end

  # POST /runs/update
  # POST /runs/update.json
  def update
  end

  # POST /runs/delete
  # POST /runs/delete.json
  def delete
  end

  # GET /runs/show
  def show
  end

  private

  def run_params
    params.require(:run).permit(:runner, :running_time, :cups)
  end

  def valid_run_params_for_create
    raise "Missing or unvalid parameters" if params[:run].blank? || params[:run][:runner].blank? || params[:run][:running_time].blank? || params[:run][:cups].blank?
  end

end
