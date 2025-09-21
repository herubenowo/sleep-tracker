# NOTES

create file `.env` (local) or `.env.docker` (docker-compose) on root of project
use `postgresql` as main database

### Authentication
All endpoints need Basic Authentication via Authorization headers. you can use this data from seeders
```
username: admin
password: admin
```

# List Endpoint
- `POST /api/v1/user` - **CREATE USER**
- `POST /api/v1/user/me/follow` - **CURRENT USER FOLLOW OTHER BY USER ID**
- `DELETE /api/v1/user/me/unfollow` - **CURRENT USER UNFOLLOW OTHER BY USER ID**
- `POST /api/v1/user/me/following-list` -  **CURRENT USER FOLLOWING LIST**
- `POST /api/v1/user/me/follower-list` - **CURRENT USER FOLLOWER LIST**
- `POST /api/v1/user/list-all` - **LIST ALL USER**
- `POST /api/v1/sleep-records/clock-in` - **CURRENT USER START SLEEP SESSION**
- `POST /api/v1/sleep-records/clock-out` - **CURRENT USER END CURRENT ACTIVE SLEEP SESSION**
- `POST /api/v1/sleep-records/summary/me` - **CURRENT USER GET OWN SLEEP RECORD SUMMARY**
- `POST /api/v1/sleep-records/summary/following` - **CURRENT USER GET FOLLOWINGS SLEEP RECORD SUMMARY**

# Installation
## Run locally
```
use rvm or rbenv for dinamic ruby version
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
make sure set the env in .env file
application running in port 3000 by default
```
## Run with docker compose
```
set the env in .env.docker with the data below in list env docker
docker-compose up --build
application running in port 9000
```
## Testing
```
bundle exec rspec
```

# List of ENV
## 1. ENV running locally (please make sure to use redis for better performance)
```
APP_NAME="sleep-tracker-be"
DB_HOST=${DB_HOST}
DB_PORT="5432"
DB_POOL=10
DB_TIMEOUT=20000
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
REDIS_PROVIDER="REDISTOGO_URL"
REDISTOGO_URL="redis://0.0.0.0:6379/1"
REDIS_HOST="0.0.0.0"
REDIS_PORT="6379"
REDIS_DB="1"
REDIS_CACHE_DB="1"
SECRET_KEY_BASE="secret_key_base"
UNMASK_ERROR_MESSAGE="true"
```

## 2. ENV with docker compose
```
APP_NAME=sleep-tracker-be
DB_HOST=db
DB_PORT=5432
DB_POOL=10
DB_TIMEOUT=20000
DB_NAME=sleep_tracker_be
DB_USER=user
DB_PASSWORD=password
REDIS_PROVIDER=REDISTOGO_URL
REDISTOGO_URL=redis://redis:6379/1
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=1
REDIS_CACHE_DB=1
SECRET_KEY_BASE=secret_key_base
UNMASK_ERROR_MESSAGE=true
```
