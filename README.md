[![Build Status](https://semaphoreci.com/api/v1/projects/d0a117c4-cf68-4a34-9acd-0f3cb3d92d0c/1010808/badge.svg)](https://semaphoreci.com/mfourcade/resa-paris-liberte)

# Feature set

* Residents of a coworking space book rooms. (# models/Resident,Rooms::*)
* Booking is constrained by credits, that comes in two types : (#models/TimeAccountLines::*)
 * *free credits*, tresholded in times ( half hours ), by the kind of booked room, renewed every week
 * *paid credits*, tresholded in times ( half hours ) & EURs, by of the kind of booked room, never expires, never renewed

# Stack
* Ruby version is 2.3.1 (specified in Gemfile). Keep it up to last security patch
* See Gemfile/Gemfile.lock for ruby dependencies
* DB is Postgres
* Production runs on Heroku
* Development runs with heroku toolbel via ```heroku local```
* NodeJS (responsive email via mjml, ruby gems is a wrapper around nodejs mjml)


# Bootsrap / Setup
* Recommended ruby env with rbenv
* Recommended usage of gemset
* Configure environment with .env to expose ENV variables via heroku toolbelt

```
# Install node for && MJML
brew insall node
npm install -g mjml

# Install ruby version, bundler & gemfile dependencies
rbenv install 2.3.1
gem install bundler 
bundle install
```

### Setup .env
Copy .env.sample to .env and update value

### Create database, migrate & seed
```
bundle exec heroku local:run rails db:create
bundle exec heroku local:run rails db:migrate
bundle exec heroku local:run rails db:seed
```

### Run the test suite
```bin/rails test```

# Build & Run
## Build
### Documentations
* **back end** in [Rails5 ](guides.rubyonrails.org) [stick to vanilla rails: REST, AR, .erb, fixtures, minitest]
* **front end** in [Bootstrap3](https://getbootstrap.com)
* **authenthication** with [devise](https://github.com/plataformatec/devise) (only: sign_in, reset_password), admin create residents
* **ActiveJob (async)** Delayed job (does not requires a redis)
* **icons** with [FontAwesome4](http://fontawesome.io/icons) & [Datepicker](https://github.com/Nerian/bootstrap-datepicker-rails)
* **Admin** bootstrapped with classic rails scaffolding ```be bin/rails g scaffold_controller admin/residents email:string password:string firstname:string lastname:string --model-name=resident```


### Development server
```
bundle exec heroku local
```

### Development console
```
bundle exec heroku local:run rails c
```


# Deploy

* **Setup two buildpacks** : ruby (default) & node (for mjml), see: [heroku buildpack documentation](https://github.com/sighmon/mjml-rails#deploying-with-heroku)
* Expose **ENV** with ```heroku config:add/set ENVKEY=ENVVALUE```
* Ask for **heroku access** [admin](mailto:fourcade.m@gmail.com)

## Deployment instructions
* Have heroku access (ask to fourcade.m@gmail.com)
* add heroku repo as ```git remote add heroku https://git.heroku.com/{APPNAME}```
* then ```./deploy.sh```


