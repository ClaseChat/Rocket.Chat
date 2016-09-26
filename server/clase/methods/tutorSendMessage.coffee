Meteor.methods
	claseTutorSendMessage: (school, level, line, secret, message) ->
		room_name = school + '_2016' + '_' + level + '_' + line

		server_secret = Clase.Secrets.Get({_id: 'tutor_send_class/' + room_name})

		unless secret is server_secret
			throw new Meteor.Error 'wrong-secret', 'Secreto malo', { method: 'claseTutorSendMessage' }

		tutor = RocketChat.models.Users.findOneById('tutor')

		room = RocketChat.models.Rooms.findOneByName room_name
		unless room
			now = new Date()
			room = RocketChat.models.Rooms.createWithTypeNameUserAndUsernames 'c', room_name, tutor, [],
				ts: now

		tutor = RocketChat.models.Users.findOneById('tutor')

		message = RocketChat.models.Messages.createWithTypeRoomIdMessageAndUser 'tutor-message', room._id, message, tutor, {}

		RocketChat.callbacks.run 'afterSaveMessage', message, room

		message.pinned = true
		RocketChat.models.Messages.setPinnedByIdAndUserId message._id, Date.now, true

		RocketChat.callbacks.run 'afterPinMessage', message, room
