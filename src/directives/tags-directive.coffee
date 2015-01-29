angular.module('viking.angular').directive 'vkTags', ['$timeout', '$viking', '$http', ($timeout, $viking, $http)->
	{
		restrict: 'AE'
		replace: false
		scope:
			ngModel: '='
			source: '='
		templateUrl: "templates/tags-template.html" 
		link: (scope, element) ->
			scope.loadTags = scope.source || (query) ->
				$http.post($viking.route(".getTags"), {query: query})
	}
]