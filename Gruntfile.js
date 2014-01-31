'use strict';

module.exports = function (grunt) {
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.initConfig({
		coffee: {
			compile: {
				files: {
					'build/chz.js': 'src/chz.coffee',
					'build/calendar.js': 'src/calendar.coffee',
					'build/popup.js': 'src/popup.coffee'
				}
			}
		},
		less: {
			dist: {
				files: [
					{
						expand: true,
						cwd: 'styles',
						src: ['*.less'],
						dest: 'build',
						ext: '.css'
					}
				]
			}
		},
		watch: {
			options: {
				nospawn: true
			},
			coffee: {
				files: ['src/**/*.coffee'],
				tasks: ['coffee'],
				options: {
					events: ['changed', 'added'],
					nospawn: true
				}
			},
			less: {
				files: ['styles/**/*.less'],
				tasks: ['less'],
				options: {
					events: ['changed', 'added'],
					nospawn: true
				}
			}
		}
	})
	grunt.registerTask('default');
};
