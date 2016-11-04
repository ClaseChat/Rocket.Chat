Meteor.publish 'UsersSubscriptions', ->
	unless this.userId
		return this.ready()

	return RocketChat.models.Subscriptions.find {},
		fields:
			name: 1
			rid: 1
			clase: 1
			u: 1
