Template.joinSchoolClassRoom.helpers
	schools: ->
		return Clase.Schools.find()

	passwordMode: ->
		return 'hidden' unless Template.instance().passwordMode.get() is true

	normalMode: ->
		return 'hidden' unless Template.instance().passwordMode.get() is false

	passwordRequired: ->
		return 'required' unless Template.instance().passwordMode.get() is false

	error: ->
		return Template.instance().error.get()

Template.joinSchoolClassRoom.events
	'click header': (e, instance) ->
		SideNav.closeFlex ->
			instance.clearForm()

	'click .cancel-channel': (e, instance) ->
		SideNav.closeFlex ->
			instance.clearForm()

	'mouseenter header': ->
		SideNav.overArrow()

	'mouseleave header': ->
		SideNav.leaveArrow()

	'click footer .all': ->
		SideNav.setFlex "listChannelsFlex"

	'keydown input[type="text"]': (e, instance) ->
		Template.instance().error.set([])

	'keyup #channel-name': (e, instance) ->
		if e.keyCode is 13
			instance.$('#channel-members').focus()

	'keydown #channel-members': (e, instance) ->
		if $(e.currentTarget).val() is '' and e.keyCode is 13
			instance.$('.save-channel').click()

	'click .clase-subscribe-class': (e, instance) ->
		if (instance.passwordMode.get() is true)
			instance.subscribeClass()
			return
		instance.passwordRequired (err, result) ->
			console.log(result)
			if result
				instance.passwordMode.set true
			else
				instance.subscribeClass()

Template.joinSchoolClassRoom.onCreated ->
	Meteor.subscribe 'claseSchools'
	instance = this
	instance.error = new ReactiveVar []
	instance.roomName = new ReactiveVar ''
	instance.passwordMode = new ReactiveVar false

	instance.clearForm = ->
		instance.error.set([])
		instance.roomName.set('')
		instance.passwordMode.set false

		instance.find('#clase-child-name').value = ''
		instance.find('#clase-school').selectedIndex = 0
		instance.find('#clase-level').selectedIndex = 0
		instance.find('#clase-line').selectedIndex = 0

	instance.passwordRequired = (cb)->
		school = instance.find('#clase-school').value
		level = instance.find('#clase-level').value
		line = instance.find('#clase-line').value

		return Meteor.call 'createOrJoinSchoolClassPasswordRequired', school, level, line, cb

	instance.subscribeClass = ->
		err = SideNav.validate()
		child_name = instance.find('#clase-child-name').value.toLowerCase().trim()
		school = instance.find('#clase-school').value
		level = instance.find('#clase-level').value
		line = instance.find('#clase-line').value
		password = instance.find('#clase-class-password').value

		instance.roomName.set child_name
		if not err
			Meteor.call 'createOrJoinSchoolClass', child_name, school, level, line, password, (err, result) ->
				if err
					console.log err
					if err.error is 'error-invalid-name'
						instance.error.set({ invalid: true })
						return
					if err.error is 'error-duplicate-channel-name'
						instance.error.set({ duplicate: true })
						return
					if err.error is 'error-archived-duplicate-name'
						instance.error.set({ archivedduplicate: true })
						return
					if err.error is 'wrong-secret'
						instance.error.set({ wrongSecret: true })
						return
					else
						return handleError(err)

				SideNav.closeFlex ->
					instance.clearForm()

				instance.clearForm()

				FlowRouter.go 'channel', { name: result.name }
		else
			console.log err
			instance.error.set({ fields: err })
