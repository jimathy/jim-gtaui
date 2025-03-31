function loadTextureDict(dict)
	if not HasStreamedTextureDictLoaded(dict) then
		while not HasStreamedTextureDictLoaded(dict) do
            RequestStreamedTextureDict(dict)
            Wait(5)
        end
	end
end
function makeInstructionalButtons(info)
    local build = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(build) do Wait(0) end

    -- Draw the scaleform fullscreen (initial draw).
    DrawScaleformMovieFullscreen(build, 255, 255, 255, 0, 0)

    -- Clear previous instructions.
    BeginScaleformMovieMethod(build, "CLEAR_ALL")
    EndScaleformMovieMethod()

    -- Set clear spacing between buttons.
    BeginScaleformMovieMethod(build, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    -- Add each button option to the scaleform.
    for i = 1, #info do
        BeginScaleformMovieMethod(build, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(i - 1)
        for k = 1, #info[i].keys do
            ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, info[i].keys[k], true))
        end
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringKeyboardDisplay(info[i].text)
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    end

    -- Draw the instructional buttons.
    BeginScaleformMovieMethod(build, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    -- Set a translucent black background.
    BeginScaleformMovieMethod(build, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()

    -- Final full-screen draw with full opacity.
    DrawScaleformMovieFullscreen(build, 255, 255, 255, 255, 0)
end

function lockInv(toggle)
    FreezeEntityPosition(PlayerPedId(), toggle)
    LocalPlayer.state:set("inv_busy", toggle, true)
    TriggerEvent('inventory:client:busy:status', toggle)
    TriggerEvent('canUseInventoryAndHotbar:toggle', not toggle)
end

function playAnim(animDict, animName, duration, flag, ped, speed)
    loadAnimDict(animDict)
	TaskPlayAnim(ped and ped or PlayerPedId(), animDict, animName, speed or 8.0, speed or -8.0, duration or 30000, flag or 50, 1, false, false, false)
end

function stopAnim(animDict, animName, ped)
    StopAnimTask(ped or PlayerPedId(), animDict, animName, 0.5)
    StopAnimTask(ped or PlayerPedId(), animName, animDict, 0.5)
    unloadAnimDict(animDict)
end
function loadAnimDict(animDict)
	if not DoesAnimDictExist(animDict) then
		print("^1ERROR^7: ^2Anim Dictionary^7 - '^6"..animDict.."^7' ^2does not exist in server") return
	else
		while not HasAnimDictLoaded(animDict) do RequestAnimDict(animDict) Wait(5) end
	end
end
function unloadAnimDict(animDict)
    RemoveAnimDict(animDict)
end

function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end