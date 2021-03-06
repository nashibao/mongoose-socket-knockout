var proc = require('child_process');
var growl = require('growl');


module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
        glob_to_multiple: {
          expand: true,
          cwd: './source',
          src: ['**/*.coffee'],
          dest: 'build/',
          ext: '.js'
        },
        componentCoffeeCompile: {
          options: {
            bare: true
          },
          files: {
            'source/apps/mongoose-socket/index.js': 'source/apps/mongoose-socket/index.coffee',
            'source/apps/mongoose-socket/rest.js': 'source/apps/mongoose-socket/rest.coffee',
            'source/apps/mongoose-socket/storage.js': 'source/apps/mongoose-socket/storage.coffee',
            'source/public/component/message/model.js': 'source/apps/message/model.coffee'
          }
        }
    },
    compass: {
      dist: {
        options: {
          sassDir: 'source/public/stylesheets',
          cssDir: 'build/public/stylesheets'
        }
      }
    },
    copy: {
      main: {
        files: [
          {expand: true, cwd: 'source/views/', src: ['**'], dest: 'build/views/'},
          {expand: true, cwd: 'source/public/component/build/', src: ['**/*.js'], dest: 'build/public/component/build/'},
          {expand: true, cwd: 'source/apps/', src: ['**/*.jade'], dest: 'build/apps/'},
          {expand: true, cwd: 'source/apps/', src: ['**/*.js'], dest: 'build/apps/'}
        ]
      }
    },
    concat: {
      options: {
        banner: "/* this file is generated by concat task of grunt.js */\n"
      },
      dist: {
        src: [
          "build/public/javascripts/*.js"
        ],
        dest: "build/public/main.js"
      }
    },
    uglify: {
      dist: {
        src: "<%= concat.dist.dest %>",
        dest: "build/public/main.min.js"
      }
    },
    watch: {
        files: ['source/**/*.coffee', 'source/**/*.jade', 'source/**/*.css', 'source/**/*.sass', 'tests/**/*'],
        tasks: ['coffee', 'shell', 'compass', 'copy', 'concat', 'uglify']
    },
    shell: {
      componentMongooseCompile: {
        command: 'cd source/public/component/mongoose-knockout;make;make install;'
      },
      componentCompile: {
        command: 'cd source/public/component;make;'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-shell');

  // Default task(s).
  grunt.registerTask('default', ['coffee', 'shell', 'compass', 'copy', 'concat', 'uglify']);

};