@Clase = @Clase || {}
@Clase.Secrets = new Meteor.Collection("clase_secrets")

@Clase.Secrets.Get = (id) ->
	query = { _id: id }
	secret = Clase.Secrets.findOne(query)
	unless secret
		return 'peppapig'
	else
		return secret.secret

@Clase.Secrets.Exists = (id) ->
	query = { _id: id }
	secret = Clase.Secrets.findOne(query)
	return secret?
