Meteor.startup ->
	Meteor.defer ->
		if not RocketChat.models.Users.findOneById('claseChat')?
			RocketChat.models.Users.create
				_id: 'claseChat'
				name: "ClaseChat"
				username: 'claseChat'
				status: "online"
				statusDefault: "online"
				utcOffset: 0
				active: true
				type: 'bot'

			RocketChat.authz.addUserRoles('claseChat', 'bot')
