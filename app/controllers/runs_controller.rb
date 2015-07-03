class RunsController < ApplicationController

  # Call back
  skip_before_action :verify_authenticity_token
  before_action :validate_api_format, only: [:create, :update, :delete]
  before_action :valid_run_params_for_create, only: [:create]
  before_action :valid_run_params_for_show, only: [:show]
  before_action :validate_order_params_for_submit, only: [:submit]

  # POST /runs/create
  # POST /runs/create.json
  def create
    # Create new run
    run = Run.new(run_params)
    # Raise error if can not save
    raise CoffeeRunError.new("Can not create run") unless run.save

    # Generate shortener url
    bitly = Bitly.client.shorten(CONFIG["coffee_run_url"] + runs_show_path(no: run.no))
    raise CoffeeRunError.new("Can not generate shortener url") if bitly.nil? || bitly.short_url.blank?

    # TODO: Perform worker
    # UpdateRunningTimeWorker.perform_async(run.running_time * 60, run.no)

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
    get_existed_run

    gon.no = @run.no
    get_running_time

    gon.running_time = @run.expired_at.strftime("%Y/%m/%d %H:%M:%S")
    gon.ordered = (@running_time == 0) ? true : false

    get_orderers
  end

  # GET /runs/runned_list
  def runned_list
    if request.xhr?
      get_existed_run
      get_orderers
      get_running_time

      render :partial => "runned_list", :content_type => "text/html"
    else
      # Do nothing
    end
  end

  # GET /runs/running_list
  def running_list
    if request.xhr?
      get_existed_run
      get_orderers
      get_running_time

      render :partial => "running_list", :content_type => "text/html"
    else
      # Do nothing
    end
  end

  # POST /runs/submit
  # POST /runs/submit.json
  def submit
    if request.xhr?
      get_existed_run
      raise CoffeeRunError.new("Can not submit order") unless @run.orderers.create(order_params)
      get_orderers
      Pusher["private-runs_channel-#{@run.no}"].trigger("add_order", {
        id: session[:authorize_token],
        name: params[:order][:name],
        beverage: params[:order][:beverage]
      })
      session[:ordered] = "true"
      get_running_time

      render :partial => "runned_list", :content_type => "text/html"
    else
      # Do nothing
    end
  end

  private

  def run_params
    params.require(:run).permit(:runner, :running_time, :cups, :expired_at)
  end

  def order_params
    params.require(:order).permit(:name, :beverage)
  end

  def get_existed_run
    @run = Run.find_by_no(params[:no]).to_a
    raise CoffeeRunError.new("Run not found") if @run.empty?
    @run = @run.first
  end

  def get_orderers
    @orderers = @run.orderers.all.to_a
  end

  def valid_run_params_for_create
    raise CoffeeRunError.new("Missing or unvalid parameters") if params[:run].blank? || params[:run][:runner].blank? || params[:run][:running_time].blank? || params[:run][:cups].blank?
    params[:run][:expired_at] = Time.now + params[:run][:running_time].to_i.minutes
  end

  def valid_run_params_for_show
    raise CoffeeRunError.new("Missing or unvalid parameters") if params[:no].blank?
  end

  def validate_order_params_for_submit
    invalid = false
    if params[:order].blank? || params[:order][:name].blank? || params[:order][:beverage].blank?
      invalid = true
    else
      invalid = isGibberish(params[:order][:beverage])
    end

    raise CoffeeRunError.new("Missing or unvalid parameters") if invalid
  end

  def isGibberish beverage
    v = 1
    c = 1
    gibberish = false

  	if !beverage.blank?
  		len = beverage.length - 1

      (0..len).each do |i|
        if beverage[i].match /[aeiou]/i
          v += 1
        elsif beverage[i].match /[bcdfghjklmnpqrstvwxyz]/i
          c += 1
        end
      end

  		ratio = v * 1.0 /(c + v)
  		if ratio < 0.3 || ratio > 0.6
  			gibberish = true
  		end
  	end

  	return gibberish
  end

  def get_running_time
    current_time = Time.now.utc
    if session[:ordered] == "true"
      @running_time = 0
    else
      @running_time = (@run.expired_at > current_time) ? (@run.expired_at - current_time).round : 0
    end
  end

end
