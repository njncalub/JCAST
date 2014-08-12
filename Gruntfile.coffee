module.exports = (grunt) ->

  grunt.initConfig

    # Project Specific Definitions
    ios_family: "universal"
    ios_adhoc_name: "David Bankier"
    ios_adhoc_profile: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    ios_appstore_name:"YY Digital PTY LTD"
    ios_appstore_profile:"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    android_keystore: "./android.keystore"
    android_keypass: "changeit"

    # Task Configuration
    jade:
      compile:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'ti/src/'
          dest: 'ti/app/'
          src: [
            '**/*.jade'
            '!**/includes/**'
            '!**/templates/**'
          ]
          ext: '.xml'
        ]

    coffee:
      compile:
        options:
          bare: true
          sourceMap: true
        files: [
          expand: true
          cwd: 'ti/src/'
          dest: 'ti/app/'
          src: [
            '**/*.coffee'
          ]
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'ti/tests/'
          dest: 'ti/spec/'
          src: [
            '**/*.coffee'
          ]
          ext: '.js'
        ]

    stss:
      compile:
        files: [
          expand: true
          cwd: 'ti/src/'
          dest: 'ti/app/'
          src: [
            '**/*.stss'
            '!**/_*.stss'
          ]
          ext: '.tss'
        ]

    tishadow:
      options:
        projectDir: 'ti/'
        update: true
      run_android:
        command: 'run'
        options:
          projectDir: 'ti/'
          platform: [ 'android' ]
      run_ios:
        command: 'run'
        options:
          projectDir: 'ti/'
          platform: [ 'ios' ]
      run:
        command: 'run'
        options:
          projectDir: 'ti/'
      spec_android:
        command: 'spec'
        options:
          update: false
          projectDir: 'ti/'
          platform: [ 'android' ]
      spec_ios:
        command: 'spec'
        options:
          update: false
          projectDir: 'ti/'
          platform: [ 'ios' ]
      clear:
        command: 'clear'

    copy:
      alloy:
        files: [
          expand: true
          dot: true
          cwd: 'ti/src/'
          dest: 'ti/app/'
          src: [
            '**'
            '!**/*.jade'
            '!**/*.coffee'
            '!**/*.stss'
          ]
        ]

    shell:
      options:
        stdout: true
        stderr: true
      iphone6:
        command: "titanium build -p ios -S 6.1 -Y iphone"
      iphone7:
        command: "titanium build -p ios -S 7.1 -Y iphone"
      ipad6:
        command: "titanium build -p ios -S 6.1 -Y ipad"
      ipad7:
        command: "titanium build -p ios -S 7.1 -Y ipad"
      adhoc:
        command: 'ti build -p ios -F <%= ios_family %> -T dist-adhoc -R "<%= ios_adhoc_name %>" -P" <%= ios_adhoc_profile %>"  -O ~/Desktop '
      appstore:
        command: 'ti build -p ios -F <%= ios_family %> -T dist-appstore -R "<%= ios_appstore_name %>" -P" <%= ios_apptore_profile %>"  -O ~/Desktop '
      playstore:
        command: 'ti build -T dist-playstore -O ~/Desktop -p android -K <%= android_keystore %> - P <%= android_keypass %>'

    watch:
      options:
        nospawn: true
      ios:
        files: [ 'ti/src/**/*' ]
        tasks: [
          'build'
          'tishadow:run_ios'
        ]
      android:
        files: [ 'ti/src/**/*' ]
        tasks: [
          'build'
          'tishadow:run_android'
        ]
      all:
        files: [ 'ti/src/**/*' ]
        tasks: [
          'build'
          'tishadow:run'
        ]

    clean:
      ti: [
        'ti/Resources/'
        'ti/app/'
        'ti/build/'
        'ti/spec/'
      ]

  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.registerTask 'default', 'build'
  grunt.registerTask 'build', [
    'jade'
    'coffee'
    'stss'
    'copy'
  ]
  grunt.registerTask 'dev_ios', [
    'build'
    'tishadow:run_ios'
    'watch:ios'
  ]
  grunt.registerTask 'dev_android', [
    'build'
    'tishadow:run_android'
    'watch:android'
  ]
  grunt.registerTask 'dev', [
    'build'
    'tishadow:run'
    'watch:all'
  ]
  grunt.registerTask 'test_ios', [
    'tishadow:clear'
    'clean'
    'build'
    'tishadow:spec_ios'
  ]
  grunt.registerTask 'test_android', [
    'tishadow:clear'
    'clean'
    'build'
    'tishadow:spec_android'
  ]
  grunt.registerTask 'test', [
    'tishadow:clear'
    'clean'
    'build'
    'tishadow:spec_android'
    'tishadow:spec_ios'
  ]

  # titanium cli tasks
  ['iphone6', 'iphone7', 'ipad6', 'ipad7', 'appstore', 'adhoc', 'playstore'].forEach (target) ->
    grunt.registerTask target, ['build','shell:'+target]

  grunt.event.on 'watch', (action, filepath) ->
    o = {}
    if (filepath.match /.jade$/ and filepath.indexOf "includes" is -1)
      o[filepath.replace ".jade", ".xml"] = [filepath]
      grunt.config.set ['jade', 'compile', 'files'], o
    else if (filepath.match /.coffee$/ and filepath.indexOf "includes" is -1)
      o[filepath.replace ".coffee", ".js"] = [filepath]
      grunt.config.set ['coffee', 'compile', 'files'], o
    else if (filepath.match /.stss$/ and filepath.indexOf "includes" is -1)
      if filepath.match /\/_.*?\.stss/
        grunt.log.write "Partial modified, rewriting all styles"
        grunt.config.set ['stss', 'compile', 'files'], [
          expand: true
          src: ['**/*.stss','!**/_*.stss']
          cwd: 'ti/src/'
          dest: 'ti/app/'
          ext: '.tss'
        ]
      else
        o[filepath.replace ".stss", ".tss"] = [filepath]
        grunt.config.set ['stss', 'compile', 'files'], o
