###think of data as redis.set each hash individually

data = {
        "topic 1" => {
          :topic => "blah blah blah",
          :message => "opinion thought question etc",
          :username => "billybob"
        },

        "topic 2" => {
          :topic => "blah blah some more",
          :message => "more opinions",
          :username => "doug"
        },

        "topic 3" => {
          :topic => "yet another topic",
          :message => "yet another message ",
          :username => "joe"
        }
}

#^ each topic is a key, with a value of the name of the topic and a message
#this would be easier for deleting topics

#can use a data.keys array to keep track of the overall amount of topics
#for deleting, putting?


#how will this work with SLUG urls?

##post (/topics/new)
##


#should make methods for converting to json/adding , parsing/removing

###for pry testing

require 'redis'
require 'json'

redis = Redis.new

topic1 =

      {
          :topic => "blah blah blah",
          :message => "opinion thought question etc",
          :username => "billybob"
        }


topic2 =

  {
    :topic => "blah blah some more",
    :message => "more opinions",
    :username => "doug"
  }


topic3 =
  {
    :topic => "yet another topic",
    :message => "yet another message ",
    :username => "joe"
  }


####everything needs to go to json before entering redis
topic1 = topic1.to_json
topic2 = topic2.to_json
topic3 = topic3.to_json

redis.set("topic 1", topic1)
redis.set("topic 2", topic2)
redis.set("topic 3", topic3)

######multiple messages as part of an array?####
{
       :topic => "topic ahahhaha",
    :username => "username",
    :messages => [
        [0] "hi",
        [1] "hello",
        [2] "thanks"
    ]
}




all_topics.each do |topic|
          <%if topic == @desired_topic
          <% parsed = JSON.parse($redis.get(topic))
          <h2> <%= parsed["title"] %> </h2>
          <h3> <%= parsed["message"] %> </h3>
          <% end %>
        <% end %>


        $redis.keys.each do |topic|
          parsed = JSON.parse(redis.get(topic))
          if params["topic"] == parsed["topic"]
            parsed["title"]
          end
        end




#####sample structure with multiple messages#####



{"topic" => "example topic",
  "title" => "example topic",
  "username" => "username",
  "messages" => [
              { "message" => "message contents",
                "id" => "message1",
                "vote-count" => 0},
              {"message" => "message contetnts 2"},
              {"message" => "message contents 3"},
            ]
          }




{"topic" => "I don't get redis",
  "title" => "I don't get redis",
  "username" => "darth vader",
  "messages" => [
              { "message" => "it makes no sense!",
                "id" => "message1",
                "username" => "ade",
                "vote-count" => 0},
              {"message" => "what's the issue?",
                "username" => "rob"},
              {"message" => "I can help!",
                "username" => "jacki"},
            ]
          }

{"topic" => "where is my mind",
  "title" => "where is it??",
  "username" => "brad manning",
  "messages" => [
              { "message" => "i lost it!",
                "id" => "message1",
                "username" => "ade",
                "vote-count" => 0},
              {"message" => "what's the issue?",
                "username" => "rob"},
              {"message" => "her mind is gone!",
                "username" => "jacki"},
            ]
          }


