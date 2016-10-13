Template.highlightedSelector.helpers
	highlightedOnly: ->
		if Meteor.user().clase?.highlightedOnly
			return 'icon-toggle-on favorite-room'
		return 'icon-toggle-off'
	textAllSelected: ->
		if Meteor.user().clase?.highlightedOnly
			return ''
		return 'text-mode-selected'
	textHighlightedOnlySelected: ->
		if Meteor.user().clase?.highlightedOnly
			return 'text-mode-selected'
		return ''

Template.highlightedSelector.events
	'click .toggle-highlighted-only': (event) ->
		event.stopPropagation()
		event.preventDefault()
		RocketChat.callbacks.run 'ClaseToggleHighlightedOnlyClicked', Meteor.user().clase?.highlightedOnly
		Meteor.call 'claseHighlightedOnlyToggle'

	'click #clase_all_button': (event) ->
		event.stopPropagation()
		event.preventDefault()
		RocketChat.callbacks.run 'ClaseAllMessagesClicked', Meteor.user().clase?.highlightedOnly
		if Meteor.user().clase?.highlightedOnly
			Meteor.call 'claseHighlightedOnlyToggle'

	'click #clase_highlighted_only_button': (event) ->
		event.stopPropagation()
		event.preventDefault()
		RocketChat.callbacks.run 'ClaseHighlightedOnlyClicked', Meteor.user().clase?.highlightedOnly
		if not Meteor.user().clase?.highlightedOnly
			Meteor.call 'claseHighlightedOnlyToggle'
