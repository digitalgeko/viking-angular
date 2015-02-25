angular.module('viking.angular').directive 'vkPagination', ->
	{
		restrict: 'AE'
		scope:
			vkPageChange: "&"
			vkPagination: "="
		templateUrl: "templates/pagination-template.html" 
		link: (scope, element) ->
			scope.pages = []
			scope.setPageCount = (pageCount) ->
				scope.pageCount = pageCount
				scope.pages = _.range(1, pageCount+1)
				if !scope.currentPage
					scope.currentPage = 1
				else if scope.currentPage >= scope.pageCount
					scope.currentPage = scope.pageCount

			scope.$watchCollection 'vkPagination', (paginationInfo) ->
				console.log paginationInfo
				if paginationInfo
					if paginationInfo.pageCount
						scope.setPageCount paginationInfo.pageCount

					if paginationInfo.page
						scope.currentPage = paginationInfo.page
					

			scope.setCurrentPage = (page) ->
				if page < 1
					page = 1
				if page >= scope.pageCount
					page = scope.pageCount

				if scope.currentPage != page
					scope.currentPage = page
					scope.vkPageChange {$page: page}

	}