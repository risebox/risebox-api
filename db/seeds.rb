adrien  = Risebox::Core::User.create first_name: 'Adrien', last_name: 'Thery', email: 'adrien@risebox.co'
nicolas = Risebox::Core::User.create first_name: 'Nicolas', last_name: 'Nardone', email: 'nicolas@risebox.co'

menucourt = adrien.devices.create(name: 'menucourt', key: 'menucourt', token: 'token1', model: 'Hapy', version: '1')
lab1      = nicolas.devices.create(name: 'lab1', key: 'lab1', token: 'token2', model: 'Hapy', version: '2')

ph        = Risebox::Core::Metric.create name: "PH de l'eau",                   code: 'PH',    unit: nil,       display_order: 1
w_temp    = Risebox::Core::Metric.create name: "Température de l'eau",          code: 'WTEMP', unit: '°C',      display_order: 2
a_temp    = Risebox::Core::Metric.create name: "Température de l'air",          code: 'ATEMP', unit: '°C',      display_order: 3
a_hum     = Risebox::Core::Metric.create name: "Humidité de l'air",             code: 'AHUM',  unit: '%',       display_order: 4
u_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du haut", code: 'UCYC',  unit: 'seconds', display_order: 5
l_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du bas",  code: 'LCYC',  unit: 'seconds', display_order: 6
no2       = Risebox::Core::Metric.create name: "Taux de nitrites (NO2)",        code: 'NO2',   unit: 'mg/l',    display_order: 7
nh4       = Risebox::Core::Metric.create name: "Taux d'ammonium (NH4)",         code: 'NH4',   unit: 'mg/l',    display_order: 8
no3       = Risebox::Core::Metric.create name: "Taux de nitrates (NO3)",        code: 'NO3',   unit: 'mg/l',    display_order: 9
