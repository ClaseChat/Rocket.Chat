Template.joinSchoolClassRoom.helpers
	schools: ->
		return Clase.Schools.find()

	error: ->
		return Template.instance().error.get()

Template.joinSchoolClassRoom.events
	'autocompleteselect #channel-members': (event, instance, doc) ->
		instance.selectedUsers.set instance.selectedUsers.get().concat doc.username

		instance.selectedUserNames[doc.username] = doc.name

		event.currentTarget.value = ''
		event.currentTarget.focus()

	'click .remove-room-member': (e, instance) ->
		self = @

		users = Template.instance().selectedUsers.get()
		users = _.reject Template.instance().selectedUsers.get(), (_id) ->
			return _id is self.valueOf()

		Template.instance().selectedUsers.set(users)

		$('#channel-members').focus()

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
		err = SideNav.validate()
		child_name = instance.find('#clase-child-name').value.toLowerCase().trim()
		school = instance.find('#clase-school').value
		level = instance.find('#clase-level').value
		line = instance.find('#clase-line').value

		# instance.roomName.set name
		if not err
			Meteor.call 'createOrJoinSchoolClass', child_name, school, level, line, (err, result) ->
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
					else
						return handleError(err)

				SideNav.closeFlex ->
					instance.clearForm()

				instance.clearForm()

				FlowRouter.go 'channel', { name: result.name }
		else
			console.log err
			instance.error.set({ fields: err })

Template.joinSchoolClassRoom.onCreated ->
	Meteor.subscribe 'claseSchools'
	instance = this
	instance.selectedUsers = new ReactiveVar []
	instance.selectedUserNames = {}
	instance.error = new ReactiveVar []
	instance.roomName = new ReactiveVar ''

	instance.clearForm = ->
		instance.error.set([])
		instance.roomName.set('')
		instance.selectedUsers.set([])
		instance.find('#clase-child-name').value = ''
		instance.find('#clase-school').selectedIndex = 0
		instance.find('#clase-level').selectedIndex = 0
		instance.find('#clase-line').selectedIndex = 0
