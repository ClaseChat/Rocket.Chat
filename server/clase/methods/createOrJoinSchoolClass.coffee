
createRoom = (name, user, childName) ->
	now = new Date()
	members = [user.username]

	RocketChat.callbacks.run 'beforeCreateChannel', user,
		t: 'c'
		name: name
		ts: now
		usernames: members
		u:
			_id: user._id
			username: user.username

	# create new room
	room = RocketChat.models.Rooms.createWithTypeNameUserAndUsernames 'c', name, user, members,
		ts: now

	RocketChat.callbacks.run 'beforeJoinRoom', user, room

	for username in members
		member = RocketChat.models.Users.findOneByUsername username
		if not member?
			continue

		extra = {
			clase:
				childName: childName
		}

		if username is user.username
			extra.ls = now
			extra.open = true

		RocketChat.models.Subscriptions.createWithRoomAndUser room, member, extra

	# set creator as channel moderator.	permission limited to channel by scoping to rid
	RocketChat.authz.addUserRoles(Meteor.userId(), ['owner'], room._id)

	Meteor.defer ->
		RocketChat.callbacks.run 'afterCreateChannel', user, room
		RocketChat.callbacks.run 'afterJoinRoom', user, room

	return {
		rid: room._id
	}

joinRoom = (room, rid, user, userId, childName) ->
	now = new Date()

	# Check if user is already in room
	subscription = RocketChat.models.Subscriptions.findOneByRoomIdAndUserId rid, user
	if subscription?
		return

	user = RocketChat.models.Users.findOneById userId

	RocketChat.callbacks.run 'beforeJoinRoom', user, room

	RocketChat.models.Rooms.addUsernameById rid, user.username

	RocketChat.models.Subscriptions.createWithRoomAndUser room, user,
		ts: now
		open: true
		alert: true
		unread: 1
		clase:
			childName: childName

	RocketChat.models.Messages.createUserJoinWithRoomIdAndUser rid, user,
		ts: now

	Meteor.defer ->
		RocketChat.callbacks.run 'afterJoinRoom', user, room

	return true

Meteor.methods
	createOrJoinSchoolClass: (childName, school, level, line, secret) ->

		#if not Meteor.userId()
		#	throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createChannel' }

		name = school + '_2016' + '_' + level + '_' + line

		if Clase.Secrets.Exists('parent_join_class/' + name)
			server_secret = Clase.Secrets.Get('parent_join_class/' + name)
			unless secret is server_secret
				throw new Meteor.Error 'wrong-secret', 'Secreto malo', { method: 'createOrJoinSchoolClass' }

		room = RocketChat.models.Rooms.findOneByName name

		# Room doesn't exist
		unless room?
			res = createRoom name, Meteor.user(), childName
			return {
				rid: res.rid
				name: name
			}

		# The room already exists
		joinRoom room, room._id, Meteor.user(), Meteor.userId(), childName
		return {
			rid: room._id
			name: name
		}

RocketChat.callbacks.add 'afterJoinRoom', (user, room) ->
	update =
		$set:
			'clase.defaultRoom': room._id
	RocketChat.models.Users.update user._id, update
