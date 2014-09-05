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
