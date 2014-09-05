require 'sinatra/base'
require 'pry'
require 'json'
require 'redis'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    $redis = Redis.new
    $size = $redis.keys.size
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # Routes
  ########################

  get('/') do
    redirect to ('/topics')
  end

  get('/topics/new') do
    render(:erb, :new_topic)
  end

  get('/topics') do
    @keys = $redis.keys
    render(:erb, :topics)
  end

  get('/topics/:topic') do
    @desired_topic = params["topic"]
    @all_topics = $redis.keys
    # binding.pry
    render(:erb, :topics)
  end

  # get('/topics/new') do
  #   render(:erb, :new_topic)
  # end

  post('/topics') do
    #there should be logic here to make sure that all fields are cointain
    #something, ie parameters aren't nil
    topic = params["topic"]#eventually this will gsub to a SLUG
    title = params["topic"]
    message = params["message"]
    username = params["username"]
    hash = {
        "topic" => topic,
        "username" => username,
        "message" => message
          }
    # binding.pry
    hash = hash.to_json
    $redis.set(topic,hash)
    # binding.pry
    redirect to('/topics')
  end

end
