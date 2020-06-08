# Incubit Test Task
## Dependencies
* Ruby version : 2.6.3
* Rails Version : 6.0.3
* Redis Version : 3.0.6
## Configuration
```gem install bundler && bundle install```
## Setup and Start the Applicaton
### Database Setup
```rake db:create && rake db:migrate```
### Run the rails server
```rails s```
### Start sidekiq
```sidekiq```
## Test Environment Setup
### Test Database Setup
```RAILS_ENV=test rake db:create && RAILS_ENV=test rake db:migrate```
### Run the Test Suit
```rspec```
