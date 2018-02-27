local Object = require("classic")
local requests = require("requests")

local RestClient = Object:extend()

function RestClient:new(base_url)
    self.base_url = base_url
end

function RestClient:post(uri, payload)
    local glue = ""

    if self.base_url:sub(-1) ~= "/" and uri:sub(1, 1) ~= "/" then
        glue = "/"
    end

    local request_url = self.base_url .. glue .. uri

    local response = requests.post({
        url = request_url,
        data = payload,
        headers = {
            ["Content-Type"] = "application/json"
        }
    })

    return response
end

return RestClient
