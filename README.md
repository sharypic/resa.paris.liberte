## Ruby
version is 2.3.1 (specified in Gemfile). Keep it up to last security patch

## System dependencies.
* See Gemfile/Gemfile.lock for ruby dependencies
* DB is Postgres
* Production Runs on Heroku
* Development Runs with heroku toolbel with ```heroku local```
* ENV [via heroku local source .env]
* NodeJS (responsive email via mjml, ruby gems is a wrapper around nodejs mjml)

```
# host
HOST_WITH_PORT=

# temp password for demo
DEFAULT_PWD=

MAIL_FROM=

SMTP_ADDRESS=
SMTP_PORT=
SMTP_DOMAIN=
SMTP_USER_NAME=
SMTP_PASSWORD=
SMTP_AUTHENTICATION=
SMTP_ENABLE_STARTTLS_AUTO=
```

## Configuration
### Setup
* Recommended ruby env with rbenv
* Recommended usage of gemset
* Configuration is done via .env ; sets ENV dependencies

```
rbenv install 2.3.1 # install ruby
gem install bundler # install dependency manager
# setup .env
bundle install # install dependencies
```
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

## Database creation / migration
* creates with ```bin/rails ```
* migrate with ```bin/rails db:create```

## Database initialization
```bin/rails rake db:seed```

## How to run the test suite
* ```bin/rails test```

## Services (job queues, cache servers, search engines, etc.)
Not yet Available

## Deployment instructions
* Have heroku access (ask to fourcade.m@gmail.com)
* add heroku repo as ```git remote add heroku https://git.heroku.com/{APPNAME}```
* then ```./deploy.sh```

## Feature set

Books rooms depending on your credits.
