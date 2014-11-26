angular.module('viking.angular').factory '$viking', ->
	{
		populate: (portletId, scope) ->
			_.assign scope, VK.getPortletData(portletId)
	}