@Clase = @Clase || {}
@Clase.Secrets = new Meteor.Collection("clase_secrets")

@Clase.Secrets.Get = (query) ->
	secret = Clase.Secrets.findOne(query)
	unless secret
		return 'peppapig'
	else
		return secret.secret

@Clase.Secrets.Exists = (query) ->
	return Clase.Secrets.findOne(query) != null
