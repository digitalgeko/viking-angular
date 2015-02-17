angular.module('viking.angular').directive 'vkErrors', ['$timeout', ($timeout)->
	{
		restrict: 'EA'
		replace: true
		scope:
			vkErrorsKey: '@'
			vkErrors: '='
		templateUrl: "templates/errors-template.html" 
		link: (scope, element) ->

	}
]