sendToRoom = (room_name, message_type, message_text, user) ->
	room = RocketChat.models.Rooms.findOneByName room_name
	unless room
		now = new Date()
		room = RocketChat.models.Rooms.createWithTypeNameUserAndUsernames 'c', room_name, user, [],
			ts: now

	# message_type = 'ampa-message'
	message = RocketChat.models.Messages.createWithTypeRoomIdMessageAndUser message_type, room._id, message_text, user, {}
	RocketChat.callbacks.run 'afterSaveMessage', message, room

	message.pinned = true
	RocketChat.models.Messages.setPinnedByIdAndUserId message._id, Date.now, true
	RocketChat.callbacks.run 'afterPinMessage', message, room

sendToSchool = (school, user, message_type, message_text) ->
	Clase.Levels.find().map (level) ->
		['A', 'B', 'C', 'D', 'E', 'F'].map (line) ->
			sendToRoom school + '_2016' + '_' + level._id + '_' + line, message_type, message_text, user

Meteor.methods
	claseAMPASendMessage: (school, secret, message_text) ->
		server_secret = Clase.Secrets.Get('ampa_send_school/' + school)
		unless secret is server_secret
			throw new Meteor.Error 'wrong-secret', 'Secreto malo', { method: 'claseAMPASendMessage' }

		ampa = RocketChat.models.Users.findOneById('ampa')

		sendToSchool school, ampa, 'ampa-message', message_text

		return true

Meteor.methods
	claseClaseChatSendMessage: (school, secret, message_text) ->
		server_secret = Clase.Secrets.Get('clasechat_send_school/' + school)
		unless secret is server_secret
			throw new Meteor.Error 'wrong-secret', 'Secreto malo', { method: 'claseClaseChatSendMessage' }

		claseChat = RocketChat.models.Users.findOneById('claseChat')

		sendToSchool school, claseChat, 'clasechat-message', message_text

		return true
