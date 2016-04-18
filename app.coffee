express = require 'express'
path = require 'path'
#favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require('express-session')

routes = require './routes/index'
service = require './routes/service'
frame = require './routes/frame'
example = require './routes/example'
app = express()

# view engine setup
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use favicon "#{__dirname}/public/favicon.ico"
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
	extended: false
app.use cookieParser()
app.use(require('less-middleware')(path.join(__dirname, 'public')))
app.use(require('coffee-middleware')(path.join(__dirname, 'public')))
app.use express.static path.join __dirname, 'public'
app.use express.static path.join __dirname, 'data'
app.use(session({
	secret: 'recommand 128 bytes random string',
	cookie: {maxAge: 20 * 60 * 1000}
}));
app.use '/', routes
app.use '/frame', frame
app.use '/service', service
app.use '/example', example
httpProxy = require("http-proxy")
proxy = httpProxy.createProxy({
	target: 'http://localhost:8080'
})

# catch 404 and forward to error handler
app.use (req, res, next) ->
	if req.originalUrl.indexOf("/service/") >= 0
		proxy.web(req, res)
	else
		err = new Error 'Not Found'
		err.status = 404
		next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
	app.use (err, req, res, next) ->
		res.status err.status or 500
		res.render 'frame/404',
			message: err.message,
			error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
	res.status err.status or 500
	res.render 'frame/500',
		message: err.message,
		error: {}

module.exports = app
