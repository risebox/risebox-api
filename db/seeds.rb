adrien  = Risebox::Core::User.create first_name: 'Adrien', last_name: 'Thery', email: 'adrien@risebox.co'
nicolas = Risebox::Core::User.create first_name: 'Nicolas', last_name: 'Nardone', email: 'nicolas@risebox.co'

menucourt = adrien.devices.create(name: 'menucourt', key: 'menucourt', token: 'token1', model: 'Hapy', version: '1')
lab1 = nicolas.devices.create(name: 'lab1', key: 'lab1', token: 'token2', model: 'Hapy', version: '2')