# LGF Chat 

[SHOWCASE](https://www.youtube.com/watch?v=hE_XRWy4-EE)

[FORUM](https://forum.cfx.re/t/free-lgf-chat-advanced-roleplay-server/5241930)

This resource provides a chat interface for players to communicate in-game. Below are the instructions for using the chat functionality

![image](https://github.com/Legacy-Framework/LGF-Chat/assets/145626625/92ee517c-21a7-4c87-a30a-50e50c97627a)

- **Framework Support**: Compatible with ESX , Qbox and LGF. QBCore support coming soon.
- **Roleplay Integration**: Designed specifically for roleplay servers.
  - **Job Chat**: Communicate with others in the same profession.
  - **Admin Chat**: Dedicated chat for server administrators.
  - **Auto Message**: Automated messages for various events.
  - **Staff Chat**: Exclusive chat for staff members only.
  - **Fully Editable**: Customize to fit your server's needs.
  - **UI Draggable**: Easily reposition the chat interface.




## Sending Messages

To send a message via the chat interface, use the following function:

## Types
```lua
--- @param data table The message data.
--- @param playerId  | number 
--- @param message   | string 
--- @param playerJob | string 
--- @param author    | string 
--- @param bgColor   | string 
--- @param icon      | string 
```

## Exports (Server Side)
```lua
exports['LGF-Chat']:CreateSendMessage({
    playerId = source,              -- The ID of the player sending the message.
    message = 'Your message here',  -- The content of the message.
    playerJob = 'Class or job',     -- Optional: The job or group of the player or the class example 'OOC' ecc.
    author = 'Your Name',           -- The name of the player sending the message.
    bgColor = '#312B2B',            -- Optional: The background color of the message box.
    icon = 'eye'                    -- Optional: The icon to display alongside the message.
})
```
- `playerId` number The ID of the player sending the message.
- `message` string The content of the message.
- `playerJob` string Optional. The job or group of the player sending the message.
- `author` string The name of the player sending the message.
- `bgColor` string Optional. The background color of the message box (#RRGGBB format).
- `icon` string Optional. The icon to display alongside the message.

## Example with ESX

### Global Message
```lua
RegisterCommand('ooc', function(source, args)
    local playerId = source
    local description = table.concat(args, " ")
    if args and #args > 0 then -- Let's avoid sending an empty message
        exports['LGF-Chat']:CreateSendMessage({
            playerId = playerId,
            message = description, 
            playerJob = 'OOC', -- Example You don't want jobs or groups, just put 'OOC' or 'IC' or you choose
            author = playerName,
            bgColor = '#312B2B',
            icon = 'globe'
        })
    end
end)
```
### Job Message
```lua
RegisterCommand('police', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerJob = xPlayer.getJob()
    local Text = table.concat(args, " ")
    if args and #args > 0 then
        if PlayerJob == 'police' then -- check player have correct job
            exports['LGF-Chat']:CreateSendMessage({
                playerId = source,
                message = Text,
                playerJob = PlayerJob,
                author = GetPlayerName(source), -- Use Steam Name
                bgColor = '#312B2B',
                icon = 'user-shield'
            })
        else
            print('no job for send message)
        end
    end
end)
```
