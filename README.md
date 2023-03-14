# README

## Overview

- Rails version: 7
- Ruby version: 3.1.2

## Setup

- Install `rbenv` reference: `https://github.com/rbenv/rbenv`
- Install `3.1.2 ruby` through `rbenv`
- Install `postgresql` through `brew`
- Install `bundler`
- Run `bundle install`
- Run `bundle exec rake db:setup` to run migration and seed
- Run `rails s` or `bin/rails s`
- Open postman to start trigger request `localhost:3000/api/*`
- You can use seeded users in db just grab `user.uuid` to use to set on `X-Uid` request header to all requests in the resources.

## Overview

Restful APIS to track users when do they go to bed and when do they wake up.

Goals:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

## Authentication

App requires `X-Uid` request header from `user.uuid`. All resources requires this header key to recognize requester.

Sample request:

```
Request:

curl -X GET \
  http://localhost:3000/api/timesheets \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \
  -d '{"follow_user_id": 3 }'
```

## Resources

Follow user

```
Request:

curl -X POST \
  http://localhost:3000/api/follows \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \
  -d '{"follow_user_id": 2 }'
  
Response:

204 with empty json content
404 with error message content
401 with error message content
```

Unfollow user

```
Request:

curl -X DELETE \
  http://localhost:3000/api/follows/2 \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \
  
Response:

204 with empty json content
404 with error message content
401 with error message content
```

Sleep records from following users

```
Request:

curl -X GET \
  http://localhost:3000/api/sleep-records \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \

Response:
401 with error message content
200 with array content

{
    "data": [
        {
            "id": "4",
            "type": "sleep-records",
            "links": {
                "self": "http://localhost:3000/api/sleep-records/4"
            },
            "attributes": {
                "clock-in": "2023-03-09T09:03:44.862Z",
                "clock-out": "2023-03-09T09:09:10.735Z",
                "sleep-time-in-seconds": "325.872724",
                "user-name": "Juan Tamad",
                "user-id": 1,
                "created-at": "2023-03-09T09:03:44.863Z"
            }
        },
		...
    ]
}
```

Clocked in timesheets

```
Request:
curl -X GET \
  http://localhost:3000/api/timesheets \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \
  
Response:
401 with error message content
200 with array content

{
    "data": [
        {
            "id": "16",
            "type": "timesheets",
            "links": {
                "self": "http://localhost:3000/api/timesheets/16"
            },
            "attributes": {
                "clock-in": "2023-03-09T15:07:38.221Z",
                "clock-out": "2023-03-09T15:07:50.131Z",
                "created-at": "2023-03-09T15:07:38.222Z"
            }
        },
		...
    ]
}
```

Clock in

```
Request:
curl -X POST \
  http://localhost:3000/api/timesheets/clock-in \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \

Response:

204 with empty json content
401 with error message content
```

Clock out

```
Request:
curl -X POST \
  http://localhost:3000/api/timesheets/clock-out \
  -H 'accept: application/vnd.api+json' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/vnd.api+json' \
  -H 'x-uid: a5b41994-eac1-4feb-913e-5631248ffa1e' \

Response:

204 with empty json content
401 with error message content
```