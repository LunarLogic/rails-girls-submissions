# RailsGirls

 RailsGirls application is designed to receive and rate submissions for RailsGirls workshops.

## Setup
     git clone git@github.com:LunarLogic/rails-girls-submissions.git
     cd rails-girls-submissions

     gem install bundler
     bundle

   Then create your own `secrets.yml` file. Replace the example values for dev/test environment and set the environment variables on your production server. The mailer is configured to work with Mailchimp.

     cp config/secrets.yml.example config/secrets.yml

   Add your primary GitHub email to `allowed_users.yml`

     cp config/allowed_users.yml.example config/allowed_users.yml

   Next, setup the db and run the server.

     bundle exec rake db:setup
     rails s

   Lastly, open the browser and go `localhost:3000` or, if in production environment, wherever the app is deployed. You should see a "Coming Soon" page.

   To access the admin panel, go to `/admin` and log in to the app through GitHub.
   Then, click "Settings" in the upper-right corner and configure your application.

## Testing

 RSpec: ```bundle exec rspec spec``` (in the app's directory)

 Capybara: by default, capybara uses the `rack_test` driver, which is not suitable for testing some features dependent on JavaScript. In such cases:
  * Install chromedriver: `brew install chromedriver`
  * Make sure your gems are up-to-date: `bundle install`
  * Annotate your specs with `js: true`, which will change the driver to `selenium` for the particular test:

 ```
describe "the rating process", js: true do
  #...  
  it "visits submission page, finds and clicks rate button" do
    #...
    expect{ label.click }.to change(submission.rates, :count).by(1)
  end
end
```

Another advantage of using `selenium` is that while running the specs, it opens s browser window and shows live the actions it performs, which could be useful for debugging the specs.

The configuration for the drivers can be found in the `spec/rails_helper`.
