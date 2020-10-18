
------
-- RICHRP_InteractSound by Scott
-- Verstion: v0.0.1
------

-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/demo.ogg',
    'client/html/sounds/seatbelt.ogg',
    'client/html/sounds/Cuff.ogg',
    'client/html/sounds/Uncuff.ogg',
    'client/html/sounds/on.ogg',
    'client/html/sounds/off.ogg',
    'client/html/sounds/pasysound.ogg',
    'client/html/sounds/seaton.ogg',
    'client/html/sounds/seatoff.ogg',
    'client/html/sounds/cele.ogg',
    'client/html/sounds/PinFail.ogg',
    'client/html/sounds/PinSucc.ogg',
    'client/html/sounds/PoliceDispatch.ogg',
    'client/html/sounds/FireDispatch.ogg',
    'client/html/sounds/unlockDoor.ogg',
    'client/html/sounds/lockDoor.ogg',
    'client/html/sounds/SodaMachine.ogg',
    'client/html/sounds/pasysou22nd.ogg',
	'client/html/sounds/wrrrttttkurwa.ogg',
})
