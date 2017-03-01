# RailsGirls

 RailsGirls application is designed to receive and rate submissions for RailsGirls workshops.

## Local setup

     git clone git@github.com:LunarLogic/rails-girls-submissions.git
     cd rails-girls-submissions
     gem install bundler
     bundle
     cp config/secrets.yml.example config/secrets.yml
     cp config/allowed_users.yml.example config/allowed_users.yml
     bundle exec rake db:setup
     rails s

## Servers and deployment

 * CI: https://circleci.com/gh/LunarLogic/rails-girls-submissions

## Testing

 RSpec: ```bundle exec rspec spec```

 Capybara: by default, capybara uses the `rack_test` driver, which is not suitable for testing some features dependent on JavaScript. In such cases, annotate your specs with `js: true`, which will change the driver to `selenium` for the particular test:

 ```
describe "the rating process", js: true do
  #...  
  it "visits submission page, finds and clicks rate button" do
    #...
    expect{ label.click }.to change(submission.rates, :count).by(1)
  end
end
```

Another advantage of using `selenium` is that while running the specs, it opens `Firefox` windows and shows live the actions it performs, which could be useful for debugging the specs.

The configuration for the drivers can be found in the `spec/rails_helper`.
