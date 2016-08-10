## Ruby
version is 2.3.1 (specified in Gemfile). Keep it up to last security patch

## System dependencies.
* See Gemfile/Gemfile.lock for ruby dependencies
* DB is Postgres
* Runs on Heroku
* ENV
* NodeJS (responsive email via mjml, ruby gems is a wrapper around nodejs mjml)

```
# host
HOST_WITH_PORT=

# temp password for demo
DEFAULT_PWD=

MAIL_FROM=
```

## Configuration
### Development/Test
* Recommended ruby env with rbenv
* Recommended usage of gemset
* Configuration is done via dot.env ; sets ENV dependencies

```
rbenv install 2.3.1
gem install bundler
bundle install
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
