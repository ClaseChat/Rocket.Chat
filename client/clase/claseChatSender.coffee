Template.claseChatSender.onCreated ->
	Meteor.subscribe 'claseSchools'
	instance = this
	instance.error = new ReactiveVar []
	instance.success = new ReactiveVar false
	instance.clearForm = ->
		instance.error.set([])
		instance.success.set(false)

Template.claseChatSender.onRendered ->
	$('#initial-page-loading').remove()

Template.claseChatSender.helpers
	schools: ->
		return Clase.Schools.find()
	error: ->
		return Template.instance().error.get()
	success: ->
		return Template.instance().success.get()

Template.claseChatSender.events
	'click .clase-ampa-sender': (e, instance) ->
		school = instance.find('#clase-school').value
		secret = instance.find('#clase-secret').value
		message = instance.find('#clase-message').value

		Meteor.call 'claseClaseChatSendMessage', school, secret, message, (err, result) ->
			console.log err, result
			if err
				console.log err
				if err.error is 'wrong-secret'
					console.log 'wrong-secret'
					instance.error.set({ wrongSecret: true })
					return
			else
				instance.error.set([])
				instance.success.set(true)
