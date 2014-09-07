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


################
# ###posts
################


  post('/topics') do
    #there should be logic here to make sure that all fields are cointain
    #something, ie parameters aren't nil
    topic = cleanup(params["topic"])#eventually this will gsub to a SLUG

    title = params["topic"]
    message = params["message"]
    username = params["username"]

    hash = {
        "topic" => topic,
        "username" => username,
        "messages" => [{"message" => message,
                        "username" => username,
        }
          ],
        "title" => title
          }
    hash = hash.to_json
    $redis.set(title,hash)
    # binding.pry
    redirect to('/topics')
  end

  get('/topics/:topic/new_message') do
    "plz god"
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
