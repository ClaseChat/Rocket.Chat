Template.ampaSender.onCreated ->
	Meteor.subscribe 'claseSchools'
	instance = this
	instance.error = new ReactiveVar []
	instance.success = new ReactiveVar false
	instance.clearForm = ->
		instance.error.set([])
		instance.success.set(false)

Template.ampaSender.onRendered ->
	$('#initial-page-loading').remove()

Template.ampaSender.helpers
	schools: ->
		return Clase.Schools.find()
	error: ->
		return Template.instance().error.get()
	success: ->
		return Template.instance().success.get()

Template.ampaSender.events
	'click .clase-ampa-sender': (e, instance) ->
		school = instance.find('#clase-school').value
		secret = instance.find('#clase-secret').value
		message = instance.find('#clase-message').value

		Meteor.call 'claseAMPASendMessage', school, secret, message, (err, result) ->
			if err
				console.log err
				if err.error is 'wrong-secret'
					console.log 'wrong-secret'
					instance.error.set({ wrongSecret: true })
					return
			else
				instance.error.set([])
