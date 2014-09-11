require 'pry'

describe("The topics page") do

  it("has a banner") do
    visit("/topics")
    expect(page).to have_content("WDI forum")
  end

  it("displays replies") do
    visit("/topics")
    expect(page).to have_content("reply count:")
  end

  it("contains a link to a new post") do
    visit("/topics")
    expect page.has_content?('post a new topic')
  end

  it("contains a 'restful' banner") do
    visit("/topics")
    expect page.has_content?('RESTful forum')
  end

end

describe("Making a new topic") do

  it("loads a form with parmaters for a new topic") do
    visit("/")
    click_on "post a new topic"
    expect page.has_content?('Topic?')
    expect page.has_content?('Message?')
    expect page.has_content?('Your Name?')
  end

  it("has a link back to the topics page") do
    visit("/")
    click_on "post a new topic"
    expect page.has_content?("back to topics")
    click_on "back to topics"
    expect page.has_content?("post a new topic")
  end

end
