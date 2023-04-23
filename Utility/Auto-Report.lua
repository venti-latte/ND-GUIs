words = {
    ["bad"]             = "Bullying",
    ["black"]           = "Bullying",
    ["bozo"]            = "Bullying",
    ["child"]           = "Bullying",
    ["clown"]           = "Bullying",
    ["cringe"]          = "Bullying",
    ["die"]             = "Bullying",
    ["dumb"]            = "Bullying",
    ["ez l"]            = "Bullying",
    ["father"]          = "Bullying",
    ["gay"]             = "Bullying",
    ["get a life"]      = "Bullying",
    ["getalife"]        = "Bullying",
    ["idiot"]           = "Bullying",
    ["imagine"]         = "Bullying",
    ["kid"]             = "Bullying",
    ["kiddo"]           = "Bullying",
    ["killyou"]         = "Bullying",
    ["kys"]             = "Bullying",
    ["lesbian"]         = "Bullying",
    ["loser"]           = "Bullying",
    ["mother"]          = "Bullying",
    ["negar"]           = "Bullying",
    ["negro"]           = "Bullying",
    ["nivver"]          = "Bullying",
    ["no life"]         = "Bullying",
    ["noob"]            = "Bullying",
    ["nolife"]          = "Bullying",
    ["parent"]          = "Bullying",
    ["reports"]         = "Bullying",
    ["retard"]          = "Bullying",
    ["skill issue"]     = "Bullying",
    ["stupid"]          = "Bullying",
    ["trash"]           = "Bullying",
    ["ugly"]            = "Bullying",
    ["white"]           = "Bullying",
    ["wizard"]          = "Bullying",
    ["C&P"]             = "Scamming",
    ["cheat"]           = "Scamming",
    ["copy & paste"]    = "Scamming",
    ["copy and paste"]  = "Scamming",
    ["copy n paste"]    = "Scamming",
    ["cnp"]             = "Scamming",
    ["exploit"]         = "Scamming",
    ["hack"]            = "Scamming",
    ["macro"]           = "Scamming",
    ["void"]            = "Scamming",
    ["dizzy"]           = "Offsite Links",
    ["download"]        = "Offsite Links",
    ["youtube"]         = "Offsite Links"
}

if
    not game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") or
    not game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild(
        "OnMessageDoneFiltering"
    )
then
    return
end
DCSCE = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")

if setfflag then
    setfflag("AbuseReportScreenshotPercentage", 0)
    setfflag("DFFlagAbuseReportScreenshot", "False")
end

if not autoreportcfg then
    getgenv().autoreportcfg = {
        Webhook = "",
        autoMessage = {
            enabled = true,
            Message = "so sad you got autoreported :("
        }
    }
end

local players = game:GetService("Players")
local OrionLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/ManticoreV101/ND-GUIs/main/UI%20Backups/Orion%20UI%20Library%20Backup.lua"))()
function notify(title, text)
    OrionLibraryrary:MakeNotification(
        {
            Name = title,
            Content = text,
            Time = 5
        }
    )
end

function handler(msg, speaker)
    for i, v in next, words do
        if string.match(string.lower(msg), i) then
            players:ReportAbuse(players[speaker], v, "Breaking TOS.")
            task.wait(1.5)
            players:ReportAbuse(players[speaker], v, "Breaking TOS.")
            if autoreportcfg.Webhook ~= nil and autoreportcfg.Webhook ~= "" and autoreportcfg.Webhook ~= " " then
                local data = {
                    ["embeds"] = {
                        {
                            ["title"] = "**" ..
                            game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "**",
                            ["description"] = "Description generated.",
                            ["type"] = "rich",
                            ["color"] = tonumber(0x2b2d31),
                            ["url"] = "https://www.roblox.com/games/" .. game.PlaceId,
                            ["fields"] = {
                                {
                                    ["name"] = "Username:",
                                    ["value"] = "[" ..
                                    players[speaker].Name ..
                                    "](https://www.roblox.com/users/" .. players[speaker].UserId .. ")",
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Entire Message:",
                                    ["value"] = msg,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Offensive String:",
                                    ["value"] = i,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Report Type:",
                                    ["value"] = v,
                                    ["inline"] = true
                                }
                            },
                            ["footer"] = {
                                ["text"] = "\nAuto-Report"
                            },
                            ["author"] = {
                                ["name"] = "Report Log"
                            }
                        }
                    }
                }
                local newdata = (game:GetService("HttpService")):JSONEncode(data)
                local request = http_request or request or HttpPost or http.request or syn.request
                local abcdef = {
                    Url = autoreportcfg.Webhook,
                    Body = newdata,
                    Method = "POST",
                    Headers = {
                        ["content-type"] = "application/json"
                    }
                }
                request(abcdef)
            else
                notify("Auto-Report", "Reported: " .. speaker .. " | String: " .. i)
            end
            if DCSCE:FindFirstChild("SayMessageRequest") and autoreportcfg.autoMessage.enabled == true then
                DCSCE.SayMessageRequest:FireServer("/w " .. speaker .. " " .. autoreportcfg.autoMessage.Message, "All")
            end
        end
    end
end

msg = DCSCE:FindFirstChild("OnMessageDoneFiltering")
msg.OnClientEvent:Connect(
    function(msgdata)
        if tostring(msgdata.FromSpeaker) ~= players.LocalPlayer.Name then
            handler(tostring(msgdata.Message), tostring(msgdata.FromSpeaker))
        end
    end)
