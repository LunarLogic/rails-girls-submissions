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

#### Demo server

 * git branch: `master`
 * site url: http://railsgirls.demo.llp.pl/

 __Deployment happens automatically after each successful CI build.__

## Testing

 RSpec: ```bundle exec rspec spec```
