If you use this, please atleast give credit, that would be the dream.

# What is this?

I was messing with gta natives and scaleforms to create "fallback" functions for if a script isn't available for jim_bridge to access eg, you somehow don't have a core notification script

These are simple and easy to use GTA Native Scaleform UI features

    - Notifcations
    - DrawText
    - Skillcheck
    - Progressbar

# Should I use this?

I'll be blunt, most likely not.

This was a test and I haven't personally seen anyone else do this so I went for it for fun

These are as optimizied as possible, but the way you need to render scaleforms them though FiveM is ultimately painful, they cause load on the client side and as far as I know. When no elements of it are being used it runs at 0.00ms

But, as I spent time on this, like how they look and could see some servers maybe using it, here you go.

I'm uploading this for others to use or have fun with

# How do I use this?

This is a completely standalone script, doesn't require any frameworks, its all GTA Natives so this can go in any FiveM server.

Put it in any folder that starts early eg. `[standalone]`

And then in your scripts, make use of the exports/events provided:

## Notifications

### [Example Video](https://streamable.com/z8m22w)

This uses notification types similar to how frameworks usually do it eg "success", "error" but uses emoji to display the icon for them

These are preset in the `notifications.lua`

```lua
-- Example useage
exports["jim-gtaui"]:Notify(
    "Success!",                     -- Title
    "Short test message",           -- Message
    "success"                       -- Notification Type
)

exports["jim-gtaui"]:Notify("Error!", "This is a longer example message to show stacking.", "error")

-- Server side
TriggerClientEvent("jim-gtaui:Notify", -1, "Success!", "Short test message", "success")
-- Client side
TriggerEvent("jim-gtaui:Notify", -1, "Success!", "Short test message", "success")
```

## ProgressBar

### [Example Video](https://streamable.com/eoc1ui)

This is a style recreation of the ingame skill popup, I thought the theme fit well.

```lua
if exports["jim-gtaui"]:progressBar({
    label = "Processing...",                                            -- text label
    time = 5000,                                                        -- time to complete bar
    task = nil,                                                         -- scenario
    dict = "amb@world_human_hang_out_street@female_hold_arm@base",      -- anim dictionary
    anim = "base",                                                      -- anim name
    flag = 49,                                                          -- anim flag
    cancel = true,                                                      -- can the player cancel the progress bar
}) then
    exports["jim-gtaui"]:Notify("Success!", "Short test message", "success")
else
    exports["jim-gtaui"]:Notify("Error!", "This is a longer example message to show stacking.", "error")
end
```

### drawText

### [Example Video](https://streamable.com/fk52wn)

This is a simple drawText function to display a popup of information on the left of the screen, with a little animation to it

```lua
    -- Using drawText() will display and keep on the screen a popup
-- Using hideText() will hide this
-- \n means break the line, making these multiple line popups

exports["jim-gtaui"]:drawText("[E] - Use")

exports["jim-gtaui"]:drawText("[E] - Use\n [G] - Cry")

exports["jim-gtaui"]:drawText("[E] - Use\n [G] - Cry\n [F] - Start Fire")

hideText()
```

### skillCheck

### [Example Video](https://streamable.com/83mdhs)

It started with this module, I was building it for jim_bridge for if it didn't support a skillcheck/minigame script you had, you could use this

Its a simple one, bar moves, press e when its over the highlighted segment, done

```lua
if exports["jim-gtaui"]:skillCheck() then
    exports["jim-gtaui"]:Notify("Success!", "Short test message", "success")
else
    exports["jim-gtaui"]:Notify("Error!", "This is a longer example message to show stacking.", "error")
end
```

# There won't be much support or updates for this script unless theres something game breaking
# You have been warned <3