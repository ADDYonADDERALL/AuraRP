resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_02_POP" { url = "https://stream.open.fm/365?type=.ogg&user=800044843833&player_group=WWW", volume = 0.6 }
supersede_radio "RADIO_18_90S_ROCK" { url = "https://stream.open.fm/21?type=.ogg&user=800044843833&player_group=WWW", volume = 0.6 }
supersede_radio "RADIO_07_DANCE_01" { url = "https://stream.open.fm/366?type=.ogg&user=800044843833&player_group=WWW", volume = 0.6 }

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
