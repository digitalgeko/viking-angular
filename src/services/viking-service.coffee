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

	angular.module('viking.angular').factory '$viking', [ '$interval', '$q', ($interval, $q) ->

		self = {}

		self.init = (portletId, scope) ->
			self.portletId = portletId
			self.scope = scope
			portletData = VK.getPortletData(portletId)
			convertDateStringsToDates portletData
			_.assign scope, portletData

		# self.ready = (callback) ->
			
		# 	executeCallback = _.once ->
		# 		$interval.cancel readyInterval
		# 		callback()

		# 	readyInterval = $interval ->
		# 		if Liferay.PortletURL
		# 			executeCallback()		
		# 	, 1000
			
		# 	AUI().ready 'liferay-portlet-url', executeCallback

		self.route = (route, params = {}, options = {}) ->
			$q (resolve, reject) ->
				AUI().use 'liferay-portlet-url', (A) ->
					navigationURL;
					portletURL = Liferay.PortletURL.createRenderURL();

					liferayURL = switch
						when options.routeType == "render" then Liferay.PortletURL.createRenderURL()
						when options.routeType == "action" then Liferay.PortletURL.createActionURL()
						when options.routeType == "permission" then Liferay.PortletURL.createPermissionURL()
						else Liferay.PortletURL.createResourceURL()

					liferayURL.setPortletId self.portletId
					
					for key, value of params
						liferayURL.params[key] = value.toString()

					for key, value of options.reservedParams
						liferayURL.reservedParams[key] = value.toString()

					routeParts = route.split(".")
					if routeParts[0]
						liferayURL.params["VIKING_controller"] = "controllers."+routeParts[0]
					else
						liferayURL.params["VIKING_controller"] = self.scope.VIKING_FRAMEWORK_PARAMS.controllerName
					liferayURL.params["VIKING_action"] = routeParts[1]

					resolve liferayURL

		# Messages
		self.showMessage = (type, channel, text) ->
			message = 
				type: type
				text: text

			_.defer ->
				self.scope.$broadcast channel, message

		capitalize = (word) -> 
			word.charAt(0).toUpperCase() + word.slice 1
		
		parseOptions = (options) ->
			if typeof options == 'string'
				{ text: options, channel: "VK_MESSAGES_DEFAULT_CHANNEL" }
			else
				options

		_.each ['success', 'error', 'info'], (type) ->
			self['show'+capitalize(type)] = (options) ->
				{channel, text} = parseOptions(options)
				self.showMessage(type, channel, text)

		return self
	]

	angular.module('viking.angular').config [ '$httpProvider', ($httpProvider) ->
		$httpProvider.defaults.transformResponse.push (responseData) ->
			convertDateStringsToDates responseData
			responseData
		return
	]	
)()
