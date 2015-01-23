angular.module('viking.angular').directive 'vkMessages', ['$timeout', ($timeout)->
	{
		restrict: 'AE'
		replace: false
		scope:
			vkChannel: '@'
		templateUrl: "templates/messages-template.html" 
		link: (scope, element) ->
			scope.vkChannel = scope.vkChannel || "DEFAULT"
			scope.messages = []

			scope.removeMessage = (message) ->
				scope.messages.splice scope.messages.indexOf(message), 1

			amplify.subscribe scope.vkChannel, (message) ->
				scope.messages.push message
				$timeout ->
					scope.removeMessage message
					scope.$apply()
				, 10000
				scope.$apply()
	}
]