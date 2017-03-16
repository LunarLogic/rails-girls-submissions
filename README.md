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

## Registration flow
  As soon as an applicant sends their submission the following things happen:
  1. If a submission breaks the default rules (an applicant took part in RailsGirls before or they can't speak English), it is rejected (see "Rejected tab"). Else, it shows in the "Valid" tab.
  * Admins use "To rate" tab to assess the submission - show a submission, comment on it and give a rate.
  * If the number of admins who rated a submission is large enough (see "Settings"), the submission is moved from "To rate" tab to "Results" tab.
  * "Results" hold all rated submission ordered by their average rate. At first, they should have "Invitation" status of "not invited".
  * You can send an email to the set number of applicants from the top of the list (to set the number see "Settings") - their "Invitation" status should change to "invited".
  * The invited applicants have some time to confirm the invitations (to set the time see "Settings"). If the invitation is confirmed in the time, the "Invitation" status changes to "confirmed". Else, the status is changed to "expired".
  * All the applicants who confirmed an invitation can be seen in "Participants" tab. It is your participants list, which you can download by clicking a "Download" button.

## Setting automatic emails and reminders
