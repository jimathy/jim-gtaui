local currentDisplayText = nil
local drawingText = false
local pos = vec2(0.02, 0.5)
local lines = {}

-- Animation state
local anim = {
    x = -0.2,        -- start off-screen
    alpha = 255,     -- opacity
}

-- Function to display text.
function drawText(message)
    loadTextureDict("timerbars")
    currentDisplayText = message

    lines = {}
    for line in string.gmatch(currentDisplayText, "[^\n]+") do
        table.insert(lines, line)
    end
    if not drawingText then
        drawingText = true
        anim.active = true
        anim.alpha = 255
        anim.x = -0.2

        CreateThread(function()
            while anim.active and round(anim.x, 2) < round(pos.x, 2) do
                anim.x += (pos.x - anim.x) * 0.2
                Wait(0)
            end
            anim.active = false
        end)
        CreateThread(function()
            -- Drawing loop
            while currentDisplayText do
                DrawSprite("timerbars", "all_black_bg", anim.x, pos.y + 0.02, 0.2, 0.1, 180.0, 255, 255, 255, anim.alpha)
                DrawCenteredTextBlock(anim.x, pos.y + 0.02, anim.alpha, lines)
                if not anim.active then
                    Wait(10) -- change this to 0 or remove if scaleform is flickering
                else
                    Wait(0)
                end
            end
        end)
    end
end

-- Function to hide the text.
function hideText()
    currentDisplayText = nil
    drawingText = false
    CreateThread(function()
        -- Fade-out animation
        while not currentDisplayText and anim.alpha > 0 do
            anim.alpha -= 15 -- Adjust fade speed here
            DrawSprite("timerbars", "all_black_bg", anim.x, pos.y + 0.02, 0.2, 0.1, 180.0, 255, 255, 255, anim.alpha)
            DrawCenteredTextBlock(anim.x, pos.y + 0.02, anim.alpha, lines)
            Wait(10)  -- change this to 0 or remove if scaleform is flickering
        end
    end)
end

-- DrawCenteredTextBlock with alpha support
function DrawCenteredTextBlock(x, y, alpha, lines)
    if currentDisplayText then
        local lineHeight = 0.03
        local totalHeight = #lines * lineHeight
        local startY = y - (totalHeight / 2)
        for i, line in ipairs(lines) do
            SetTextFont(8)
            SetTextScale(0.4, 0.4)
            SetTextJustification(1)
            SetTextColour(255, 255, 255, alpha)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(line)
            DrawText(x, startY + (i - 1) * lineHeight)
        end
    end
end

-- Events and Exports
RegisterNetEvent("jim-gtaui:DrawText", function(message)
    drawText(message)
end)

RegisterNetEvent("jim-gtaui:HideText", function()
    hideText()
end)

exports("drawText", drawText)
exports("hideText", hideText)

--CreateThread(function()
--    while true do
--        drawText("[E] - Use")
--        Wait(2000)
--        drawText("[E] - Use\n[G] - Cry")
--        Wait(4000)
--        drawText("[E] - Use\n[G] - Cry\n[F] - Start Fire")
--        Wait(4000)
--        hideText()
--        Wait(5000)
--    end
--end)