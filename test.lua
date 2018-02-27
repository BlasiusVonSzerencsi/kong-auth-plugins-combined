local RestClient = require("rest_client")

local response = nil

local admin_client = RestClient("http://kong:8001")

-- create a mock API
response = admin_client:post("/apis", {
    name = "mockbin",
    upstream_url = "http://mockbin.org/request",
    uris = "/"
})

local mock_api_id = response.json().id

-- create an anonymous consumer used as fallback when authentication fails
response = admin_client:post("/consumers", {
    username = "anon"
})

local anonymous_consumer_id = response.json().id

-- create an ordinary API user
response = admin_client:post("/consumers", {
    username = "foo"
})

local api_consumer_id = response.json().id

-- enable basic auth w/ fallback to the anonymous consumer
admin_client:post("/apis/" .. mock_api_id .. "/plugins", {
    name = "basic-auth",
    ["config.anonymous"] = anonymous_consumer_id
})

-- create basic auth credentials for the API user
local basic_auth_credentials = {
    username = "bar",
    password = "53cr37p455w0rd"
}

admin_client:post("/consumers/" .. api_consumer_id .. "/basic-auth", basic_auth_credentials)

-- enable key auth w/ fallback to the anonymous consumer
admin_client:post("/apis/" .. mock_api_id .. "/plugins", {
    name = "key-auth",
    ["config.anonymous"] = anonymous_consumer_id
})

-- create key auth credentials for the API user
local key_auth_credential = "v3ry53cr37"

admin_client:post("/consumers/" .. api_consumer_id .. "/key-auth", {
    key = key_auth_credential
})

-- turn on request termination on anonymous user
admin_client:post("/consumers/" .. anonymous_consumer_id .. "/plugins", {
    name = "request-termination",
    ["config.status_code"] = 401
})
