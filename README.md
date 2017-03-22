# RailsGirlsSubmissions

 RailsGirlsSubmissions application is designed to receive and rate submissions for RailsGirls workshops.

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

* RSpec: ```bundle exec rspec spec``` (in the app's directory)

* Capybara: by default, capybara uses the `rack_test` driver, which is not suitable for testing some features dependent on JavaScript. In such cases:
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

* Emails (locally):
   * To see the emails, take a look into the server logs or capture them with Mailcatcher:
    1. `gem install mailcatcher`
    * run `mailcatcher` in a terminal
    * go to [http://localhost:1080/](http://localhost:1080/)
   * Upgrade your crontab so that the rake tasks are run on schedule
    1. run `RAILS_ENV=development whenever -w`
    * wait to get an email or change your time in computer settings ;]


## Registration flow
As soon as an applicant sends their submission the following things happen:
 1. If a submission breaks the default rules (an applicant took part in RailsGirls before or they can't speak English), it is rejected (see "Rejected tab"). Else, it shows in the "Valid" tab.
 2. Admins use "To rate" tab to assess the submission - show a submission, comment on it and give a rate.
 3. If the number of admins who rated a submission is large enough (see "Settings"), the submission is moved from "To rate" tab to "Results" tab.
 4. "Results" hold all rated submission ordered by their average rate. At first, they should have "Invitation" status of "not invited".
 5. By clicking a "Send emails" button you can start sending emails. Two tasks scheduled in your crontab will be executed every day starting from now:
    * One will send invitation emails to applicants with the best average rate if there is an available spot. This means at first there will be `available_spots` (see "Settings") number of invitations sent. It might happen some spots are freed after some time (i.e. when someone's invitation expired - see below). In this case, there will be a number of invitations sent so that all the spots are filled. If a applicant was sent an invitation email, their "Invitation" status should change to "invited".
    * The other - a reminder email - will be send to all the applicants who received an invitation email and their invitation expires in two days. 
 6. Invited applicants have some time (to set the time see "Settings") to confirm the invitations. They do it by clicking on the link in the invitation email. If the invitation is confirmed in time (which can be set in "Settings"), the "Invitation" status changes to "confirmed". Otherwise, it changes to "expired".
 7. All the applicants who confirmed an invitation can be seen in "Participants" tab. It is your participants list, which you can download by clicking a "Download" button.

## Adapting the app for other events
If you had to change something that is not mentioned here, while going through the process, please create a PR or drop us a line!

You might want to change:
  * Login page - replace `app/assets/images/rails-girls-krakow-2016.png`
  * "Coming soon" page - `views/submissions/preparation.html.erb`
  * "Thank you" page - `views/submissions/thank_you.html.erb`
  * "Closed" page - `views/submissions/closed.html.erb`
  * "Invitation confirmed" page - `views/submissions/invitation_confirmed.html.erb`
  * "Invitation expired" page - `views/submissions/invitation_expired.html.erb`
  * `404.html`, `422.html`, `500.html`
  * rejection rules - add or remove rule classes (`app/services/rules`) and reflect the changes in `app/services/submission_rejector`'s `RULES` array
  * styles - `app/assets/stylesheets`
  * settings (in the admin panel of the app)
  * emails
    * content - files in `app/views/invitations_mailer` and `app/mailers/invitations_mailer.rb`
    * schedule - `config/schedule.rb`
  * submission form
    * title - `app/views/submissions/_form.html.erb`
    * footer/side pane - `app/views/submissions/new.html.erb`, replace `app/assets/images/rails-girls-krakow-2016.png`
    * fields
      * use "QuestionCreator" (admin panel) for managing "how well do you..." questions
      * to change possible answers to questions to "how well do you..." questions look into
        * `value` enum in `app/models/answer`
        * the legend in `app/views/questions/_form.html.erb`
        * the answer form in `app/views/submissions/_answer_form.html.erb`
      * removing other fields - the easiest way is to add `visibility="hidden"` and some `value="some value of a correct type"` to the field in `app/views/submissions/_form.html.erb`
      * adding new fields - well... you probably need to go through the whole flow including view, controller, model, specs, migrations...
