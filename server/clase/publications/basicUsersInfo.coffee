Meteor.publish 'basicUsersInfo', ->
	unless @userId
		return @ready()

	fields =
		name: 1
		username: 1
		status: 1
		utcOffset: 1
		type: 1

	options =
		fields: fields

	return RocketChat.models.Users.find {}, options
