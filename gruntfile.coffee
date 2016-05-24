path = require "path"
buildConfig = require "./build-configs"
currentDir = __dirname

module.exports = (grunt) ->
	grunt.initConfig
		build: buildConfig
		clean:
			dest: ["dest"]

		jade:
			compile:
				options:
					pretty: true,
					data:
						siteRoot: "<%=configure.siteRoot%>"
						contextPath: "<%=configure.contextPath%>"
						serviceRoot: "<%=configure.serviceRoot%>"
						htmlSuffix: "<%=configure.htmlSuffix%>"
						siteContext: "<%=configure.siteContext%>"
				files: [
					{
						expand: true
						cwd: "views/"
						src: ["**/*.jade"]
						dest: "<%=configure.dest%>"
						ext: ".html"
					}
				]

		coffee:
			compile:
				options:
					sourceMap: false
					join: true
				files: [{
					expand: true
					cwd: "public/"
					src: ["**/*.coffee"]
					dest: "<%=configure.dest%>"
					ext: ".js"
				}]

		less:
			compile:
				files: [{
					expand: true
					cwd: "public/"
					src: ["**/*.less",
					      "!**/.*.less"]
					dest: "<%=configure.dest%>"
					ext: ".css"
				}]

		copy:
			css:
				expand: true
				cwd: "public"
				src: ["resources/**/*", "!**/*.less", "!.**"]
				dest: "<%=configure.dest%>"


		uglify:
			all:
				files: [
					{
						expand: true
						preserveComments: "some"
						cwd: "<%=configure.dest%>"
						src: "**/*.js"
						dest: "<%=configure.dest%>"
						ext: ".js"
					}
				]

		cssmin:
			all:
				files: [
					{
						expand: true
						cwd: "<%=configure.dest%>"
						src: "**/*.css"
						dest: "<%=configure.dest%>"
						ext: ".css"
					}
				]

	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-jade"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-less"
	grunt.loadNpmTasks "grunt-contrib-copy"
	grunt.loadNpmTasks "grunt-contrib-uglify"
	grunt.loadNpmTasks "grunt-contrib-cssmin"
	grunt.loadNpmTasks "grunt-contrib-compress"

	grunt.task.registerMultiTask("replaceConfig", "replace ...", ()->
		commonJsPath = path.join(currentDir, "dest", "app", "common.js")
		content = grunt.file.read(commonJsPath)
		replace = (content, configure, key, defaultValue)->
			value = configure[key]
			if typeof value == "string"
				defaultValue or= ""
				console.log("#{key}: \"#{defaultValue}\"" + " | " + "#{key}: \"#{value}\"")
				return content.replace("#{key}: \"#{defaultValue}\"", "#{key}: \"#{value}\"")
			else
				defaultValue or= "null"
				return content.replace("#{key}: #{defaultValue}", "#{key}: #{value}");

		configure = grunt.config("configure")

		content = replace(content, configure, "version", "0.0.0")
		content = replace(content, configure, "siteRoot", "/")
		content = replace(content, configure, "contextPath", "/")
		content = replace(content, configure, "serviceRoot", "/")
		content = replace(content, configure, "htmlSuffix", "")
		content = replace(content, configure, "language", "zh-Hans")
		grunt.file.write(commonJsPath, content)
	)

	grunt.task.registerMultiTask("build", "Build all...", ()->
		endWithDelim = (path)->
			if (path.charAt(path.length - 1) != "/") then path += "/"
			return path
		startWithDelim = (path)->
			if (path.charAt(0) != "/") then path = "/" + path
			return path

		removeLastDelim = (path)->
			if (path.charAt(path.length - 1) == "/") then path = path.substring(0, path.length - 1)
			return path

		grunt.log.writeln("# Running ...")
		configure = this.data
		configure.dest = "dest";

		configure.contextPath = removeLastDelim(configure.contextPath)
		configure.siteRoot = endWithDelim(configure.siteRoot)
		configure.siteContext = "#{removeLastDelim(configure.siteRoot)}#{endWithDelim(startWithDelim(configure.contextPath))}"

		grunt.config("configure", configure)
		console.dir(configure)
		unless grunt._cleaned
			grunt._cleaned = true
			grunt.task.run("clean")

		grunt.task.run([
			"jade"
			"copy"
			"coffee"
			"less"
		])
	)
