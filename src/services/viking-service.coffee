angular.module('viking.angular').factory '$viking', ->

	self = {}

	self.init = (portletId, scope) ->
		self.portletId = portletId
		self.scope = scope
		_.assign scope, VK.getPortletData(portletId)		

	self.ready = (callback) -> AUI().ready 'liferay-portlet-url', callback
	self.route = (route, params = {}, routeType = "resource") ->

		liferayURL = switch
			when routeType == "render" then Liferay.PortletURL.createRenderURL()
			when routeType == "action" then Liferay.PortletURL.createActionURL()
			when routeType == "permission" then Liferay.PortletURL.createPermissionURL()
			else Liferay.PortletURL.createResourceURL()

		liferayURL.setPortletId self.portletId
		
		for value, i in params
			liferayURL.params[i] = value

		routeParts = route.split(".")
		liferayURL.params["VIKING_controller"] = routeParts[0] || self.scope.VIKING_FRAMEWORK_PARAMS.controllerName
		liferayURL.params["VIKING_action"] = routeParts[1]

		liferayURL.toString()

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
