Meteor.startup ->
	Meteor.defer ->
		if not RocketChat.models.Users.findOneById('ampa')?
			RocketChat.models.Users.create
				_id: 'ampa'
				name: "AMPA"
				username: 'ampa'
				status: "online"
				statusDefault: "online"
				utcOffset: 0
				active: true
				type: 'bot'

			RocketChat.authz.addUserRoles('ampa', 'bot')
