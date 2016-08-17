## Ruby
version is 2.3.1 (specified in Gemfile). Keep it up to last security patch

## System dependencies.
* See Gemfile/Gemfile.lock for ruby dependencies
* DB is Postgres
* Production Runs on Heroku
* Development Runs with heroku toolbel with ```heroku local```
* ENV [via heroku local source .env]
* NodeJS (responsive email via mjml, ruby gems is a wrapper around nodejs mjml)


## Configuration
### Setup stacks
* Recommended ruby env with rbenv
* Recommended usage of gemset
* Configuration is done via .env ; sets ENV dependencies

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
# Address of coworking space (send with .ics data)
ADDRESS=

# SMTP setup
SMTP_ADDRESS=
SMTP_PORT=
SMTP_DOMAIN=
SMTP_USER_NAME=
SMTP_PASSWORD=
SMTP_AUTHENTICATION=
SMTP_ENABLE_STARTTLS_AUTO=

# Delayed Job Basic auth
DJ_USERNAME=hello
DJ_PASSWORD=world
```
### Various documentations
* Datepicker : https://github.com/Nerian/bootstrap-datepicker-rails


### Run development server
```
heroku local
```
### Run development console
```
heroku local:run rails c
```

### Production
Expose ENV variable via
```
heroku config:add/set ENVKEY=ENVVALUE
```

Also you need to setup two buildpacks : ruby (default) plus node (for mjml), see: https://github.com/sighmon/mjml-rails#deploying-with-heroku

## Database creation / migration
* creates with ```bin/rails ```
* migrate with ```bin/rails db:create```

## Database initialization
```bin/rails rake db:seed```

## How to run the test suite
* ```bin/rails test```

## Services (job queues, cache servers, search engines, etc.)
* async processing is done via Delayed job duee to it's "lightweight" (does not requires a redis)

## Deployment instructions
* Have heroku access (ask to fourcade.m@gmail.com)
* add heroku repo as ```git remote add heroku https://git.heroku.com/{APPNAME}```
* then ```./deploy.sh```

## Feature set

* Books rooms depending on your credits

## Frameworks & libs
* Backend/frontend: Rails ; >5
* CSS/JS: Bootstrap ; customized and stripped down to the 'bare' minimum, see assets/{stylesheets|javascript}/libs for available parts
* Icons: font awesome

## Implementail details
Admin does not use external gem (shitty to maintain, IMO). So we fallback to classic rails scaffolding as 

```
be bin/rails g scaffold_controller admin/residents email:string password:string firstname:string lastname:string --model-name=resident

be bin/rails g scaffold_controller admin/teams name:string  --model-name=team
```