-- https://github.com/Hammerspoon/hammerspoon/issues/1128#issuecomment-266104051

local module = {}

local keyHandler = function(e)
    local watchFor = { h = "left", j = "down", k = "up", l = "right" }
    local actualKey = e:getCharacters(true)
    local replacement = watchFor[actualKey:lower()]
    if replacement then
        local isDown = e:getType() == hs.eventtap.event.types.keyDown
        local flags  = {}
        for k, v in pairs(e:getFlags()) do
            if v and k ~= "fn" then -- fn will be down because that's our "wrapper", so ignore it
                table.insert(flags, k)
            end
        end
        print(replacement, hs.inspect(flags), isDown)
        local replacementEvent = hs.eventtap.event.newKeyEvent(flags, replacement, isDown)
        if isDown then
            -- allow for auto-repeat
            replacementEvent:setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat))
        end
        return true, { replacementEvent }
    else
        return false -- do nothing to the event, just pass it along
    end
end

local modifierHandler = function(e)
    local flags = e:getFlags()
    local onlyControlPressed = false
    for k, v in pairs(flags) do
        onlyControlPressed = v and k == "fn"
        if not onlyControlPressed then break end
    end
    -- you must tap and hold fn by itself to turn this on
    if onlyControlPressed and not module.keyListener then
        print("keyhandler on")
        module.keyListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, keyHandler):start()
    -- however, adding additional modifiers afterwards is ok... its only when we have no flags that we switch back off
    elseif not next(flags) and module.keyListener then
        print("keyhandler off")
        module.keyListener:stop()
        module.keyListener = nil
    end
    return false
end

module.modifierListener = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, modifierHandler):start()

return module
