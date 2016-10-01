Meteor.methods
	claseAMPASendMessage: (school, secret, message_text) ->
		server_secret = Clase.Secrets.Get('ampa_send_school/' + school)
		unless secret is server_secret
			throw new Meteor.Error 'wrong-secret', 'Secreto malo', { method: 'claseAMPASendMessage' }

		ampa = RocketChat.models.Users.findOneById('ampa')

		sendToRoom = (room_name) ->
			room = RocketChat.models.Rooms.findOneByName room_name
			unless room
				now = new Date()
				room = RocketChat.models.Rooms.createWithTypeNameUserAndUsernames 'c', room_name, ampa, [],
					ts: now

			message = RocketChat.models.Messages.createWithTypeRoomIdMessageAndUser 'ampa-message', room._id, message_text, ampa, {}
			RocketChat.callbacks.run 'afterSaveMessage', message, room

			message.pinned = true
			RocketChat.models.Messages.setPinnedByIdAndUserId message._id, Date.now, true
			RocketChat.callbacks.run 'afterPinMessage', message, room

		Clase.Levels.find().map (level) ->
			['A', 'B', 'C', 'D', 'E', 'F'].map (line) ->
				sendToRoom school + '_2016' + '_' + level._id + '_' + line
