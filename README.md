# Combine multiple Kong authentication plugins

## Concept

We want to create several APIs with multiple authentication methods enabled on them. The consumers may decide which one they want to use.

If a request can be authenticated using any of these methods (provided by the plugins), it should be considered authenticated and be sent to the upstream service.

## Solution

...

## Setup

(Re)build Lua development container

```bash
docker-compose build --no-cache
```

Start Kong (w/ PostgreSQL)

```bash
docker-compose up -d
```

Open shell in the Lua container

```bash
docker-compose run lua bash
```

Run setup script

```bash
cd /test
lua test.lua
```

Test basic auth w/ valid credentials

```bash
curl -X GET \
  http://localhost:8000/ \
  -H 'Authorization: Basic YmFyOjUzY3IzN3A0NTV3MHJk' \
  -H 'Cache-Control: no-cache'
```

Tesh key auth w/ valid credentials

```bash
curl -X GET \
  http://localhost:8000/ \
  -H 'Cache-Control: no-cache' \
  -H 'apikey: v3ry53cr37'
```

Test API call w/o valid credentials

```bash
curl -X GET \
  http://localhost:8000/ \
  -H 'Cache-Control: no-cache'
```
