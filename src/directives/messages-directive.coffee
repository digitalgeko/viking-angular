angular.module('viking.angular').directive 'vkMessages', ['$timeout', ($timeout)->
	{
		restrict: 'AE'
		replace: false
		scope:
			vkChannel: '@'
		templateUrl: "templates/messages-template.html" 
		link: (scope, element) ->
			scope.vkChannel = scope.vkChannel || "VK_MESSAGES_DEFAULT_CHANNEL"
			scope.messages = []

			scope.removeMessage = (message) ->
				scope.messages.splice scope.messages.indexOf(message), 1

			scope.$on scope.vkChannel, (e, message) ->
				scope.messages.push message
				$timeout ->
					scope.removeMessage message
					scope.$apply()
				, 10000
				scope.$apply()
	}
]