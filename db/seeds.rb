adrien  = Risebox::Core::User.create first_name: 'Adrien', last_name: 'Thery', email: 'adrien@risebox.co', password: 'adrien42', admin: true
nicolas = Risebox::Core::User.create first_name: 'Nicolas', last_name: 'Nardone', email: 'nicolas@risebox.co', password: 'nicolas42', admin: true

menucourt = Risebox::Core::Device.create(name: 'menucourt', key: 'menucourt', model: 'Hapy', version: '1')
lab1      = Risebox::Core::Device.create(name: 'Electrolab One', key: 'lab1', model: 'Hapy', version: '2')

menucourt.users << adrien
menucourt.save!

lab1.users << adrien
lab1.users << nicolas
lab1.save!

adrien.update_attributes api_token: 'token1'
nicolas.update_attributes api_token: 'token2'

ph        = Risebox::Core::Metric.create name: "PH de l'eau",                   code: 'PH',    unit: nil,       display_order: 1
w_temp    = Risebox::Core::Metric.create name: "Température de l'eau",          code: 'WTEMP', unit: '°C',      display_order: 2
w_vol     = Risebox::Core::Metric.create name: "Volume d'eau",          code: 'WVOL', unit: 'l',      display_order: 2
a_temp    = Risebox::Core::Metric.create name: "Température de l'air",          code: 'ATEMP', unit: '°C',      display_order: 4
a_hum     = Risebox::Core::Metric.create name: "Humidité de l'air",             code: 'AHUM',  unit: '%',       display_order: 5
u_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du haut", code: 'UCYC',  unit: 'seconds', display_order: 6
l_cycle   = Risebox::Core::Metric.create name: "Temps de cycle du bac du bas",  code: 'LCYC',  unit: 'seconds', display_order: 7
no2       = Risebox::Core::Metric.create name: "Taux de nitrites (NO2)",        code: 'NO2',   unit: 'mg/l',    display_order: 8
nh4       = Risebox::Core::Metric.create name: "Taux d'ammonium (NH4)",         code: 'NH4',   unit: 'mg/l',    display_order: 9
no3       = Risebox::Core::Metric.create name: "Taux de nitrates (NO3)",        code: 'NO3',   unit: 'mg/l',    display_order: 10
gh        = Risebox::Core::Metric.create name: "Dureté totale (GH)",            code: 'GH',    unit: '°d',      display_order: 11
kh        = Risebox::Core::Metric.create name: "Dureté carbonnée (KH)",         code: 'KH',    unit: '°d',      display_order: 12

[lab1, menucourt].each do |box|
  box.metric_statuses.create(metric: ph,      limit_min: 6.5, limit_max: 7.8)
  box.metric_statuses.create(metric: w_temp,  limit_min: 18,  limit_max: 25)
  box.metric_statuses.create(metric: w_vol,   limit_min: 100,  limit_max: 200)
  box.metric_statuses.create(metric: a_temp,  limit_min: 18,  limit_max: 26)
  box.metric_statuses.create(metric: a_hum,   limit_min: 35,  limit_max: 70)
  box.metric_statuses.create(metric: u_cycle, limit_min: 600, limit_max: 900)
  box.metric_statuses.create(metric: l_cycle, limit_min: 540, limit_max: 840)
  box.metric_statuses.create(metric: no2,     limit_min: 0,   limit_max: 1)
  box.metric_statuses.create(metric: nh4,     limit_min: 0,   limit_max: 0.5)
  box.metric_statuses.create(metric: no3,     limit_min: 60,  limit_max: 130)
  box.metric_statuses.create(metric: gh,      limit_min: 4,   limit_max: 16)
  box.metric_statuses.create(metric: kh,      limit_min: 3,   limit_max: 10)
end