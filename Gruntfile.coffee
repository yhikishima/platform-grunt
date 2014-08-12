module.exports = (grunt) ->
  # 時間計測
  require('time-grunt') grunt
  # プラグイン動的ロード
  require('jit-grunt') grunt,
    jscs: 'grunt-jscs-checker'
    sprite: 'grunt-spritesmith'

  basepath = grunt.option('basepath') || './'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  # パス設定
    path:
      src: 'assets'
      data: '<%= path.src %>/data'
      basepath: basepath
      build: 'build'
      tmp: '<%= path.build %>/.tmp'
      dist: '<%= path.build %>/dist'
      reports: '<%= path.build %>/reports'

  # ビルドフォルダ削除
    clean:
      build: '<%= path.build %>'

  # ファイルコピー
    copy:
      server:
        files: [
          {
            expand: true
            cwd: '<%= path.src %>'
            src: [
              '**/*.!(hbs|scss|js|ts|yaml|md)'
              'js/sub/**'
              'js/lib/**'
              '!img/sprites/**'
              '!ts/d_ts/**'
            ]
            dest: '<%= path.tmp %>'
          }
        ]
      dist:
        files: [
          {
            expand: true
            cwd: '<%= path.src %>'
            src: [
              '**/*.!(hbs|scss|js|ts|yaml|md)'
              'js/sub/**'
              'js/lib/**'
              '!img/sprites/**'
            ]
            dest: '<%= path.dist %>'
          }
          {
            expand: true
            cwd: '<%= path.tmp %>'
            src: [
              '**'
              '!_*.html'
            ]
            dest: '<%= path.dist %>'
          }
        ]

  # HTML生成
    assemble:
      options:
        flatten: true
        data: '<%= path.data %>/*'
        layoutdir: '<%= path.src %>/templates/layouts'
        layout: 'base'
        layoutext: '.hbs'
        helpers: ['<%= path.src %>/templates/helpers/*.js' ]
        partials: ['<%= path.src %>/templates/**/*.hbs']
        basepath: '<%= path.basepath %>'
      compile:
        expand: true
        cwd: '<%= path.src %>/templates'
        src: [
          '**/*.hbs'
          '!layouts/**'
        ]
        dest: '<%= path.tmp %>'

  # HTML静的構文チェック
    htmlhint:
      options:
        htmlhintrc: '.htmlhintrc'
      dev:
        src: '<%= path.tmp %>/**/!(_)*.html'
      prod:
        options:
          force: true
          formatters: [
            id: 'checkstyle'
            dest: '<%= path.reports %>/htmlhint.xml'
          ]
        src: '<%= path.tmp %>/**/!(_)*.html'

  # HTML整形
    prettify:
      options:
        indent: 1
        indent_char: '\t'
      prettify:
        expand: true
        cwd: '<%= path.dist %>'
        src: [
          '**/*.html'
        ]
        dest: '<%= path.dist %>'


  # CSS生成
    compass:
      options:
        cssDir: '<%= path.tmp %>/css/'
        sassDir: '<%= path.src  %>/scss/'
        imagesDir: '<%= path.src %>/img/'
        javascriptsDir: '<%= path.src %>/js/'
      dev:
        environment: 'development'
        outputStyle: 'expended'
      prod:
        environment: 'production'
        outputStyle: 'compressed'
        noLineComments: true

    css:
      files: ['<%= path.tmp %>/scss/*.scss'],
      tasks: ['compass']
      options:
        atBegin: true

  # CSS静的構文チェック
    csslint:
      options:
        csslintrc: '.csslintrc'
      dev:
        src: [
          '<%= path.tmp %>/**/*.css'
        ]
      prod:
        options:
          force: true
          formatters: [
            id: 'checkstyle-xml'
            dest: '<%= path.reports %>/csslint.xml'
          ]
        src: [
          '<%= path.tmp %>/**/*.css'
          '!<%= path.tmp %>/css/bootstrap.css'
        ]

  # JS静的構文チェック
    jshint:
      options:
        jshintrc: '.jshintrc'
      dev:
        src: [
          '<%= path.src %>/**/*.js'
          '!<%= path.src %>/js/lib/*.js'
        ]
      prod:
        options:
          force: true
          reporter: 'checkstyle'
          reporterOutput: '<%= path.reports %>/jshint.xml'
        src: '<%= path.src %>/**/*.js'

  # JSコードスタイルチェック
    jscs:
      options:
        config: '.jscsrc'
      dev:
        src: [
          '<%= path.src %>/*.js'
          '<%= path.src %>/sub/*.js'
        ]
      prod:
        options:
          force: true
          reporter: 'checkstyle'
          reporterOutput: '<%= path.reports %>/jscs.xml'
        src: '<%= path.src %>/**/*.js'

  # JS結合
    concat:
      dist:
        src: '<%= path.src %>/js/common/*.js'
        dest: '<%= path.tmp %>/js/common.js'

  # JS縮小化
    uglify:
      options:
        preserveComments: require 'uglify-save-license'
        report: 'min'
      min:
        expand: true
        cwd: '<%= path.dist %>'
        src: [
          '**/*.js'
          '!**/*.min.js'
          '!js/lib/html5shiv.js'
        ]
        dest: '<%= path.dist %>'

  # typescript
    typescript:
      base:
        options:
          comments: true
        src: '<%= path.src %>/ts/**/*.ts'
        dest: '<%= path.tmp %>/js/ts.js'

  # 画像スプライト化
    sprite:
      create:
        src: '<%= path.src %>/img/sprites/*'
        destImg: '<%= path.tmp %>/img/sprite.png'
        destCSS: '<%= path.src %>/scss/var/_sprite.scss'
        imgPath: '../img/sprite.png'
        algorithm: 'binary-tree'
        engine: 'pngsmith'

  # Zipアーカイブ
    compress:
      dist:
        options:
          archive: '<%= path.build %>/assets.zip'
        expand: true
        cwd: '<%= path.dist %>'
        src: ['**/!(_)*']
        dest: 'assets'

  # basepath 補完
    'string-replace':
      html:
        options:
          replacements: [
            pattern: /\="(\/[^\/][^"]*)"/g
            replacement: (match, url) ->
              if url.indexOf(basepath) isnt 0 then '="' + basepath + url + '"' else match
          ]
        expand: true
        cwd: '<%= path.dist %>'
        src: '**/*.html'
        dest: '<%= path.dist %>'
      css:
        options:
          replacements: [
            pattern: /url\(['"]?(\/[^\/][^'")]*)['"]?\)/g
            replacement: (match, url) ->
              if url.indexOf(basepath) isnt 0 then 'url(' + basepath + url + ')' else match
          ]
        expand: true
        cwd: '<%= path.dist %>'
        src: '**/*.css'
        dest: '<%= path.dist %>'

  # ローカルサーバー
    connect:
      options:
        port: 9997
        debug: true
        livereload: 34568
        # open: 'http://localhost:<%= connect.options.port %>/index.html'
      livereload:
        options:
          base: ['<%= path.tmp %>', '<%= path.src %>']
      dist:
        options:
          keepalive: true
          base: ['<%= path.dist %>']

  # ftpデプロイ
    'ftp-deploy':
      build:
        auth:
          host: '10.15.247.105'
          authKey: 'key1'
        src: '<%= path.dist %>'
        dest: '/home/web5/SPF/backend/'

  # ファイル変更監視
    watch:
      options:
        spawn: false
        livereload: '<%= connect.options.livereload %>'
      html:
        files: ['<%= path.src %>/**/*.{hbs,yaml}']
        tasks: ['newer:assemble']
      css:
        files: ['<%= path.src %>/**/*.scss']
        tasks: ['compass']
      concat:
        files: ['<%= path.src %>/js/common/*.js']
        tasks: ['concat']
      js_tmp:
        files: ['<%= path.src %>/**/*.js']
        tasks: ['newer:copy:server']
      js:
        options:
          livereload: false
        files: ['<%= path.src %>/**/*.js']
        tasks: ['newer:jshint:dev']
      ts:
        files: ['<%= path.src %>/ts/**/*.ts']
        tasks: ['newer:typescript']

  # タスク定義
  grunt.registerTask 'pre-build', ['sprite']
  grunt.registerTask 'build', ['pre-build', 'assemble', 'compass']
  grunt.registerTask 'lint', ['htmlhint:dev', 'csslint:dev', 'jshint:dev', 'jscs:dev']
  grunt.registerTask 'lint:prod', ['htmlhint:prod', 'csslint:prod', 'jshint:prod', 'jscs:prod']
  grunt.registerTask 'optimize', ['prettify', 'uglify']

  # server タスク
  grunt.registerTask 'server', [
    'build'
    'concat'
    'copy:server'
    'optimize'
    'connect:livereload'
    'lint:prod'
    'watch'
  ]

  # default タスク
  grunt.registerTask 'default', [
    'build'
    'lint'
  ]

  # dist タスク
  grunt.registerTask 'dist', [
    'build'
    'concat'
    'lint:prod'
    'copy:dist'
    'optimize'
    'compress'
    'string-replace'
  ]

  # deploy タスク
  grunt.registerTask 'deploy', [
    'build'
    'concat'
    'lint:prod'
    'copy:dist'
    'optimize'
    'compress'
    'string-replace'
    'ftp-deploy'
  ]