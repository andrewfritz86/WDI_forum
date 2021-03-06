require 'sinatra/base'
require 'pry' # if ENV["RACK_ENV"] == "development"
require 'json'
require 'redis'
require 'uri'
require 'sinatra/flash'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                        :port => uri.port,
                        :password => uri.password})
    register Sinatra::Flash
  end


  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end



  #####methods ########

  def parsed
    JSON.parse($redis.get("data"))
  end

  def cleanup(string)
    string = string.delete("?").delete("'").delete(",")
    string.gsub!(" ","-")
    string
  end

  ########################
  # Routes
  ########################

  ############
  ##get routes
  ###########

  get('/') do
    redirect to ('/topics')
  end

  get('/reorder') do
    @reorder = true
    @reorder_array = parsed.sort do |topic1, topic2|
     topic1["vote_count"] <=> topic2["vote_count"]
    end
    render(:erb, :reorder)
  end

  get('/topics/new') do
    render(:erb, :new_topic)
  end

  get('/topics/:topic') do
    flash.now[:reply] = "thanks for the reply!" if redirect?
    @slug = params["topic"]
    render(:erb, :topics)
  end

  get('/topics') do
    flash.now[:notice] = "THANKS" if redirect?
    render(:erb, :topics)
  end

  get('/topics/:topic/vote') do
    new_vote = parsed.each do |x|
      if x["topic"] == params["correct_topic"]
        x["vote_count"] += 1
      end
    end
    new_vote = new_vote.to_json
    $redis.set('data',new_vote)
    redirect back
  end

  get('/topics/:topic/new_message') do
    @topic = params["correct_topic"]
    @slug = params["topic"]
    render(:erb, :new_message)
  end

  get('/topics/:topic/messages') do
    @slug = params["topic"]
    render(:erb, :all_messages)
  end

  get('/topics/:topic') do
    @slug = params["topic"]
    render(:erb, :topics)
  end







################
## post routes
################


  post('/topics') do
    #there should be logic here to make sure that all fields are cointain
    #something, ie parameters aren't nil
    slug = cleanup(params["topic"])
    topic = params["topic"]
    body = params["body"]
    username = params["username"]
    new_hash = {
        "topic" => topic,
        "slug" => slug,
        "username" => username,
        "body" => body,
        "vote_count" => 0,
        "messages" => [],
      }
    new_structure = parsed.push(new_hash)
    new_structure = new_structure.to_json
    $redis.set('data',new_structure)
    flash.next[:notice] = "thanks for the post!"
    redirect to('/topics')
  end


  post('/topics/:topic/new_message') do
    new_message = params["new_message"]
    topic = params["title"]
    slug = params["topic"]
    username = params["username"]
    new_hash = {"message" => new_message,
                "username" => username}
    new_structure = parsed.each do |x|
      if x["topic"] == topic
        x["messages"].push(new_hash)
      end
    end
    new_structure = new_structure.to_json
    $redis.set('data',new_structure)
    flash.next[:reply] = "thanks for the reply!"
    redirect to("/topics/#{slug}")
  end





################
## delete routes
################

    delete('/topics') do
      delete_topic = params["topic"]
      index = parsed.index { |x| x["topic"] == delete_topic}.to_i
      present_structure = parsed
      present_structure.delete_at(index)
      new_structure = present_structure.to_json
      $redis.set('data',new_structure)
      redirect to('/topics')
    end



  end


