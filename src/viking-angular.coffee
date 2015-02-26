angular.module('viking.angular', ["viking.angular.templates", "ngTagsInput"])

(->
	regexISO8601DateFormat =  /(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.\d+)|(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d)|(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d)/
	convertDateStringsToDates = (input) ->
		if typeof input != 'object'
			return input
		for key of input
			if !input.hasOwnProperty(key)
				continue
			value = input[key]
			match = undefined

			if typeof value == 'string'
				if value.match regexISO8601DateFormat
					input[key] = new Date(value)
			else if typeof value == 'object'
				convertDateStringsToDates value
		return


	angular.module('viking.angular').config [ '$httpProvider', ($httpProvider) ->
		$httpProvider.defaults.transformResponse.push (responseData) ->
			convertDateStringsToDates responseData
			responseData
		return
	]
)()
