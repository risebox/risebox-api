adrien  = Risebox::Core::User.create first_name: 'Adrien', last_name: 'Thery', email: 'adrien@risebox.co'
nicolas = Risebox::Core::User.create first_name: 'Nicolas', last_name: 'Nardone', email: 'nicolas@risebox.co'

menucourt = adrien.devices.create(name: 'menucourt', key: 'menucourt', token: 'token1', model: 'Hapy', version: '1')
lab1      = nicolas.devices.create(name: 'lab1', key: 'lab1', token: 'token2', model: 'Hapy', version: '2')

ph        = Risebox::Core::Metric.create name: "PH de l'eau",                   code: 'PH',    unit: nil
w_temp    = Risebox::Core::Metric.create name: "Température de l'eau",          code: 'WTEMP', unit: '°C'
a_temp    = Risebox::Core::Metric.create name: "Température de l'air",          code: 'ATEMP', unit: '°C'
a_hum     = Risebox::Core::Metric.create name: "Humidité de l'air",             code: 'AHUM',  unit: '%'
u_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du haut", code: 'UCYC',  unit: 'seconds'
l_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du bas",  code: 'LCYC',  unit: 'seconds'
no2       = Risebox::Core::Metric.create name: "Taux de nitrites (NO2)",        code: 'NO2',   unit: 'mg/l'
nh4       = Risebox::Core::Metric.create name: "Taux d'ammonium (NH4)",         code: 'NH4',   unit: 'mg/l'
no3       = Risebox::Core::Metric.create name: "Taux de nitrates (NO3)",        code: 'NO3',   unit: 'mg/l'
