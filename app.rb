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
    $parsed = JSON.parse($redis.get('data'))
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end



  #####methods ########


  def cleanup(string)
    string = string.delete("?").delete("'").delete(",")
    string.gsub!(" ","-")
    string
  end

  ########################
  # Routes
  ########################

  ############
  ##gets
  ###########

  get('/') do
    redirect to ('/topics')
  end

  get('/topics/new') do
    render(:erb, :new_topic)
  end


  get('/topics/:topic') do
    @slug = params["topic"]
    render(:erb, :topics)
  end

  get('/topics') do
    render(:erb, :topics)
  end


  get('/topics/:topic/new_message') do
    @title = params["correct_topic"]
    @url_topic = params["topic"]
    render(:erb, :new_message)
  end

  get('/topics/:topic') do
    @slug = params["topic"]

    render(:erb, :topics)
  end





################
# ###posts
################


  post('/topics') do
    #there should be logic here to make sure that all fields are cointain
    #something, ie parameters aren't nil
    @slug = cleanup(params["topic"])#eventually this will gsub to a SLUG
    ##title should be URL or URI
    topic = params["topic"]
    body = params["body"]
    username = params["username"]
    binding.pry

    new_hash = {
        "topic" => topic,
        "slug" => @slug,
        "username" => username,
        "body" => body,
        "vote_count" => 0,
        "messages" => [],
          }
    binding.pry
    new_structure = JSON.parse($redis.get('data')).push(new_hash)
    new_structure = new_structure.to_json
    $redis.set('data',new_structure)
    binding.pry
    redirect to('/topics')
  end


  post('/topics/:topic/new_message') do
    @new_message = params["new_message"]
    @topic_needed = params["title"]
    new_hash = {"message" => @new_message,
                "username" => "default"}
    parsed = JSON.parse($redis.get(@topic_needed))
    parsed["messages"].push(new_hash)
    json = parsed.to_json
    $redis.del(@topic_needed)
    $redis.set(@topic_needed,json)
    redirect to('/topics')

  end



  ########deletes###
    delete('/topics') do
    delete_topic = params["topic"]
    # binding.pry
    $redis.keys.each do |topic|
      if topic == delete_topic
        $redis.del(topic)
      end
    end
    redirect to('/topics')
    end
  end


########puts #####
  # put('/topics/:topic/new_message') do
  #   @current_hash = JSON.parse(redis.get(params["topic"]))
  #   @new_message = params["new_message"]
  #   @current_hash["messages"].push(@new_message)
  #   redirect to('/topics')
  # end
