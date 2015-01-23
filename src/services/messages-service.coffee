angular.module('viking.angular').factory '$vkMessages', ['$timeout', ($timeout) ->
	self = {}
	self.showMessage = (type, channel, text) ->
		message = 
			type: type
			text: text

		_.defer ->
			amplify.publish channel, message

	parseOptions = (options) ->
		if typeof options == 'string'
			{ text: options, channel: "DEFAULT" }
		else
			options

	_.each ['success', 'error', 'info'], (type) ->
		self[type] = (options) ->
			{channel, text} = parseOptions(options)
			self.showMessage(type, channel, text)

	return self
]