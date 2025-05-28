if not IsDuplicityVersion() then return end

---@return string
HRLib.GetServerIP = function()
    local ip

    PerformHttpRequest('http://api.ipify.org/', function(_, body)
        ip = body
    end)

    repeat Wait(10) until ip ~= nil

    return ip
end

---@param ip string
---@param port integer
local checkIsServerSame = function(ip, port)
    local isOther

    PerformHttpRequest(('http://%s:%s/info.json'):format(ip, port), function(_, info)
        info = json.decode(info)
        for l=1, #info.resources do
            if GetResourceState(info.resources[l]) == 'missing' then
                isOther = true

                return
            end
        end
    end)

    return not isOther
end

---@return integer
HRLib.GetServerPort = function()
    local ip <const> = HRLib.GetServerIP()
    local port

    PerformHttpRequest(('http://%s:30120'):format(ip), function(status, _, headers) -- Preventing the long loop if the most popular server port isn't changed from its default value
        if status == 200 and headers['x-citizenfx-join-token'] and checkIsServerSame(ip, 30120) then
            port = 30120
        end

        if not port then
            for i=1, 99999 do
                if port then break end

                PerformHttpRequest(('http://%s:%s'):format(ip, i), function(status, _, headers)
                    if status == 200 and headers['x-citizenfx-join-token'] and checkIsServerSame(ip, i) then
                        port = i
                    end
                end)
            end
        end
    end)

    return port
end

---@return string
HRLib.GetJoinCode = function()
    local joinCode

    PerformHttpRequest(('http://%s:%s'):format(HRLib.GetServerIP(), HRLib.GetServerPort()), function(_, _, headers)
        joinCode = headers['x-citizenfx-join-token'] or ''
    end)

    repeat Wait(10) until joinCode ~= nil

    return joinCode
end