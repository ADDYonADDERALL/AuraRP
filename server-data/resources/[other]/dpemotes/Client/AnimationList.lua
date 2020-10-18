DP = {}

DP.Expressions = {
   ["Zły"] = {"Expression", "mood_angry_1"},
   ["Pijany"] = {"Expression", "mood_drunk_1"},
   ["Głupi"] = {"Expression", "pose_injured_1"},
   ["Porażony prądem"] = {"Expression", "electrocuted_1"},
   ["Gderliwy"] = {"Expression", "effort_1"},
   ["Gderliwy2"] = {"Expression", "mood_drivefast_1"},
   ["Gderliwy3"] = {"Expression", "pose_angry_1"},
   ["Wesoły"] = {"Expression", "mood_happy_1"},
   ["Ranny"] = {"Expression", "mood_injured_1"},
   ["Radosny"] = {"Expression", "mood_dancing_low_1"},
   ["Oddychanie"] = {"Expression", "smoking_hold_1"},
   ["Nigdy nie mrugaj"] = {"Expression", "pose_normal_1"},
   ["Jedno oko"] = {"Expression", "pose_aiming_1"},
   ["Zszokowany"] = {"Expression", "shocked_1"},
   ["Zszokowany2"] = {"Expression", "shocked_2"},
   ["Spanie"] = {"Expression", "mood_sleeping_1"},
   ["Spanie2"] = {"Expression", "dead_1"},
   ["Spanie3"] = {"Expression", "dead_2"},
   ["Zadowolony z siebie"] = {"Expression", "mood_smug_1"},
   ["Spekulacyjny"] = {"Expression", "mood_aiming_1"},
   ["Zestresowany"] = {"Expression", "mood_stressed_1"},
   ["Kapryśny"] = {"Expression", "mood_sulk_1"},
   ["Dziwne"] = {"Expression", "effort_2"},
   ["Dziwne2"] = {"Expression", "effort_3"},
}

DP.Walks = {
  ["Obcy"] = {"move_m@alien"},
  ["Opancerzony"] = {"anim_group_move_ballistic"},
  ["Arogancki"] = {"move_f@arrogant@a"},
  ["Odważny"] = {"move_m@brave"},
  ["Codzienny"] = {"move_m@casual@a"},
  ["Codzienny2"] = {"move_m@casual@b"},
  ["Codzienny3"] = {"move_m@casual@c"},
  ["Codzienny4"] = {"move_m@casual@d"},
  ["Codzienny5"] = {"move_m@casual@e"},
  ["Codzienny6"] = {"move_m@casual@f"},
  ["Chichi"] = {"move_f@chichi"},
  ["Pewny siebie"] = {"move_m@confident"},
  ["Policjant"] = {"move_m@business@a"},
  ["Policjant2"] = {"move_m@business@b"},
  ["Policjant3"] = {"move_m@business@c"},
  ["Domyślnie kobieta"] = {"move_f@multiplayer"},
  ["Domyślnie mężczyzna"] = {"move_m@multiplayer"},
  ["Pijany"] = {"move_m@drunk@a"},
  ["Mocno Pijany"] = {"move_m@drunk@slightlydrunk"},
  ["Pijany2"] = {"move_m@buzzed"},
  ["Pijany3"] = {"move_m@drunk@verydrunk"},
  ["Niewiasta"] = {"move_f@femme@"},
  ["Ogień"] = {"move_characters@franklin@fire"},
  ["Ogień2"] = {"move_characters@michael@fire"},
  ["Ogień3"] = {"move_m@fire"},
  ["Uciekanie"] = {"move_f@flee@a"},
  ["Franklin"] = {"move_p_m_one"},
  ["Gangster"] = {"move_m@gangster@generic"},
  ["Gangster2"] = {"move_m@gangster@ng"},
  ["Gangster3"] = {"move_m@gangster@var_e"},
  ["Gangster4"] = {"move_m@gangster@var_f"},
  ["Gangster5"] = {"move_m@gangster@var_i"},
  ["Żłobanie"] = {"anim@move_m@grooving@"},
  ["Ochoniarz"] = {"move_m@prison_gaurd"},
  ["Zakuty"] = {"move_m@prisoner_cuffed"},
  ["Obcasy"] = {"move_f@heels@c"},
  ["Obcasy2"] = {"move_f@heels@d"},
  ["Wędrowka"] = {"move_m@hiking"},
  ["Hipster"] = {"move_m@hipster@a"},
  ["Włóczęga"] = {"move_m@hobo@a"},
  ["Pośpiech"] = {"move_f@hurry@a"},
  ["Dozorca"] = {"move_p_m_zero_janitor"},
  ["Dozorca2"] = {"move_p_m_zero_slow"},
  ["Trucht"] = {"move_m@jog@"},
  ["Lemar"] = {"anim_group_move_lemar_alley"},
  ["Lester"] = {"move_heist_lester"},
  ["Lester2"] = {"move_lester_caneup"},
  ["Ludojad"] = {"move_f@maneater"},
  ["Michael"] = {"move_ped_bucket"},
  ["Bogaty"] = {"move_m@money"},
  ["Umięśniony"] = {"move_m@muscle@a"},
  ["Szykowny"] = {"move_m@posh@"},
  ["Szykowny2"] = {"move_f@posh@"},
  ["Szybki"] = {"move_m@quick"},
  ["Biegacz"] = {"female_fast_runner"},
  ["Smutny"] = {"move_m@sad@a"},
  ["Impertynencki"] = {"move_m@sassy"},
  ["Impertynencki2"] = {"move_f@sassy"},
  ["Przestraszony"] = {"move_f@scared"},
  ["Seksowny"] = {"move_f@sexy@a"},
  ["Zacieniony"] = {"move_m@shadyped@a"},
  ["Wolny"] = {"move_characters@jimmy@slow@"},
  ["Wywyższony"] = {"move_m@swagger"},
  ["Twardy"] = {"move_m@tough_guy@"},
  ["Twardy2"] = {"move_f@tough_guy@"},
  ["Śmieci"] = {"clipset@move@trash_fast_turn"},
  ["Śmieci2"] = {"missfbi4prepp1_garbageman"},
  ["Trevor"] = {"move_p_m_two"},
  ["Szeroki"] = {"move_m@bag"},
  -- I cant get these to work for some reason, if anyone knows a fix lmk
  --["Caution"] = {"move_m@caution"},
  --["Chubby"] = {"anim@move_m@chubby@a"},
  --["Crazy"] = {"move_m@crazy"},
  --["Joy"] = {"move_m@joy@a"},
  --["Power"] = {"move_m@power"},
  --["Sad2"] = {"anim@move_m@depression@a"},
  --["Sad3"] = {"move_m@depression@b"},
  --["Sad4"] = {"move_m@depression@d"},
  --["Wading"] = {"move_m@wading"},
}

DP.Shared = {
   --[emotename] = {dictionary, animation, displayname, targetemotename, additionalanimationoptions}
   -- you dont have to specify targetemoteanem, if you do dont it will just play the same animation on both.
   -- targetemote is used for animations that have a corresponding animation to the other player.
   ["handshake2"] = {"mp_ped_interaction", "handshake_guy_a", "Przywitaj 2", "handshake2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
       SyncOffsetFront = 0.9
   }},
   ["przywitaj"] = {"mp_ped_interaction", "handshake_guy_b", "Przywitaj", "przywitaj", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }},
   ["przytul2"] = {"mp_ped_interaction", "kisses_guy_a", "Przytul 2", "przytul2", AnimationOptions =
   {
       EmoteMoving = false,
       EmoteDuration = 5000,
       SyncOffsetFront = 1.05,
   }},
   ["przytul"] = {"mp_ped_interaction", "kisses_guy_b", "Przytul", "przytul", AnimationOptions =
   {
       EmoteMoving = false,
       EmoteDuration = 5000,
       SyncOffsetFront = 1.13
   }},
   ["bro2"] = {"mp_ped_interaction", "hugs_guy_a", "Brachu", "bro2", AnimationOptions =
   {
        SyncOffsetFront = 1.14
   }},
   ["bro"] = {"mp_ped_interaction", "hugs_guy_b", "Brachu 2", "bro", AnimationOptions =
   {
        SyncOffsetFront = 1.14
   }},
   ["give2"] = {"mp_common", "givetake1_a", "Daj", "give2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000
   }},
   ["give"] = {"mp_common", "givetake1_b", "Daj 2", "give", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000
   }},
   ["baseball"] = {"anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_a", "Baseball", "baseballthrow"},
   ["baseballthrow"] = {"anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_b", "Rzut baseballowy", "baseball"},
   ["stickup"] = {"random@countryside_gang_fight", "biker_02_stickup_loop", "Celowanie 2", "stickupscared", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["stickupscared"] = {"missminuteman_1ig_2", "handsup_base", "Celowanie", "stickup", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }},
   ["punch"] = {"melee@unarmed@streamed_variations", "plyr_takedown_rear_lefthook", "Uderzenie", "punched"},
   ["punched"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_cross_r", "Bycie uderzonym", "punch"},
   ["headbutt"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Uderzenie z główki", "headbutted"},
   ["headbutted"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_headbutt", "Uderzony z główki", "headbutt"},
   ["slap2"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_backslap", "Spoliczkowanie 2", "slapped2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["slap"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Spoliczkowanie", "slapped", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["slapped"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_slap", "Spoliczkowany", "slap"},
   ["slapped2"] = {"melee@unarmed@streamed_variations", "victim_takedown_front_backslap", "Spoliczkowany 2", "slap2"},
   ["Receive Blowjob"] = {"misscarsteal2pimpsex", "pimpsex_punter", "Lodzik", "Give Blowjob", AnimationOptions =
    {
    EmoteMoving = false,
    EmoteDuration = 30000,
    SyncOffsetFront = 0.63
   }},
    ["Give Blowjob"] = {"misscarsteal2pimpsex", "pimpsex_hooker", "Rob Loda", "Receive Blowjob", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteDuration = 30000,
        SyncOffsetFront = 0.63
    }},
    ["Street Sex Male"] = {"misscarsteal2pimpsex", "shagloop_pimp", "R***anie na ulicy", "Street Sex Female", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = 0.50
    }},
    ["Street Sex Female"] = {"misscarsteal2pimpsex", "shagloop_hooker", "R***any/a na ulicy", "Street Sex Male", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteLoop = true,
        SyncOffsetFront = -0.50
    }},
}

DP.Dances = {
   ["taniecf"] = {"anim@amb@nightclub@dancers@solomun_entourage@", "mi_dance_facedj_17_v1_female^1", "Taniec F", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecf2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center", "Taniec F2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecf3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Taniec F3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecf4"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^1", "Taniec F4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecf5"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^3", "Taniec F5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecf6"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Taniec F6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["powolnytaniec2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center", "Powolny taniec 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["powolnytaniec3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center_down", "Powolny taniec 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["powolnytaniec4"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center", "Powolny taniec 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec"] = {"anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5", "Taniec", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec2"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", "Taniec 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec3"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", "Taniec 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec4"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_up", "Taniec 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniecgora"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center", "Taniec góra", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["taniecgora2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center_up", "Taniec góra 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["niesmialytaniec"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "low_center", "Nieśmiały taniec", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["niesmialytaniec2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down", "Nieśmiały taniec 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["powolnytaniec"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "low_center", "Powolny taniec", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec9"] = {"rcmnigel1bnmt_1b", "dance_loop_tyler", "Głupi taniec 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec6"] = {"misschinese2_crystalmazemcs1_cs", "dance_loop_tao", "Taniec6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec7"] = {"misschinese2_crystalmazemcs1_ig", "dance_loop_tao", "Taniec 7", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec8"] = {"missfbi3_sniping", "dance_m_default", "Taniec 8", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec"] = {"special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag", "Głupi taniec", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec2"] = {"move_clown@p_m_zero_idles@", "fidget_short_dance", "Głupi taniec 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec3"] = {"move_clown@p_m_two_idles@", "fidget_short_dance", "Głupi taniec 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec4"] = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_11_buttwiggle_b_laz", "Głupi taniec 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec5"] = {"timetable@tracy@ig_5@idle_a", "idle_a", "Głupi taniec 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec6"] = {"timetable@tracy@ig_8@idle_b", "idle_d", "Głupi taniec 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["taniec9"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_center_up", "Taniec 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["glupitaniec8"] = {"anim@mp_player_intcelebrationfemale@the_woogie", "the_woogie", "Głupi taniec 8", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["glupitaniec7"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", "Głupi taniec 7", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["taniec5"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_a@", "med_center", "Taniec 5", AnimationOptions =
   {
       EmoteLoop = true
   }},
   ["danceglowstick"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_13_mi_hi_sexualgriding_laz", "Taniec z świecącymi patykami", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["danceglowstick2"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_12_mi_hi_bootyshake_laz", "Taniec z świecącymi patykami 2", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
   }},
   ["danceglowstick3"] = {"anim@amb@nightclub@lazlow@hi_railing@", "ambclub_09_mi_hi_bellydancer_laz", "Taniec z świecącymi patykami 3", AnimationOptions =
   {
       Prop = 'ba_prop_battle_glowstick_01',
       PropBone = 28422,
       PropPlacement = {0.0700,0.1400,0.0,-80.0,20.0},
       SecondProp = 'ba_prop_battle_glowstick_01',
       SecondPropBone = 60309,
       SecondPropPlacement = {0.0700,0.0900,0.0,-120.0,-20.0},
       EmoteLoop = true,
   }},
   ["tanieckon"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_15_handup_laz", "Taniec na koniu", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tanieckon2"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "crowddance_hi_11_handup_laz", "Taniec na koniu 2", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
   }},
   ["tanieckon3"] = {"anim@amb@nightclub@lazlow@hi_dancefloor@", "dancecrowd_li_11_hu_shimmy_laz", "Taniec na koniu 3", AnimationOptions =
   {
       Prop = "ba_prop_battle_hobby_horse",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
   }},
}

DP.Emotes = {
   ["picie"] = {"mp_player_inteat@pnq", "loop", "Picie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2500,
   }},
   ["bestia"] = {"anim@mp_fm_event@intro", "beast_transform", "Bestia", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 5000,
   }},
   ["chill"] = {"switch@trevor@scares_tramp", "trev_scares_tramp_idle_tramp", "Chillowanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["chmury"] = {"switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_girl", "Oglądanie chmur", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["chmury2"] = {"switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_guy", "Oglądanie chmur 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["prone"] = {"missfbi3_sniping", "prone_dave", "Czołganie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["pullover"] = {"misscarsteal3pullover", "pull_over_right", "Zjeżdzaj na pobocze", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1300,
   }},
   ["stanie"] = {"anim@heists@heist_corona@team_idles@male_a", "idle", "Stanie w miejscu", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie8"] = {"amb@world_human_hang_out_street@male_b@idle_a", "idle_b", "Stanie w miejscu 8"},
   ["stanie9"] = {"friends@fra@ig_1", "base_idle", "Stanie w miejscu 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie10"] = {"mp_move@prostitute@m@french", "idle", "Stanie w miejscu 10", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["stanie11"] = {"random@countrysiderobbery", "idle_a", "Stanie w miejscu 11", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie2"] = {"anim@heists@heist_corona@team_idles@female_a", "idle", "Stanie w miejscu 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie3"] = {"anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", "Stanie w miejscu 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie4"] = {"anim@mp_celebration@idles@female", "celebration_idle_f_a", "Stanie w miejscu 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie5"] = {"anim@mp_corona_idles@female_b@idle_a", "idle_a", "Stanie w miejscu 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie6"] = {"anim@mp_corona_idles@male_c@idle_a", "idle_a", "Stanie w miejscu 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie7"] = {"anim@mp_corona_idles@male_d@idle_a", "idle_a", "Stanie w miejscu 7", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["czekanie3"] = {"amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", "Czekanie 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie12"] = {"random@drunk_driver_1", "drunk_driver_stand_loop_dd1", "Stanie napitym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie13"] = {"random@drunk_driver_1", "drunk_driver_stand_loop_dd2", "Stanie napitym 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stanie14"] = {"missarmenian2", "standing_idle_loop_drunk", "Stanie napitym 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["gitara5"] = {"anim@mp_player_intcelebrationfemale@air_guitar", "air_guitar", "Udawanie gry na gitarze"},
   ["machanie"] = {"anim@mp_player_intcelebrationfemale@air_synth", "air_synth", "Machanie rękoma"},
   ["tlumaczenie"] = {"misscarsteal4@actor", "actor_berating_loop", "Tłumaczenie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tlumaczenie2"] = {"oddjobs@assassinate@vice@hooker", "argue_a", "Tłumaczenie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["recegora"] = {"anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", "Ręce w górze", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pocalunek"] = {"anim@mp_player_intcelebrationfemale@blow_kiss", "blow_kiss", "Posłanie pocałunku"},
   ["pocalunek2"] = {"anim@mp_player_intselfieblow_kiss", "exit", "Posłanie pocałunku 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000

   }},
   ["uklon"] = {"anim@mp_player_intcelebrationpaired@f_f_sarcastic", "sarcastic_left", "Ukłon"},
   ["rozlozenie"] = {"misscommon@response", "bring_it_on", "Rozłożenie rąk", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }},
   ["chodztutaj"] = {"mini@triathlon", "want_some_of_this", "Chodz tutaj", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000
   }},
   ["policjant2"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Policjant 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["policjant3"] = {"amb@code_human_police_investigate@idle_a", "idle_b", "Policjant 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["rece"] = {"amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a", "Skrzyżowane ręce", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece2"] = {"amb@world_human_hang_out_street@male_c@idle_a", "idle_b", "Skrzyżowane ręce 2", AnimationOptions =
   {
       EmoteMoving = true,
   }},
   ["rece3"] = {"anim@heists@heist_corona@single_team", "single_team_loop_boss", "Skrzyżowane ręce 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece4"] = {"random@street_race", "_car_b_lookout", "Skrzyżowane ręce 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece5"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Skrzyżowane ręce 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece6"] = {"anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Założone ręce", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece7"] = {"random@shop_gunstore", "_idle", "Założone ręce 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece8"] = {"anim@amb@business@bgen@bgen_no_work@", "stand_phone_phoneputdown_idle_nowork", "Założone ręce 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rece9"] = {"rcmnigel1a_band_groupies", "base_m2", "Założone ręce 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["recetyl"] = {"anim@miss@low@fin@vagos@", "idle_ped06", "Ręce do tyłu", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["kurcze"] = {"gestures@m@standing@casual", "gesture_damn", "Kurcze", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }},
   ["kurcze2"] = {"anim@am_hold_up@male", "shoplift_mid", "Kurcze 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }},
   ["pokazywanie3"] = {"gestures@f@standing@casual", "gesture_hand_down", "Pokazywanie w dół", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }},
   ["poddajsie"] = {"random@arrests@busted", "idle_a", "Poddaj sie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["facepalm2"] = {"anim@mp_player_intcelebrationfemale@face_palm", "face_palm", "Facepalm 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }},
   ["facepalm"] = {"random@car_thief@agitated@idle_a", "agitated_idle_a", "Facepalm", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }},
   ["facepalm3"] = {"missminuteman_1ig_2", "tasered_2", "Facepalm 3", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 8000
   }},
   ["facepalm4"] = {"anim@mp_player_intupperface_palm", "idle_a", "Facepalm 4", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }},
   ["upadek"] = {"random@drunk_driver_1", "drunk_fall_over", "Upadek"},
   ["upadek2"] = {"mp_suicide", "pistol", "Upadek 2"},
   ["upadek3"] = {"mp_suicide", "pill", "Upadek 3"},
   ["upadek4"] = {"friends@frf@ig_2", "knockout_plyr", "Upadek 4"},
   ["upadek5"] = {"anim@gangops@hostage@", "victim_fail", "Upadek 5"},
   ["upadek6"] = {"mp_sleep", "sleep_loop", "Upadek 6", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }},
   ["walcz"] = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_c", "Walcze ze mna"},
   ["walcz2"] = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_e", "Walcz ze mna 2"},
   ["palec"] = {"anim@mp_player_intselfiethe_bird", "idle_a", "Palec", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["palec2"] = {"anim@mp_player_intupperfinger", "idle_a_fp", "Palec 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["przywitaj"] = {"mp_ped_interaction", "handshake_guy_a", "Przywitaj", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }},
   ["przywitaj2"] = {"mp_ped_interaction", "handshake_guy_b", "Przywitaj 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000
   }},
   ["czekanie4"] = {"amb@world_human_hang_out_street@Female_arm_side@idle_a", "idle_a", "Czekanie 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["czekanie5"] = {"missclothing", "idle_storeclerk", "Czekanie 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie6"] = {"timetable@amanda@ig_2", "ig_2_base_amanda", "Czekanie 6", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie7"] = {"rcmnigel1cnmt_1c", "base", "Czekanie 7", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie8"] = {"rcmjosh1", "idle", "Czekanie 8", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie9"] = {"rcmjosh2", "josh_2_intp1_base", "Czekanie 9", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie10"] = {"timetable@amanda@ig_3", "ig_3_base_tracy", "Czekanie 10", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie11"] = {"misshair_shop@hair_dressers", "keeper_base", "Czekanie 11", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["plecak2"] = {"move_m@hiking", "idle", "Noszenie plecaka", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["przytul"] = {"mp_ped_interaction", "kisses_guy_a", "Przytul"},
   ["przytul2"] = {"mp_ped_interaction", "kisses_guy_b", "Przytul 2"},
   ["przytul3"] = {"mp_ped_interaction", "hugs_guy_a", "Przytul 3"},
   ["sprawdzanie"] = {"random@train_tracks", "idle_e", "Sprawdzanie"},
   ["jazzhands"] = {"anim@mp_player_intcelebrationfemale@jazz_hands", "jazz_hands", "Jazzhands", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 6000,
   }},
   ["jog2"] = {"amb@world_human_jog_standing@male@idle_a", "idle_a", "Joga 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["jog3"] = {"amb@world_human_jog_standing@female@idle_a", "idle_a", "Joga 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["jog4"] = {"amb@world_human_power_walker@female@idle_a", "idle_a", "Joga 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["jog5"] = {"move_m@joy@a", "walk", "Joga 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pajacyki"] = {"timetable@reunited@ig_2", "jimmy_getknocked", "Pajacyki", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["klekanie2"] = {"rcmextreme3", "idle", "Klękanie 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["klekanie3"] = {"amb@world_human_bum_wash@male@low@idle_a", "idle_a", "Klękanie 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["pukanie"] = {"timetable@jimmy@doorknock@", "knockdoor_idle", "Pukanie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true,
   }},
   ["pukanie2"] = {"missheistfbi3b_ig7", "lift_fibagent_loop", "Pukanie 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["strzelaniekostkami"] = {"anim@mp_player_intcelebrationfemale@knuckle_crunch", "knuckle_crunch", "Strzelanie kostkami", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["erotyczny"] = {"mp_safehouse", "lap_dance_girl", "Taniec erotyczny"},
   ["opieranie2"] = {"amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", "Opieranie 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie3"] = {"amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", "idle_a", "Opieranie 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie4"] = {"amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a", "Opieranie 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie5"] = {"amb@world_human_leaning@male@wall@back@hands_together@idle_b", "idle_b", "Opieranie 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie10"] = {"random@street_race", "_car_a_flirt_girl", "Opieranie się o kolana", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie7"] = {"amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", "Opieranie o bar 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie8"] = {"anim@amb@nightclub@lazlow@ig1_vip@", "clubvip_base_laz", "Opieranie o bar 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie9"] = {"anim@heists@prison_heist", "ped_b_loop_a", "Opieranie o bar 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["opieranie11"] = {"anim@mp_ferris_wheel", "idle_a_player_one", "Opieranie wysoko", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["opieranie12"] = {"anim@mp_ferris_wheel", "idle_a_player_two", "Opieranie wysoko 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["opieranie13"] = {"timetable@mime@01_gc", "idle_a", "Opieranie się o bok", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["opieranie14"] = {"misscarstealfinale", "packer_idle_1_trevor", "Opieranie się o bok 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["opieranie15"] = {"misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Opieranie się o bok 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["opieranie16"] = {"misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Opieranie się o bok 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }},
   ["opieranie17"] = {"rcmjosh2", "josh_2_intp1_base", "Opieranie się o bok 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }},
   ["opieranie17"] = {"rcmjosh2", "josh_2_intp1_base", "Opieranie się o bok 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }},
   ["me"] = {"gestures@f@standing@casual", "gesture_me_hard", "Mnie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000
   }},
   ["mechanik"] = {"mini@repair", "fixing_a_ped", "Mechanik", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["mechanik2"] = {"amb@world_human_vehicle_mechanic@male@base", "idle_a", "Mechanik 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["mechanik3"] = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Mechanik 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["mechanik4"] = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Mechanik 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["medic2"] = {"amb@medic@standing@tendtodead@base", "base", "Medyk 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["medytacja"] = {"rcmcollect_paperleadinout@", "meditiate_idle", "Medytacja", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }},
   ["medytacja2"] = {"rcmepsilonism3", "ep_3_rcm_marnie_meditating", "Medytacja 2", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }},
   ["medytacja3"] = {"rcmepsilonism3", "base_loop", "Medytacja 3", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
   }},
   ["metal"] = {"anim@mp_player_intincarrockstd@ps@", "idle_a", "Metal", AnimationOptions = -- CHANGE ME
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["nie"] = {"anim@heists@ornate_bank@chat_manager", "fail", "Nie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["nie2"] = {"mp_player_int_upper_nod", "mp_player_int_nod_no", "Nie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["dlubanie"] = {"anim@mp_player_intcelebrationfemale@nose_pick", "nose_pick", "Dlubanie w nosie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["nie3"] = {"gestures@m@standing@casual", "gesture_no_way", "Nie ma mowy", AnimationOptions =
   {
       EmoteDuration = 1500,
       EmoteMoving = true,
   }},
   ["ok"] = {"anim@mp_player_intselfiedock", "idle_a", "OK", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["zmeczenie"] = {"re@construction", "out_of_breath", "Zmeczenie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["podnoszenie"] = {"random@domestic", "pickup_low", "Podnoszenie z ziemi"},
   ["pchanie"] = {"missfinale_c2ig_11", "pushcar_offcliff_f", "Pchanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["pchanie2"] = {"missfinale_c2ig_11", "pushcar_offcliff_m", "Pchanie 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["pokazywanie"] = {"gestures@f@standing@casual", "gesture_point", "Pokazywanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pompki"] = {"amb@world_human_push_ups@male@idle_a", "idle_d", "Robienie pompek", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["odliczanie"] = {"random@street_race", "grid_girl_race_start", "Odliczanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pokazywanie2"] = {"mp_gun_shop_tut", "indicate_right", "Pokazywanie w prawo", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["salut"] = {"anim@mp_player_intincarsalutestd@ds@", "idle_a", "Salutuj", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["salut2"] = {"anim@mp_player_intincarsalutestd@ps@", "idle_a", "Salutuj 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["salute"] = {"anim@mp_player_intuppersalute", "idle_a", "Salutuj 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["przestraszony"] = {"random@domestic", "f_distressed_loop", "Przestraszony", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["przestraszony2"] = {"random@homelandsecurity", "knees_loop_girl", "Przestraszony 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["walsie"] = {"misscommon@response", "screw_you", "Wal sie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["otrzepanie"] = {"move_m@_idles@shake_off", "shakeoff_1", "Otrzepywanie sie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3500,
   }},
   ["postrzelenie"] = {"random@dealgonewrong", "idle_a", "Postrzelenie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["spanie"] = {"timetable@tracy@sleep@", "idle_c", "Spanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["niewiem"] = {"gestures@f@standing@casual", "gesture_shrug_hard", "Nie wiem", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000,
   }},
   ["niewiem2"] = {"gestures@m@standing@casual", "gesture_shrug_hard", "Nie wiem 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1000,
   }},
   ["siedzenie"] = {"anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", "Siedzenie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie2"] = {"rcm_barry3", "barry_3_sit_loop", "Siedzenie 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie3"] = {"amb@world_human_picnic@male@idle_a", "idle_a", "Siedzenie 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie4"] = {"amb@world_human_picnic@female@idle_a", "idle_a", "Siedzenie 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie5"] = {"anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle", "Siedzenie 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie6"] = {"timetable@jimmy@mics3_ig_15@", "idle_a_jimmy", "Siedzenie 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie7"] = {"anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", "Siedzenie 7", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie8"] = {"timetable@jimmy@mics3_ig_15@", "mics3_15_base_jimmy", "Siedzenie 8", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie9"] = {"amb@world_human_stupor@male@idle_a", "idle_a", "Siedzenie 9", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie10"] = {"timetable@tracy@ig_14@", "ig_14_base_tracy", "Siedzenie pochylonym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie11"] = {"anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", "Siedzenie smutnym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie12"] = {"anim@heists@ornate_bank@hostages@hit", "hit_loop_ped_b", "Siedzenie przestraszonym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie13"] = {"anim@heists@ornate_bank@hostages@ped_c@", "flinch_loop", "Siedzenie przestraszonym 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie14"] = {"anim@heists@ornate_bank@hostages@ped_e@", "flinch_loop", "Siedznie przestarszonym 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie15"] = {"timetable@amanda@drunk@base", "base", "Siedzenie upitym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie17"] = {"timetable@ron@ig_5_p3", "ig_5_p3_base", "Siedzenie na krześle 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie18"] = {"timetable@reunited@ig_10", "base_amanda", "Siedzenie na krześle 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie19"] = {"timetable@ron@ig_3_couch", "base", "Siedzenie na krześle 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie20"] = {"timetable@jimmy@mics3_ig_15@", "mics3_15_base_tracy", "Siedznie na krześle 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie21"] = {"timetable@maid@couch@", "base", "Siedznie na krześle 6", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["siedzenie22"] = {"timetable@ron@ron_ig_2_alt1", "ig_2_alt1_base", "Siedzenie na krześle pochylonym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["brzuszki"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a", "Brzuszki", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["klaskanie5"] = {"anim@arena@celeb@flat@solo@no_props@", "angry_clap_a_player_a", "Klaskanie wkurzonym", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["klaskanie4"] = {"anim@mp_player_intupperslow_clap", "idle_a", "Wolne klaskanie 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["klaskanie"] = {"amb@world_human_cheering@male_a", "base", "Klaskanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["klaskanie2"] = {"anim@mp_player_intcelebrationfemale@slow_clap", "slow_clap", "Wolne klaskanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["klaskanie3"] = {"anim@mp_player_intcelebrationmale@slow_clap", "slow_clap", "Wolne klaskanie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["wachanie"] = {"move_p_m_two_idles@generic", "fidget_sniff_fingers", "Wąchanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["stickup"] = {"random@countryside_gang_fight", "biker_02_stickup_loop", "Napad", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["stumble"] = {"misscarsteal4@actor", "stumble", "Potknij się", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["stunned"] = {"stungun@standing", "damage", "Oszołomiony", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["sunbathe"] = {"amb@world_human_sunbathe@male@back@base", "base", "Opalanie się", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["sunbathe2"] = {"amb@world_human_sunbathe@female@back@base", "base", "Opalanie się 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["t"] = {"missfam5_yoga", "a2_pose", "Poza T", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["t2"] = {"mp_sleep", "bind_pose_180", "Poza T 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["myslenie5"] = {"mp_cp_welcome_tutthink", "b_think", "Myślenie 5", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["myslenie"] = {"misscarsteal4@aliens", "rehearsal_base_idle_director", "Myślenie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["myslenie3"] = {"timetable@tracy@ig_8@base", "base", "Myślenie 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},

   ["myslenie2"] = {"missheist_jewelleadinout", "jh_int_outro_loop_a", "Myślenie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["kciuk3"] = {"anim@mp_player_intincarthumbs_uplow@ds@", "enter", "Kciuk w góre 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }},
   ["kciuk2"] = {"anim@mp_player_intselfiethumbs_up", "idle_a", "Kciuk w góre", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["kciuk"] = {"anim@mp_player_intupperthumbs_up", "idle_a", "Kciuki w góre", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pisanie"] = {"anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", "Pisanie na klawiaturze", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pisanie2"] = {"anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", "Pisanie na klawiaturze 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pisanie3"] = {"mp_prison_break", "hack_loop", "Pisanie na klawiaturze 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pisanie4"] = {"mp_fbi_heist", "loop", "Pisanie na klawiaturze 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["egrzewanie"] = {"amb@world_human_stand_fire@male@idle_a", "idle_a", "Ciepło", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie4"] = {"random@mugging5", "001445_01_gangintimidation_1_female_idle_b", "Machanie 4", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }},
   ["machanie2"] = {"anim@mp_player_intcelebrationfemale@wave", "wave", "Machanie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie3"] = {"friends@fra@ig_1", "over_here_idle_a", "Machanie 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie"] = {"friends@frj@ig_1", "wave_a", "Machanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie5"] = {"friends@frj@ig_1", "wave_b", "Machanie 5", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie6"] = {"friends@frj@ig_1", "wave_c", "Machanie 6", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie7"] = {"friends@frj@ig_1", "wave_d", "Machanie 7", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie8"] = {"friends@frj@ig_1", "wave_e", "Machanie 8", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["machanie9"] = {"gestures@m@standing@casual", "gesture_hello", "Machanie 9", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["gwizdanie"] = {"taxi_hail", "hail_taxi", "Gwizdanie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 1300,
   }},
   ["gwizdanie2"] = {"rcmnigel1c", "hailing_whistle_waive_a", "Gwizdanie 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["yeah"] = {"anim@mp_player_intupperair_shagging", "idle_a", "Tak", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["podnies"] = {"random@hitch_lift", "idle_f", "Podnieś", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["smiech"] = {"anim@arena@celeb@flat@paired@no_props@", "laugh_a_player_b", "Śmiech", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["smiech2"] = {"anim@arena@celeb@flat@solo@no_props@", "giggle_a_player_b", "Śmiech 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["statula2"] = {"fra_0_int-1", "cs_lamardavis_dual-1", "Udawanie statuły 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["statula3"] = {"club_intro2-0", "csb_englishdave_dual-0", "Udawanie statuły  3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["gangsign"] = {"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", "Gangsterska Gestykulacja", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["gangsign2"] = {"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", "Gangsterska Gestykulacja 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["smierc"] = {"missarmenian2", "drunk_loop", "Śmierć", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["smierc2"] = {"missarmenian2", "corpse_search_exit_ped", "Śmierć 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["operacja"] = {"anim@gangops@morgue@table@", "body_search", "Operacja", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["smierc4"] = {"mini@cpr@char_b@cpr_def", "cpr_pumpchest_idle", "Śmierć 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["smierc5"] = {"random@mugging4", "flee_backward_loop_shopkeeper", "Śmierć 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["pieszczoty"] = {"creatures@rottweiler@tricks@", "petting_franklin", "Pieszczoty", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["czolganie"] = {"move_injured_ground", "front_loop", "Czołganie się", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["capoeira"] = {"anim@arena@celeb@flat@solo@no_props@", "cap_a_player_a", "Capoeira"},
   ["salto"] = {"anim@arena@celeb@flat@solo@no_props@", "flip_a_player_a", "Salto"},
   ["wslizg"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_a_player_a", "Wslizg"},
   ["wslizg2"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_b_player_a", "Wslizg 2"},
   ["wslizg3"] = {"anim@arena@celeb@flat@solo@no_props@", "slide_c_player_a", "Wslizg 3"},
   ["kij"] = {"anim@arena@celeb@flat@solo@no_props@", "slugger_a_player_a", "Uderzenie z kija"},
   ["fuck"] = {"anim@arena@celeb@podium@no_prop@", "flip_off_a_1st", "Fuck", AnimationOptions =
   {
       EmoteMoving = true,
   }},
   ["fuck2"] = {"anim@arena@celeb@podium@no_prop@", "flip_off_c_1st", "Fuck 2", AnimationOptions =
   {
       EmoteMoving = true,
   }},
   ["uklon2"] = {"anim@arena@celeb@podium@no_prop@", "regal_c_1st", "Ukłon 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["uklon3"] = {"anim@arena@celeb@podium@no_prop@", "regal_a_1st", "Ukłon 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["guzik"] = {"anim@mp_player_intmenu@key_fob@", "fob_click", "Wciskanie guzika", AnimationOptions =
   {
       EmoteLoop = false,
       EmoteMoving = true,
       EmoteDuration = 1000,
   }},
   ["golf"] = {"rcmnigel1d", "swing_a_mark", "Granie w gofa"},
   ["jedzenie"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Jedzenie", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 3000,
   }},
   ["reaching"] = {"move_m@intimidation@cop@unarmed", "idle", "Sięganie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie"] = {"random@shop_tattoo", "_idle_a", "Czekanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie2"] = {"missbigscore2aig_3", "wait_for_van_c", "Czekanie 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie12"] = {"rcmjosh1", "idle", "Czekanie 12", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekanie13"] = {"rcmnigel1a", "base", "Czekanie 13", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["erotyczny2"] = {"mini@strip_club@private_dance@idle", "priv_dance_idle", "Taniec erotyczny 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["erotyczny3"] = {"mini@strip_club@private_dance@part2", "priv_dance_p2", "Taniec erotyczny 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["erotyczny3"] = {"mini@strip_club@private_dance@part3", "priv_dance_p3", "Taniec erotyczny 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["twerk"] = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper", "Twerkowanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["policzkowanie"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Policzkowanie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
       EmoteDuration = 2000,
   }},
   ["glowka"] = {"melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Uderzenie z główki"},
   ["taniecryba"] = {"anim@mp_player_intupperfind_the_fish", "idle_a", "Taniec ryby", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pokoj"] = {"mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", "Pokój", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pokoj2"] = {"anim@mp_player_intupperpeace", "idle_a", "Pokój 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rko"] = {"mini@cpr@char_a@cpr_str", "cpr_pumpchest", "RKO", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["rko2"] = {"mini@cpr@char_a@cpr_str", "cpr_pumpchest", "RKO 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["ledge"] = {"missfbi1", "ledge_loop", "Półka", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["samolot"] = {"missfbi1", "ledge_loop", "Samolot", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["zerkanie"] = {"random@paparazzi@peek", "left_peek_a", "Zerkanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["kaszel"] = {"timetable@gardener@smoking_joint", "idle_cough", "Kaszel", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rozciaganie"] = {"mini@triathlon", "idle_e", "Rozciąganie się", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["rozciaganie2"] = {"mini@triathlon", "idle_f", "Rozciąganie się 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["rozciaganie3"] = {"mini@triathlon", "idle_d", "Rozciąganie się 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["rozciaganie4"] = {"rcmfanatic1maryann_stretchidle_b", "idle_e", "Rozciąganie się 4", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["celebrowanie"] = {"rcmfanatic1celebrate", "celebrate", "Celebrowanie", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["uderzanie"] = {"rcmextreme2", "loop_punching", "Uderzenie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["superbohater"] = {"rcmbarry", "base", "Superbohater", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["superbohater2"] = {"rcmbarry", "base", "Superbohater 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["mindcontrol"] = {"rcmbarry", "mind_control_b_loop", "Kontrola umysłu", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["mindcontrol2"] = {"rcmbarry", "bar_1_attack_idle_aln", "Kontrola umysłu 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["blazen"] = {"rcm_barry2", "clown_idle_0", "Błazen", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["blazen2"] = {"rcm_barry2", "clown_idle_1", "Błazen 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["blazen3"] = {"rcm_barry2", "clown_idle_2", "Błazen 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["blazen4"] = {"rcm_barry2", "clown_idle_3", "Błazen 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["blazen5"] = {"rcm_barry2", "clown_idle_6", "Błazen 5", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["przymierzanie"] = {"mp_clothing@female@trousers", "try_trousers_neutral_a", "Przymierz ubrania", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["przymierzanie2"] = {"mp_clothing@female@shirt", "try_shirt_positive_a", "Przymierz ubrania 2", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["przymierzanie3"] = {"mp_clothing@female@shoes", "try_shoes_positive_a", "Przymierz ubrania 3", AnimationOptions =
   {
       EmoteLoop = true,
   }},
   ["nerwowy2"] = {"mp_missheist_countrybank@nervous", "nervous_idle", "Nerwowy 2", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["nerwowy"] = {"amb@world_human_bum_standing@twitchy@idle_a", "idle_c", "Nerwowy", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["nerwowy3"] = {"rcmme_tracey1", "nervous_loop", "Nerwowy 3", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rozkuwanie"] = {"mp_arresting", "a_uncuff", "Rozkuwanie kajdanek", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["namaste"] = {"timetable@amanda@ig_4", "ig_4_base", "Namaste", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["dj"] = {"anim@amb@nightclub@djs@dixon@", "dixn_dance_cntr_open_dix", "DJ", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["grozenie"] = {"random@atmrobberygen", "b_atm_mugging", "Grożenie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["radio"] = {"random@arrests", "generic_radio_chatter", "Radio", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["ciagniecie"] = {"random@mugging4", "struggle_loop_b_thief", "Ciągnięcie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["ptak"] = {"random@peyote@bird", "wakeup", "Ptak"},
   ["kurczak"] = {"random@peyote@chicken", "wakeup", "Kurczak", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["szczekanie"] = {"random@peyote@dog", "wakeup", "Szczekanie"},
   ["krolik"] = {"random@peyote@rabbit", "wakeup", "Królik"},
   ["boi"] = {"special_ped@jane@monologue_5@monologue_5c", "brotheradrianhasshown_2", "BOI", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteDuration = 3000,
   }},
   ["dostosowywanie"] = {"missmic4", "michael_tux_fidget", "Dostosowywanie", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteDuration = 4000,
   }},
   ["recedogory"] = {"missminuteman_1ig_2", "handsup_base", "Ręce do góry", AnimationOptions =
   {
      EmoteMoving = true,
      EmoteLoop = true,
   }},
   ["sikanie"] = {"misscarsteal2peeing", "peeing_loop", "Sikanie", AnimationOptions =
   {
       EmoteStuck = true,
       PtfxAsset = "scr_amb_chop",
       PtfxName = "ent_anim_dog_peeing",
       PtfxNoProp = true,
       PtfxPlacement = {-0.05, 0.3, 0.0, 0.0, 90.0, 90.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['pee'],
       PtfxWait = 3000,
   }},

-----------------------------------------------------------------------------------------------------------
------ These are Scenarios, some of these dont work on women and some other issues, but still good to have.
-----------------------------------------------------------------------------------------------------------

   ["bankomat"] = {"Scenario", "PROP_HUMAN_ATM", "Bankomat"},
   ["grill"] = {"MaleScenario", "PROP_HUMAN_BBQ", "Grill"},
   ["kosz"] = {"Scenario", "PROP_HUMAN_BUM_BIN", "Kosz na śmieci"},
   ["lezeniebok"] = {"Scenario", "WORLD_HUMAN_BUM_SLUMPED", "Leżenie na boku"},
   ["doping"] = {"Scenario", "WORLD_HUMAN_CHEERING", "Doping"},
   ["glowadogory"] = {"Scenario", "PROP_HUMAN_MUSCLE_CHIN_UPS", "Głowa do góry"},
   ["clipboard2"] = {"MaleScenario", "WORLD_HUMAN_CLIPBOARD", "Pisanie 2"},
   ["policjant"] = {"Scenario", "WORLD_HUMAN_COP_IDLES", "Policjant"},
   ["kierowanieruchem"] = {"MaleScenario", "WORLD_HUMAN_CAR_PARK_ATTENDANT", "Kierowanie ruchem"},
   ["filmszokujacy"] = {"Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Film szokujący"},
   ["flex"] = {"Scenario", "WORLD_HUMAN_MUSCLE_FLEX", "Flex"},
   ["ochroniarz"] = {"Scenario", "WORLD_HUMAN_GUARD_STAND", "Ochroniarz"},
   ["mlotek"] = {"Scenario", "WORLD_HUMAN_HAMMERING", "Uderzanie młotkiem"},
   ["wywieszanie"] = {"Scenario", "WORLD_HUMAN_HANG_OUT_STREET", "Wywieszanie"},
   ["niecierpliwy"] = {"Scenario", "WORLD_HUMAN_STAND_IMPATIENT", "Niecierpliwy"},
   ["dozorca"] = {"Scenario", "WORLD_HUMAN_JANITOR", "Dozorca"},
   ["jog"] = {"Scenario", "WORLD_HUMAN_JOG_STANDING", "Trucht w miejscu"},
   ["klekanie"] = {"Scenario", "CODE_HUMAN_MEDIC_KNEEL", "Klękanie"},
   ["dmuchawa"] = {"MaleScenario", "WORLD_HUMAN_GARDENER_LEAF_BLOWER", "Dmuchawa do liści"},
   ["opieranie"] = {"Scenario", "WORLD_HUMAN_LEANING", "Opieranie"},
   ["opieranie6"] = {"Scenario", "PROP_HUMAN_BUM_SHOPPING_CART", "Opieranie o bar"},
   ["uwazaj"] = {"Scenario", "CODE_HUMAN_CROSS_ROAD_WAIT", "Uważaj"},
   ["maid"] = {"Scenario", "WORLD_HUMAN_MAID_CLEAN", "Pokojówka"},
   ["medic"] = {"Scenario", "CODE_HUMAN_MEDIC_TEND_TO_DEAD", "Lekarz"},
   ["musician"] = {"MaleScenario", "WORLD_HUMAN_MUSICIAN", "Muzyk"},
   ["notatnik2"] = {"Scenario", "CODE_HUMAN_MEDIC_TIME_OF_DEATH", "Notatnik 2"},
   ["parkometr"] = {"Scenario", "PROP_HUMAN_PARKING_METER", "Parkometr"},
   ["impreza"] = {"Scenario", "WORLD_HUMAN_PARTYING", "Impreza"},
   ["smsowanie"] = {"Scenario", "WORLD_HUMAN_STAND_MOBILE", "SMS-y"},
   ["prosthigh"] = {"Scenario", "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", "Prostytutka wysokiej klasy"},
   ["prostlow"] = {"Scenario", "WORLD_HUMAN_PROSTITUTE_LOW_CLASS", "Prostytutka niskiej klasy"},
   ["puddle"] = {"Scenario", "WORLD_HUMAN_BUM_WASH", "Kałuża"},
   ["rekord"] = {"Scenario", "WORLD_HUMAN_MOBILE_FILM_SHOCKING", "Rekord"},
   -- Sitchair is a litte special, since you want the player to be seated correctly.
   -- So we set it as "ScenarioObject" and do TaskStartScenarioAtPosition() instead of "AtPlace"
   ["siedzenie16"] = {"ScenarioObject", "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", "Siedzenie na krześle"},
   ["smokeweed"] = {"MaleScenario", "WORLD_HUMAN_DRUG_DEALER", "Palenie zioła"},
   ["statue"] = {"Scenario", "WORLD_HUMAN_HUMAN_STATUE", "Statua"},
   ["sunbathe3"] = {"Scenario", "WORLD_HUMAN_SUNBATHE", "Opalanie się 3"},
   ["sunbatheback"] = {"Scenario", "WORLD_HUMAN_SUNBATHE_BACK", "Opalanie się plecy"},
   ["weld"] = {"Scenario", "WORLD_HUMAN_WELDING", "Spawać"},
   ["windowshop"] = {"Scenario", "WORLD_HUMAN_WINDOW_SHOP_BROWSE", "Okno wystawowe"},
   ["joga"] = {"Scenario", "WORLD_HUMAN_YOGA", "Joga"},
   -- CASINO DLC EMOTES (STREAMED)
   ["karate"] = {"anim@mp_player_intcelebrationfemale@karate_chops", "karate_chops", "Karate"},
   ["karate2"] = {"anim@mp_player_intcelebrationmale@karate_chops", "karate_chops", "Karate 2"},
   ["cutthroat"] = {"anim@mp_player_intcelebrationmale@cut_throat", "cut_throat", "Poderżnąć gardło"},
   ["cutthroat2"] = {"anim@mp_player_intcelebrationfemale@cut_throat", "cut_throat", "Poderżnąć gardło 2"},
   ["mindblown"] = {"anim@mp_player_intcelebrationmale@mind_blown", "mind_blown", "Rozbity umysł", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }},
   ["mindblown2"] = {"anim@mp_player_intcelebrationfemale@mind_blown", "mind_blown", "Rozbity umysł 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }},
   ["boks"] = {"anim@mp_player_intcelebrationmale@shadow_boxing", "shadow_boxing", "Boks", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }},
   ["boks2"] = {"anim@mp_player_intcelebrationfemale@shadow_boxing", "shadow_boxing", "Boks 2", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 4000
   }},
   ["smrod"] = {"anim@mp_player_intcelebrationfemale@stinker", "stinker", "Smród", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["myslenie4"] = {"anim@amb@casino@hangout@ped_male@stand@02b@idles", "idle_a", "Myślenie 4", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["krawat"] = {"clothingtie", "try_tie_positive_a", "Dostosuj krawat", AnimationOptions =
   {
       EmoteMoving = true,
       EmoteDuration = 5000
   }},
    ["Blowjob Car Male"] = {"oddjobs@towing", "m_blow_job_loop", "Lodzik w samochodzie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["Blowjob Car Female"] = {"oddjobs@towing", "f_blow_job_loop", "Rob loda w samochodzie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["Sex Car Male"] = {"mini@prostitutes@sexlow_veh", "low_car_sex_loop_player", "R***anie w samochodzie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["Sex Car Female"] = {"mini@prostitutes@sexlow_veh", "low_car_sex_loop_female", "R***any/a w samochodzie", AnimationOptions =
   {
       EmoteLoop = true,
       EmoteMoving = false,
   }},
}

DP.PropEmotes = {
   ["parasol"] = {"amb@world_human_drinking@coffee@male@base", "base", "Parasol", AnimationOptions =
   {
       Prop = "p_amb_brolly_01",
       PropBone = 57005,
       PropPlacement = {0.15, 0.005, 0.0, 87.0, -20.0, 180.0},
       --
       EmoteLoop = true,
       EmoteMoving = true,
   }},

-----------------------------------------------------------------------------------------------------
------ This is an example of an emote with 2 props, pretty simple! ----------------------------------
-----------------------------------------------------------------------------------------------------

   ["noatnik"] = {"missheistdockssetup1clipboard@base", "base", "Notatnik", AnimationOptions =
   {
       Prop = 'prop_notepad_01',
       PropBone = 18905,
       PropPlacement = {0.1, 0.02, 0.05, 10.0, 0.0, 0.0},
       SecondProp = 'prop_pencil_01',
       SecondPropBone = 58866,
       SecondPropPlacement = {0.11, -0.02, 0.001, -120.0, 0.0, 0.0},
       -- EmoteLoop is used for emotes that should loop, its as simple as that.
       -- Then EmoteMoving is used for emotes that should only play on the upperbody.
       -- The code then checks both values and sets the MovementType to the correct one
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["pudelko"] = {"anim@heists@box_carry@", "idle", "Pudełko", AnimationOptions =
   {
       Prop = "hei_prop_heist_box",
       PropBone = 60309,
       PropPlacement = {0.025, 0.08, 0.255, -145.0, 290.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["roza"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Róża", AnimationOptions =
   {
       Prop = "prop_single_rose",
       PropBone = 18905,
       PropPlacement = {0.13, 0.15, 0.0, -100.0, 0.0, -20.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["papieros2"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_c", "Palenie 2", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["papieros3"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_b", "Palenie 3", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["papieros4"] = {"amb@world_human_smoking@female@idle_a", "idle_b", "Palenie 4", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["bongo"] = {"anim@safehouse@bong", "bong_stage3", "Bongo", AnimationOptions =
   {
       Prop = 'hei_heist_sh_bong_01',
       PropBone = 18905,
       PropPlacement = {0.10,-0.25,0.0,95.0,190.0,180.0},
   }},
   ["walizka"] = {"missheistdocksprep1hold_cellphone", "static", "Walizka", AnimationOptions =
   {
       Prop = "prop_ld_suitcase_01",
       PropBone = 57005,
       PropPlacement = {0.39, 0.0, 0.0, 0.0, 266.0, 60.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["walizka2"] = {"missheistdocksprep1hold_cellphone", "static", "Walizka 2", AnimationOptions =
   {
       Prop = "prop_security_case_01",
       PropBone = 57005,
       PropPlacement = {0.10, 0.0, 0.0, 0.0, 280.0, 53.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["fotka"] = {"mp_character_creation@customise@male_a", "loop", "Fotka", AnimationOptions =
   {
       Prop = 'prop_police_id_board',
       PropBone = 58868,
       PropPlacement = {0.12, 0.24, 0.0, 5.0, 0.0, 70.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["kawa"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Kawa", AnimationOptions =
   {
       Prop = 'p_amb_coffeecup_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["whiskey"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions =
   {
       Prop = 'prop_drink_whisky',
       PropBone = 28422,
       PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["piwo"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Piwo", AnimationOptions =
   {
       Prop = 'prop_amb_beer_bottle',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["kubek"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Kubek", AnimationOptions =
   {
       Prop = 'prop_plastic_cup_02',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["donut"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Pączek", AnimationOptions =
   {
       Prop = 'prop_amb_donut',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["burger"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Burger", AnimationOptions =
   {
       Prop = 'prop_cs_burger_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["kanapka"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Kanapka", AnimationOptions =
   {
       Prop = 'prop_sandwich_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
       EmoteMoving = true,
   }},
   ["cola"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Cola", AnimationOptions =
   {
       Prop = 'prop_ecola_can',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czekolada"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Tabliczka czekolady", AnimationOptions =
   {
       Prop = 'prop_choc_ego',
       PropBone = 60309,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteMoving = true,
   }},
   ["wino"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Wino", AnimationOptions =
   {
       Prop = 'prop_drink_redwine',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["kieliszek"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Kieliszek", AnimationOptions =
   {
       Prop = 'prop_champ_flute',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["szampan"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Szampan", AnimationOptions =
   {
       Prop = 'prop_drink_champ',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["cygaro"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cygaro", AnimationOptions =
   {
       Prop = 'prop_cigar_02',
       PropBone = 47419,
       PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["cygaro2"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Cygaro 2", AnimationOptions =
   {
       Prop = 'prop_cigar_01',
       PropBone = 47419,
       PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["gitara"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Gitara", AnimationOptions =
   {
       Prop = 'prop_acc_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["gitara2"] = {"switch@trevor@guitar_beatdown", "001370_02_trvs_8_guitar_beatdown_idle_busker", "Gitara 2", AnimationOptions =
   {
       Prop = 'prop_acc_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.05, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["gitara3"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Gitara elektryczna", AnimationOptions =
   {
       Prop = 'prop_el_guitar_01',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["gitara4"] = {"amb@world_human_musician@guitar@male@idle_a", "idle_b", "Gitara elektryczna 2", AnimationOptions =
   {
       Prop = 'prop_el_guitar_03',
       PropBone = 24818,
       PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["ksiazka"] = {"cellphone@", "cellphone_text_read_base", "Książka", AnimationOptions =
   {
       Prop = 'prop_novel_01',
       PropBone = 6286,
       PropPlacement = {0.15, 0.03, -0.065, 0.0, 180.0, 90.0}, -- This positioning isnt too great, was to much of a hassle
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["bukiet"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Bukiet", AnimationOptions =
   {
       Prop = 'prop_snow_flower_02',
       PropBone = 24817,
       PropPlacement = {-0.29, 0.40, -0.02, -90.0, -90.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["mis"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Miś", AnimationOptions =
   {
       Prop = 'v_ilev_mr_rasberryclean',
       PropBone = 24817,
       PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["plecak"] = {"move_p_m_zero_rucksack", "idle", "Plecak", AnimationOptions =
   {
       Prop = 'p_michael_backpack_s',
       PropBone = 24818,
       PropPlacement = {0.07, -0.11, -0.05, 0.0, 90.0, 175.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["tablica"] = {"missfam4", "base", "Tablica do notowania", AnimationOptions =
   {
       Prop = 'p_amb_clipboard_01',
       PropBone = 36029,
       PropPlacement = {0.16, 0.08, 0.1, -130.0, -50.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["mapa"] = {"amb@world_human_tourist_map@male@base", "base", "Mapa", AnimationOptions =
   {
       Prop = 'prop_tourist_map_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteMoving = true,
       EmoteLoop = true
   }},
   ["zebranie"] = {"amb@world_human_bum_freeway@male@base", "base", "Żebranie", AnimationOptions =
   {
       Prop = 'prop_beggers_sign_03',
       PropBone = 58868,
       PropPlacement = {0.19, 0.18, 0.0, 5.0, 0.0, 40.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["rzucaniehajsem"] = {"anim@mp_player_intupperraining_cash", "idle_a", "Rzucanie pięniedzmi", AnimationOptions =
   {
       Prop = 'prop_anim_cash_pile_01',
       PropBone = 60309,
       PropPlacement = {0.0, 0.0, 0.0, 180.0, 0.0, 70.0},
       EmoteMoving = true,
       EmoteLoop = true,
       PtfxAsset = "scr_xs_celebration",
       PtfxName = "scr_xs_money_rain",
       PtfxPlacement = {0.0, 0.0, -0.09, -80.0, 0.0, 0.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['makeitrain'],
       PtfxWait = 500,
   }},
   ["kamera"] = {"amb@world_human_paparazzi@male@base", "base", "Kamera", AnimationOptions =
   {
       Prop = 'prop_pap_camera_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
       PtfxAsset = "scr_bike_business",
       PtfxName = "scr_bike_cfid_camera_flash",
       PtfxPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['camera'],
       PtfxWait = 200,
   }},
   ["szampan"] = {"anim@mp_player_intupperspray_champagne", "idle_a", "Szampan 2", AnimationOptions =
   {
       Prop = 'ba_prop_battle_champ_open',
       PropBone = 28422,
       PropPlacement = {0.0,0.0,0.0,0.0,0.0,0.0},
       EmoteMoving = true,
       EmoteLoop = true,
       PtfxAsset = "scr_ba_club",
       PtfxName = "scr_ba_club_champagne_spray",
       PtfxPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       PtfxInfo = Config.Languages[Config.MenuLanguage]['spraychamp'],
       PtfxWait = 500,
   }},
   ["joint"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Joint", AnimationOptions =
   {
       Prop = 'p_cs_joint_02',
       PropBone = 47419,
       PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["cig"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Papieros", AnimationOptions =
   {
       Prop = 'prop_amb_ciggy_01',
       PropBone = 47419,
       PropPlacement = {0.015, -0.009, 0.003, 55.0, 0.0, 110.0},
       EmoteMoving = true,
       EmoteDuration = 2600
   }},
   ["brief3"] = {"missheistdocksprep1hold_cellphone", "static", "Skrzynka 3", AnimationOptions =
   {
       Prop = "prop_ld_case_01",
       PropBone = 57005,
       PropPlacement = {0.10, 0.0, 0.0, 0.0, 280.0, 53.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tablet"] = {"amb@world_human_tourist_map@male@base", "base", "Tablet", AnimationOptions =
   {
       Prop = "prop_cs_tablet",
       PropBone = 28422,
       PropPlacement = {0.0, -0.03, 0.0, 20.0, -90.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["tablet2"] = {"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "Tablet 2", AnimationOptions =
   {
       Prop = "prop_cs_tablet",
       PropBone = 28422,
       PropPlacement = {-0.05, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["telefon2"] = {"cellphone@", "cellphone_call_listen_base", "Dzwonienie telfonem", AnimationOptions =
   {
       Prop = "prop_npc_phone_02",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["telefon"] = {"cellphone@", "cellphone_text_read_base", "Telefon", AnimationOptions =
   {
       Prop = "prop_npc_phone_02",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czyszczenie"] = {"timetable@floyd@clean_kitchen@base", "base", "Czyszczenie", AnimationOptions =
   {
       Prop = "prop_sponge_01",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, -0.01, 90.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["czyszczenie2"] = {"amb@world_human_maid_clean@", "base", "Cyszczenie 2", AnimationOptions =
   {
       Prop = "prop_sponge_01",
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, -0.01, 90.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
}