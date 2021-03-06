/*global module:false*/
module.exports = function(grunt) {

    var debounceDelay = 0;

    // LiveReload的默认端口号，你也可以改成你想要的端口号
    var lrPort = 35729;
    // 使用connect-livereload模块，生成一个与LiveReload脚本
    // <script src="http://127.0.0.1:35729/livereload.js?snipver=1" type="text/javascript"></script>
    var lrSnippet = require('connect-livereload')({
        port: lrPort
    });
    // 使用 middleware(中间件)，就必须关闭 LiveReload 的浏览器插件
    var serveStatic = require('serve-static');
    var serveIndex = require('serve-index');
    var md5File = require('md5-file');
    var lrMiddleware = function(connect, options, middlwares) {
        return [
            lrSnippet,
            // 静态文件服务器的路径 原先写法：connect.static(options.base[0])
            serveStatic(options.base[0]),
            // 启用目录浏览(相当于IIS中的目录浏览) 原先写法：connect.directory(options.base[0])
            serveIndex(options.base[0])
        ];
    };

    var gruntConfig = require("./gruntConfig")("./gruntConfig/gruntConfigComponents");

    // Project configuration.
    grunt.initConfig({
        // Metadata.
        pkg: grunt.file.readJSON('package.json'),
        secret: grunt.file.readJSON('../secret_for_formal.json'),
        // secret: grunt.file.readJSON('../secret.json'),
        dirs: grunt.file.readJSON('dirs.json'),

        banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
            '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
            '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
            ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
        // Task configuration.
        concat: {
            options: {
                banner: '<%= banner %>',
                stripBanners: true
            },
            dist: {
                src: ['lib/<%= pkg.name %>.js'],
                dest: 'dist/<%= pkg.name %>.js'
            }
        },
        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                undef: true,
                unused: true,
                boss: true,
                eqnull: true,
                browser: true,
                globals: {}
            },
            gruntfile: {
                src: 'Gruntfile.js'
            },
            lib_test: {
                src: ['lib/**/*.js', 'test/**/*.js']
            }
        },
        qunit: {
            files: ['test/**/*.html']
        },

        express: {
            options: {
                // 服务器端口号
                port: 3000,
                // 服务器地址(可以使用主机名localhost，也能使用IP)
                hostname: 'localhost',
                // 物理路径(默认为. 即根目录) 注：使用'.'或'..'为路径的时，可能会返回403 Forbidden. 此时将该值改为相对路径 如：/grunt/reloard。
                base: '.'
            },
            livereload: {
                options: {
                    middleware: lrMiddleware,
                    livereload: true,
                    script: 'app.js'
                }
            }
        },

        /*清除文件*/
        clean: {
            build: {
                src: ["<%= dirs.dest_path %>"]
            },
            version: {
                src: ["<%= dirs.dest_path %>public/<%= dirs.version %>"]
            }
        },

        copy: {
            test: {
                cwd: '<%= dirs.lib_path %>',
                src: [
                    '<%= dirs.js %>common/*.js',
                    '<%= dirs.css %>common/*.css',
                    '<%= dirs.js %>specialCommon/*.js',
                    '<%= dirs.css %>specialCommon/*.css',
                ],
                dest: '<%= dirs.dest_path %>',
                expand: true
            },

            versioncontrol: {
                options: {
                    process: function(content, srcpath) {

                        var versionPrefix = "/public/version";

                        var commonMap = {
                            commonJs: {
                                reg: /(?:\/public\/js\/)(\S+)(?:\/extra\.min\.js)((\?v=)(\w+))?/g,
                                path: 'bin/public/js/common/extra.min.js',
                                prefix: '/public/js/common/extra.min_',
                                type: '.js'
                            }
                        };

                        var pageMap = {
                            mainCss: {
                                reg: /(?:\/public\/css\/)(\S+)(?:\/main\.min\.css)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/css/{page}/main.min.css',
                                prefix: '/public/css/{page}/main.min_',
                                type: ".css"
                            },
                            base64Css: {
                                reg: /(?:\/public\/css\/)(\S+)(?:\/base64\.min\.css)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/css/{page}/base64.min.css',
                                prefix: '/public/css/{page}/base64.min_',
                                type: ".css"
                            },
                            mainJs: {
                                reg: /(?:\/public\/js\/)(\S+)(?:\/main\.min\.js)(?:(?:\?v=)(?:\w+))?/g,
                                path: 'bin/public/js/{page}/main.min.js',
                                prefix: '/public/js/{page}/main.min_',
                                type: ".js"
                            },
                        };
                        try {
                            for (var key in commonMap) {
                                content = content.replace(commonMap[key].reg, versionPrefix + commonMap[key].prefix + md5File(commonMap[key].path).substring(0, 10) + commonMap[key].type);
                            }
                            for (var key in pageMap) {
                                var found = pageMap[key].reg.exec(content);

                                if (!found)
                                    continue;

                                var file = pageMap[key].path.replace('{page}', found[1]),
                                    fileMd5 = md5File(file).substring(0, 10),
                                    prefix = pageMap[key].prefix.replace('{page}', found[1]);
                                type = pageMap[key].type

                                content = content.replace(found[0], versionPrefix + prefix + fileMd5 + type);
                            }
                        } catch(e) {
                            console.log(e);
                        }

                        return content;
                    }
                },
                files: [
                {
                    cwd: './bin/module_static',
                    src: ["**/*.html"],
                    dest: './bin/views',
                    expand: true
                },
                {
                    cwd: './bin/module_dynamic',
                    src: ["**/*.php"],
                    dest: './bin/module',
                    expand: true
                }
                ]
            }
        },
        jade       :        gruntConfig.jade,
        less       :        gruntConfig.less,
        livescript :        gruntConfig.livescript,
        browserify :        gruntConfig.browserify,
        watch      :        gruntConfig.watch,
        uglify     :        gruntConfig.uglify,
        cssmin     :        gruntConfig.cssmin,

        hashmap: {
            options: {
                // These are default options
                output: '#{= dest}/Manage/hash.json',
                etag: null, // See below([#](#option-etag))
                algorithm: 'md5', // the algorithm to create the hash
                rename: '#{= dirname}/#{= basename}_#{= hash}#{= extname}', // save the original file as what
                keep: true, // should we keep the original file or not
                merge: false, // merge hash results into existing `hash.json` file or override it.
                hashlen: 10, // length for hashsum digest
            },
            map: {
                cwd: '<%= dirs.dest_path %>',
                src: ['<%= dirs.js %>**/main.min.js',
                    '<%= dirs.js %>**/extra.min.js',
                    '<%= dirs.css %>**/*.min.css'
                ],
                dest: '<%= dirs.dest_path %>public/<%= dirs.version %>'
            }
        },


        sftp: {
            options: {
                host: '<%= secret.host %>',
                username: '<%= secret.username %>',
                password: '<%= secret.password %>',
                showProgress: true,
                srcBasePath: "<%= dirs.dest_path %>",
                port: '<%= secret.port %>',
                createDirectories: true
            },
            config: {
                options: {
                    path: '<%= secret.path %>/application'
                },
                files: {
                    "./": ["<%= dirs.dest_path %>public/<%= dirs.version %>**/main.min*.js",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/extra.min*.js",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/main.min*.css",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/extra.min*.css",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/base64.min*.css",
                        "<%= dirs.dest_path %>public/**/specialCommon/**",
                        "<%= dirs.dest_path %>public/<%= dirs.version %>**/hash.json"
                    ]
                }
            },
            module_static: {
                options: {
                    path: '<%= secret.path %>/application'
                },
                files: {
                    "./": ["<%= dirs.dest_path %>views/**/*.html"]
                }
            },
            module_dynamic: {
                options: {
                    path: '<%= secret.path %>'
                },
                files: {
                    "./": ["<%= dirs.dest_path %>module/**/*.php"]
                }
            }
        },

        sshexec: {
            test: {
                command: ['sh -c "cd /srv/www/WeTable; ls"',
                    'sh -c "cd /; ls"'
                ],
                options: {
                    host: '<%= secret.host %>',
                    username: '<%= secret.username %>',
                    password: '<%= secret.password %>'
                }
            }
        }
    });


    // These plugins provide necessary tasks.
    grunt.loadNpmTasks('grunt-contrib-nodeunit');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-livescript');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-ssh');
    grunt.loadNpmTasks('grunt-hashmap');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-express-server');
    grunt.loadNpmTasks('grunt-filerev');
    grunt.loadNpmTasks('grunt-usemin');

    grunt.registerTask('default', [
        'clean:build',
        'express',
        'copy:test',
        'less',
        'livescript',
        'browserify',
        'jade',
        'watch'
    ]);
    grunt.registerTask('ready', [
        'copy:test',
        'less',
        'livescript',
        'uglify',
        'cssmin',
        'clean:version',
        'hashmap'
    ]);

    // just for test
    var option2path = {
        "settings_staff": ["/CanteenManageSettings/Staff/**/", "/Settings/Staff", ""] // settings_staff as a test, Todo -> add all
    }
    var target = grunt.option('target') || 'dev';
    if (target !== 'dev') {
        var target_path = option2path[target];
        grunt.config('sftp.config.files', {'./': [
            "<%= dirs.dest_path %>public/<%= dirs.version %>/public/js"+target_path[0]+"main.min*.js",
            "<%= dirs.dest_path %>public/<%= dirs.version %>**/extra.min*.js",
            "<%= dirs.dest_path %>public/<%= dirs.version %>/public/css"+target_path[0]+"main.min*.css",
            "<%= dirs.dest_path %>public/<%= dirs.version %>**/extra.min*.css",
            "<%= dirs.dest_path %>public/<%= dirs.version %>/public/css"+target_path[0]+"base64.min*.css",
            "<%= dirs.dest_path %>public/**/specialCommon/**",
            "<%= dirs.dest_path %>public/<%= dirs.version %>**/hash.json"
        ]});
        if (target_path[1] !== "") {
            grunt.config('sftp.module_static.files', {'./': ["<%= dirs.dest_path %>views/Manage"+target_path[1]+"/*.html"]});
        } else {
            grunt.config('sftp.module_static.files', {});
        }
        if (target_path[2] !== "") {
            grunt.config('sftp.module_dynamic.files', {'./': ["<%= dirs.dest_path %>module/Manage"+target_path[2]+"/*.php"]});
        } else {
            grunt.config('sftp.module_dynamic.files', {});
        }
    }
    grunt.registerTask('upload', [
        'clean',
        'copy:test',
        'less',
        'livescript',
        'browserify',
        'jade',
        'cssmin',
        'uglify',
        'hashmap',
        'copy:versioncontrol',
        'sftp'
    ]);
    grunt.registerTask('backup', [
        'copy:backup',
    ]);
    grunt.registerTask('extra', [
        'copy:test',
        'jade',
        'less'
    ]);
};
