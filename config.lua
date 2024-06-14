CFG = {}


-- If 'rp' use game name, if use 'steam' use Steam Name (exclusively for chat without prefix '/' )
CFG.PlayerName = 'rp'
-- If 'true' enable console Message example, (Restart / Stop / Refresh) resource
CFG.EnableSystemPrint = true
-- Command for Open Chat
CFG.CommandOpenChat = 'T'
-- Enable GTA5 Sound message
CFG.EnableSoundMessage = true

-- Group for 'staff' / 'onlystaff' command
CFG.AdminGroup = {
    ['admin'] = true,
    ['player'] = false
}

CFG.OOC = 'ooc'
CFG.POLICE = 'police'
CFG.AMBULANCE = 'ems'
CFG.STAFF = 'admin'
CFG.ONLYSTAFF = 'onlystaff'
CFG.AD = 'ad'


CFG.AutoMessageData = {
    {
        time = 10,           -- in seconds
        message = 'ENT510',  -- Description
        author = 'System',   -- author / title
        bgColor = '#312B2B', -- BG color
        icon = 'bell'        -- Icon
    },
    {
        time = 60,
        message = 'LGF Chat',
        author = 'System',
        bgColor = '#312B2B',
        icon = 'bullhorn'
    },
}