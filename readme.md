# Overview #

WDI forum is a comprhensive web application that serves as a forum for current (and potentially former and future) students of General Assembly's NYC WDI program. It allows students to post their thoughts or issues easily. Students can reply to issues and vote on issues based on their relevance. Students can also rank the topics by their relative number of votes, or by the time created.

The WDI forum was developed by Andy Fritz as the first individual project for the August 2014 Web Development Immersive in New York City. It was developed over a 5 day sprint, with the goal of creating a useable application that demostrated an understanding of RESTful routes and and data persistence.

Work will continue on the project, as there are plenty of features left to add. However, a stable, MVP version of the project was presented on September 10th, 2014.


# Technologies Used #

* Ruby 2.1.2
* Sinatra 1.4.5
* Redis datastore 3.1.0
* Testing was done (and continues) with rspec and capybara


# User Stories Completed #

* As a user, I should see a list of topics upon loading the forum so that I can read the site's content.
* As a user, I should be able to click on individual topics so that I can read their full content.
* As a user, I should be able to reply to a topic so that I can participate in the discussion.
* As a user, I should be able to vote for a topic so I can express my interest in it in a quantifiable way.
* As a user, I can delete topics that are no longer interesting to me.
* As a user, I can rank the topics by order created or by popularity, based off of votes.

# Backlog #

* As a user, I can login with an o2 authentication method to have an individual profile.
* As a user, logging in will allow me to delete my own topics.
* As a user, I can vote on indidivual replies, not only topics.
* As a user, I can write topics and replies in markdown to be displayed properly as such.
* As a user, I can rank replies by vote, so that I can see the most popular reply to a subject first.

