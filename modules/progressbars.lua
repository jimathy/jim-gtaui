local inProgress = false

function progressBar(data)
    local ped = PlayerPedId()

    local result = nil

    loadTextureDict("timerbars")
    if inProgress then return false end
    inProgress = true
    local wait = debugMode and 1000 or data.time
    local endTime = GetGameTimer() + wait
    local ped = PlayerPedId()

    -- Setup Animation/Task if specified
    if data.dict then
        playAnim(data.dict, data.anim, -1, data.flag or 32)
    elseif data.task then
        TaskStartScenarioInPlace(ped, data.task, -1, true)
    end

    -- Progress bar rendering loop
    CreateThread(function()
        while GetGameTimer() < endTime and inProgress do
            Wait(0)
            local elapsed = GetGameTimer()
            local percentage = ((elapsed - (endTime - wait)) / wait) * 100

            -- Convert to segmented progress (assuming 5 segments here)
            local segments = 5  -- Number of segments in the bar
            local segmentProgress = {}
            local progressPerSegment = 100 / segments

            for i = 1, segments do
                local segmentStart = (i - 1) * progressPerSegment
                local segmentEnd = i * progressPerSegment
                if percentage >= segmentEnd then
                    segmentProgress[i] = 100
                elseif percentage <= segmentStart then
                    segmentProgress[i] = 0
                else
                    segmentProgress[i] = ((percentage - segmentStart) / progressPerSegment) * 100
                end
            end

            percentage = percentage >= 100 and 100 or percentage
            -- Draw your segmented progress bar
            ShowGTAProgressBar(segmentProgress, data.label, ("%.0f%%"):format(percentage))

            -- Controls to disable during progress
            DisablePlayerFiring(ped, true)
            DisableControlAction(0, 25, true) -- Disable aim
            DisableControlAction(0, 21, true) -- Disable sprint
            DisableControlAction(0, 30, true) -- Disable move left/right
            DisableControlAction(0, 31, true) -- Disable move forward/back
            DisableControlAction(0, 36, true) -- Disable stealth

            if data.cancel and (IsControlJustReleased(0, 202) or IsControlJustReleased(0, 177) or IsControlJustReleased(0, 73)) then
                inProgress = false
            end
        end
    end)

    -- Wait for completion or cancel
    while GetGameTimer() < endTime and inProgress do
        Wait(100)
    end

    -- Cleanup animations/tasks
    if data.dict then
        stopAnim(data.dict, data.anim, ped)
    end
    if data.task then
        ClearPedTasks(ped)
    end

    result = inProgress
    inProgress = false

    while result == nil do Wait(10) end

    -- Cleanup
    FreezeEntityPosition(ped, false)
    lockInv(false)

    return result
end

function ShowGTAProgressBar(currentProg, title, level)
    local loc = vec2(0.37, 0.90)
    local size = vec2(0.3, 0.03)

    -- Draw background box
    DrawSprite("timerbars", "all_black_bg", loc.x +0.028, loc.y-0.01, 0.15, 0.07, 0.0, 255, 255, 255, 255)
    DrawSprite("timerbars", "all_black_bg", loc.x +0.170, loc.y-0.01, 0.15, 0.07, 180.0, 255, 255, 255, 255)

    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(title)
    DrawText(loc.x - size.x / 4 + 0.074, loc.y - 0.034)  -- Adjust text position

    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.35, 0.25)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(level)
    DrawText(loc.x - size.x / 4 + 0.246, loc.y - 0.030)  -- Right-aligned additional text

    local segmentWidth = (size.x + 0.05) / (#currentProg * 2)  -- Divide the total width by 18 (9 segments * 2 gaps for each)
    local gap = segmentWidth / #currentProg  -- Smaller gap between segments

    for i = 1, #currentProg do
        local segmentX = (loc.x - size.x / 4 ) + 0.075 + (i - 1) * (segmentWidth + gap)
        local fillPercentage = currentProg[i]
        local progressBarWidth = segmentWidth * (fillPercentage / 100)

        -- Semi-transparent background for each segment
        DrawRect(segmentX + segmentWidth / 2, loc.y, segmentWidth, size.y / 3.4, 100, 100, 100, 255)

        -- Filling progress for each segment
        if progressBarWidth > 0 then
            DrawRect(segmentX + progressBarWidth / 2, loc.y, progressBarWidth, size.y / 3.4, 93, 182, 229, 255)  -- Blue progress
        end
    end
end

function stopProgressBar() inProgress = false end

function isProgressBar() return inProgress end

exports("progressBar", progressBar)
exports("stopProgressBar", stopProgressBar)
exports("isProgressBar", isProgressBar)


--RegisterCommand("testprog", function()
--    if progressBar({
--        label = "Processing...",
--        time = 5000,
--        dict = "amb@world_human_hang_out_street@female_hold_arm@base",
--        anim = "base",
--        flag = 49,
--        cancel = true,
--    }) then
--        exports["jim-gtaui"]:Notify("Success!", "Short test message", "success")
--    else
--        exports["jim-gtaui"]:Notify("Error!", "This is a longer example message to show stacking.", "error")
--    end
--end)