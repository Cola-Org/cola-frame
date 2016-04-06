express = require 'express'
router = express.Router()
router.get '/*', (req, res, next) ->
	templatePath=req.originalUrl.substr(1,req.originalUrl.length)
	console.log(templatePath)
	res.render templatePath,
		title: 'Cola-Frame'
module.exports = router
