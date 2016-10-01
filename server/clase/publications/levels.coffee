Meteor.publish 'claseLevels', ->
	Clase.Levels.find()
