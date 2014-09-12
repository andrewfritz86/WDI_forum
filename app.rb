require './application_controller'
class App < ApplicationController

  get('/') do
    redirect to('/topics')
  end

  get('/reorder') do
    @reorder = true
    @reorder_array = parsed.sort do |topic1, topic2|
     topic1["vote_count"] <=> topic2["vote_count"]
    end
    render(:erb, :"topics/reorder")
  end

  get('/topics/new') do
    render(:erb, :'topics/new')
  end

  get('/topics/edit/:topic') do
    @slug = params[:topic]
    render(:erb, :'topics/edit')
  end

  get('/topics/:topic') do
    flash.now[:reply] if redirect? #issues with this
    @slug = params["topic"]
    render(:erb, :topics)
  end

  get('/topics') do
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
    render(:erb, :"messages/new")
  end

  get('/topics/:topic/messages') do
    @slug = params["topic"]
    render(:erb, :"meessages/index")
  end

  get('/topics/:topic') do
    @slug = params["topic"]
    render(:erb, :topics)
  end

################
## post routes
################


  post('/topics') do
    base_hash = {"vote_count" => 0,
              "messages" => [{}],
              "slug" => cleanup(params[:new_topic]["topic"])
    }
    new_topic = params[:new_topic].merge!(base_hash)
    new_structure = parsed.push(new_topic).to_json
    $redis.set('data',new_structure)
    flash.next[:notice] = "thanks for the post!" #need to fix
    redirect to('/topics')
  end


  post('/topics/:topic/new_message') do
    new_structure = parsed.each do |x|
      if x["slug"] == params["topic"]
        x["messages"].push(params[:new_message])
      end
    end
    $redis.set('data',new_structure.to_json)
    flash.next[:reply] = "thanks for the reply!"
    redirect to("/topics/#{params[:topic]}")
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


################
## put routes
################

    put('/topics') do
     new_structure = parsed.each do |x|
      binding.pry
        if x["slug"] == params[:slug]
          x["body"] = params[:new_body]
        end
      end
      $redis.set("data",new_structure.to_json)
      redirect to('/topics')
    end

end


