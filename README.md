# Feature set

* Residents of a cowarking space that books rooms. # models/Resident,Rooms::*
* Booking is constrained by credits, that comes in two types : #models/TimeAccountLines::
 * *free credits*, tresholded in times ( half hours ), by of the kind of booked room, renewed everyweek
 * *paid credits*, tresholded in times ( half hours ) & EURs, by of the kind of booked room

# Sys
## Ruby, PG, nodejs -> heroku
Ruby version is 2.3.1 (specified in Gemfile). Keep it up to last security patch

**System dependencies** : 

* See Gemfile/Gemfile.lock for ruby dependencies
* DB is Postgres
* Production Runs on Heroku
* Development Runs with heroku toolbel with ```heroku local```
* NodeJS (responsive email via mjml, ruby gems is a wrapper around nodejs mjml)


## Configuration
### Setup stacks
* Recommended ruby env with rbenv
* Recommended usage of gemset
* Configuration is done via .env to expose ENV variables

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

```
# host
HOST_WITH_PORT=

# Temp password for demo
DEFAULT_PWD=

# Defaults for mails
MAIL_FROM=

# SMTP setup
SMTP_ADDRESS=
SMTP_PORT=
SMTP_DOMAIN=
SMTP_USER_NAME=
SMTP_PASSWORD=
SMTP_AUTHENTICATION=
SMTP_ENABLE_STARTTLS_AUTO=

# Delayed Job Basic auth
DJ_USERNAME=
DJ_PASSWORD=

# Address of coworking space (send with .ics data)
ADDRESS=

```
# Build & Run
## Build
### Documentations
* **back end** in [Rails5 ](guides.rubyonrails.org) [stick to vanilla rails: REST, AR, .erb, fixtures, minitest]
* **front end** in [Bootstrap3](https://getbootstrap.com)
* **authenthication** with [devise](https://github.com/plataformatec/devise) (only: sign_in, reset_password), admin create residents
* **ActiveJob (async)** Delayed job (does not requires a redis)
* icons with [FontAwesome4](http://fontawesome.io/icons) & [Datepicker](https://github.com/Nerian/bootstrap-datepicker-rails)
* **Admin** bootstrapped with classic rails scaffolding ```be bin/rails g scaffold_controller admin/residents email:string password:string firstname:string lastname:string --model-name=resident```


### Tests
```
bin/rails rake db:seed
bin/rails test
```

### Development server
```
heroku local
```

### Development console
```
heroku local:run rails c
```

## Deploy
* **Setup two buildpacks** : ruby (default) & node (for mjml), see: [heroku buildpack documentation](https://github.com/sighmon/mjml-rails#deploying-with-heroku)
* Expose **ENV** with ```
heroku config:add/set ENVKEY=ENVVALUE
```
* Ask for **heroku access** [admin](mailto:fourcade.m@gmail.com)

* add **heroku repo** as ```git remote add heroku https://git.heroku.com/{APPNAME}```
* then ```./deploy.sh``` (deploy, migrate, restart)

