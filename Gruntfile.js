module.exports = function(grunt) {

	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-html2js');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.initConfig({
		coffee: {
			compileBare: {
				options: {
					bare: true
				},
				files: {
					'dist/viking-angular.js': ['src/viking-angular.coffee', 'src/**/*.coffee']
				}
			}
		},
		html2js: {
			options: {
				base: '.',
				module: "viking.angular.templates",
				htmlmin: {
					collapseBooleanAttributes: true,
					collapseWhitespace: true,
					removeAttributeQuotes: true,
					removeComments: true,
					removeEmptyAttributes: true,
					removeRedundantAttributes: true,
					removeScriptTypeAttributes: true,
					removeStyleLinkTypeAttributes: true
				}
			},
			
			main: {
				src: ['templates/**/*.html'],
				dest: 'dist/viking-angular-templates.js'
			}
		},
		uglify: {
			options: {
				mangle: false
			},
			viking: {
				files: {
					'dist/viking-angular.min.js': ['dist/viking-angular.js'],
					'dist/viking-angular-templates.min.js': ['dist/viking-angular-templates.js']
				}
			}
		},
		
		clean: ["dist"],
		
		watch: {
			scripts: {
				files: ['src/**/*.coffee', 'templates/**/*.html'],
				tasks: ['build'],
				options: {
					spawn: false,
				},
			},
		}
	});

	grunt.registerTask('build', ['coffee', 'html2js', 'uglify']);

	return grunt;
};
