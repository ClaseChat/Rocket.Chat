Meteor.methods
	createOrJoinSchoolClassPasswordRequired: (school, level, line) ->
		room_name = school + '_2016' + '_' + level + '_' + line

		return Clase.Secrets.Exists('parent_join_class/' + room_name)
