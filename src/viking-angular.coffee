angular.module('viking.angular', ["viking.angular.templates", "ngTagsInput"])

(->
	convertDateStringsToDates = (input) ->
		if typeof input != 'object'
			return input
		for key of input
			if !input.hasOwnProperty(key)
				continue
			value = input[key]
			match = undefined

			if typeof value == 'string'
				date = new Date(value)
				if date instanceof Date && !isNaN(date.valueOf())
					input[key] = date
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
