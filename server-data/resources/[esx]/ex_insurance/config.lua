Config                            = {}

Config.DrawDistance               = 100.0 -- nie tykać

Config.Marker                     = { type = 1, x = 1.0, y = 1.0, z = 0.3, r = 0, g = 0, b = 255, a = 100, rotate = false } -- nie tykać

Config.BasicPrice                 = 50000 -- podstawowa cena

Config.Weeks                      = 4 -- ile tygodni ma się wyświetlać

Config.Discount                   = 5 -- procent

Config.PriceForDay                = 5 -- jaka ma byc oplata za jeden dzien ubezpieczenia. Np. BasicPrice/7*PriceForDay

Config.MaxWeekForward             = 4 -- na ile tygodni można kupić maksymalnie ubezpieczenie

Config.SendToBank                 = false -- czy pieniądze mają iść do banku ems

Config.SendToBankName             = 'society_ambulance' -- konto w tabelii 'addon_account_data' na ktore mają iść pieniądze z ubezpieczenia
