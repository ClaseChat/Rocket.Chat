Meteor.startup ->
	Meteor.defer ->
		#if Clase.Levels.find().count() isnt 0
		#	return
		console.log 'loading Clase levels...'
		levels = [
			{_id: '1infantil', label: 'Infantil de 3 años'}
			{_id: '2infantil', label: 'Infantil de 4 años'}
			{_id: '3infantil', label: 'Infantil de 5 años'}
			{_id: '1primaria', label: '1º primaria'}
			{_id: '2primaria', label: '2º primaria'}
			{_id: '3primaria', label: '3º primaria'}
			{_id: '4primaria', label: '4º primaria'}
			{_id: '5primaria', label: '5º primaria'}
			{_id: '6primaria', label: '6º primaria'}
			{_id: '1secundaria', label: '1º secundaria'}
			{_id: '2secundaria', label: '2º secundaria'}
			{_id: '3secundaria', label: '3º secundaria'}
			{_id: '4secundaria', label: '4º secundaria'}
			{_id: '1bachillerato', label: '1º bachillerato'}
			{_id: '2bachillerato', label: '2º bachillerato'}
			{_id: '1infantil_agrupado', label: 'Infantil agrupado 1'}
			{_id: '2infantil_agrupado', label: 'Infantil agrupado 2'}
			{_id: '3infantil_agrupado', label: 'Infantil agrupado 3'}
			{_id: '4infantil_agrupado', label: 'Infantil agrupado 4'}
			{_id: '1primaria_agrupada', label: 'Primaria agrupada 1'}
			{_id: '2primaria_agrupada', label: 'Primaria agrupada 2'}
			{_id: '3primaria_agrupada', label: 'Primaria agrupada 3'}
			{_id: '4primaria_agrupada', label: 'Primaria agrupada 4'}
			{_id: '5primaria_agrupada', label: 'Primaria agrupada 5'}
			{_id: '6primaria_agrupada', label: 'Primaria agrupada 6'}
		]

		levels.map (level) ->
			Clase.Levels.upsert(level._id, level)

		console.log 'levels Clase loaded.'
