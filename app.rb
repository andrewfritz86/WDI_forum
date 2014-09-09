require 'sinatra/base'
require 'pry' # if ENV["RACK_ENV"] == "development"
require 'json'
require 'redis'
require 'uri'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################
#REDISTOGO_URL: redis://redistogo:f5674f911e85febab795662248492507@hoki.redistogo.com:11181/


  configure do
    enable :logging
    enable :method_override
    enable :sessions
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                        :port => uri.port,
                        :password => uri.password})
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end



  #####methods ########
  ##maybe this is the issue
  # $parsed = JSON.parse($redis.get('data'))

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

  get('/reorder') do
    @reorder = true
    @reorder_array = $parsed.sort do |item1, item2|
     item1["vote_count"] <=> item2["vote_count"]
    end
    render(:erb, :reorder)
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

  get('/topics/:topic/vote') do
    new_vote = JSON.parse($redis.get("data")).each do |x|
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
    new_hash = {
        "topic" => topic,
        "slug" => @slug,
        "username" => username,
        "body" => body,
        "vote_count" => 0,
        "messages" => [],
          }
    new_structure = JSON.parse($redis.get('data')).push(new_hash)
    new_structure = new_structure.to_json
    $redis.set('data',new_structure)
    redirect to('/topics')
  end


  post('/topics/:topic/new_message') do
    new_message = params["new_message"]
    topic = params["title"]
    slug = params["topic"]
    username = params["username"]
    new_hash = {"message" => new_message,
                "username" => username}
    new_structure = JSON.parse($redis.get("data")).each do |x|
      if x["topic"] == topic
        x["messages"].push(new_hash)
      end
    end
    new_structure = new_structure.to_json
    $redis.set('data',new_structure)
    redirect to("/topics/#{slug}")
  end



  ########deletes###
    delete('/topics') do
      delete_topic = params["topic"]
      binding.pry
      index = $parsed.index { |x| x["topic"] == delete_topic}
      $parsed.delete_at(index)
      new_structure = $parsed.to_json
      $redis.set('data',new_structure)
      redirect to('/topics')
    end



  end


