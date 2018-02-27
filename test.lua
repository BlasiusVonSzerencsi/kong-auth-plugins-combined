local requests = require("requests")

local response = nil

-- create a mock API
response = requests.post({
    url = "http://kong:8001/apis",
    data = {
        name = "mockbin",
        upstream_url = "http://mockbin.org/request",
        uris = "/"
    },
    headers = {
        ["Content-Type"] = "application/json"
    }
})

local mock_api_id = response.json().id

-- create an anonymous consumer used as fallback when authentication fails
response = requests.post({
    url = "http://kong:8001/consumers",
    data = {
        username = "anon"
    },
    headers = {
        ["Content-Type"] = "application/json"
    }
})

local anonymous_consumer_id = response.json().id

-- create an ordinary API user
response = requests.post({
    url = "http://kong:8001/consumers",
    data = {
        username = "foo"
    },
    headers = {
        ["Content-Type"] = "application/json"
    }
})

local api_consumer_id = response.json().id

-- enable basic auth w/ fallback to the anonymous consumer
response = requests.post({
    url = "http://kong:8001/apis/" .. mock_api_id .. "/plugins",
    data = {
        name = "basic-auth",
        ["config.anonymous"] = anonymous_consumer_id
    },
    headers = {
        ["Content-Type"] = "application/json"
    }
})

-- create basic auth credentials for the API user
local basic_auth_credentials = {
    username = "bar",
    password = "53cr37p455w0rd"
}

response = requests.post({
    url = "http://kong:8001/consumers/" .. api_consumer_id .. "/basic-auth",
    data = basic_auth_credentials,
    headers = { 
        ["Content-Type"] = "application/json"
    }
})

-- enable key auth w/ fallback to the anonymous consumer
response = requests.post({
    url = "http://kong:8001/apis/" .. mock_api_id .. "/plugins",
    data = {
        name = "key-auth",
        ["config.anonymous"] = anonymous_consumer_id
    },
    headers = {
        ["Content-Type"] = "application/json"
    }
})

-- create key auth credentials for the API user
response = requests.post({
    url = "http://kong:8001/consumers/" .. api_consumer_id .. "/key-auth",
    data = {
        key = "v3ry53cr37"
    },
    headers = { 
        ["Content-Type"] = "application/json"
    }
})

-- turn on request termination on anonymous user
response = requests.post({
    url = "http://kong:8001/consumers/" .. anonymous_consumer_id .. "/plugins",
    data = {
        name = "request-termination",
        ["config.status_code"] = 401
    },
    headers = { 
        ["Content-Type"] = "application/json"
    }
})
