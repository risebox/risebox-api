adrien  = Risebox::Core::User.create first_name: 'Adrien', last_name: 'Thery', email: 'adrien@risebox.co'
nicolas = Risebox::Core::User.create first_name: 'Nicolas', last_name: 'Nardone', email: 'nicolas@risebox.co'

menucourt = adrien.devices.create(name: 'menucourt', key: 'menucourt', model: 'Hapy', version: '1')
lab1      = nicolas.devices.create(name: 'Electrolab One', key: 'lab1', model: 'Hapy', version: '2')

menucourt.update_attributes token: 'token1'
lab1.update_attributes token: 'token2'

ph        = Risebox::Core::Metric.create name: "PH de l'eau",                   code: 'PH',    unit: nil,       display_order: 1
w_temp    = Risebox::Core::Metric.create name: "Température de l'eau",          code: 'WTEMP', unit: '°C',      display_order: 2
a_temp    = Risebox::Core::Metric.create name: "Température de l'air",          code: 'ATEMP', unit: '°C',      display_order: 3
a_hum     = Risebox::Core::Metric.create name: "Humidité de l'air",             code: 'AHUM',  unit: '%',       display_order: 4
u_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du haut", code: 'UCYC',  unit: 'seconds', display_order: 5
l_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du bas",  code: 'LCYC',  unit: 'seconds', display_order: 6
no2       = Risebox::Core::Metric.create name: "Taux de nitrites (NO2)",        code: 'NO2',   unit: 'mg/l',    display_order: 7
nh4       = Risebox::Core::Metric.create name: "Taux d'ammonium (NH4)",         code: 'NH4',   unit: 'mg/l',    display_order: 8
no3       = Risebox::Core::Metric.create name: "Taux de nitrates (NO3)",        code: 'NO3',   unit: 'mg/l',    display_order: 9

[lab1, menucourt].each do |box|
  lab1.metric_statuses.create(metric: ph,      limit_min: 6.5, limit_max: 7.8)
  lab1.metric_statuses.create(metric: w_temp,  limit_min: 18,  limit_max: 25)
  lab1.metric_statuses.create(metric: a_temp,  limit_min: 18,  limit_max: 26)
  lab1.metric_statuses.create(metric: a_hum,   limit_min: 35,  limit_max: 70)
  lab1.metric_statuses.create(metric: u_cycle, limit_min: 600, limit_max: 900)
  lab1.metric_statuses.create(metric: l_cycle, limit_min: 540, limit_max: 840)
  lab1.metric_statuses.create(metric: no2,     limit_min: 0,   limit_max: 1)
  lab1.metric_statuses.create(metric: nh4,     limit_min: 0,   limit_max: 0.5)
  lab1.metric_statuses.create(metric: no3,     limit_min: 60,  limit_max: 130)
end