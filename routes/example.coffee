express = require 'express'
router = express.Router()
router.get("*", (req, res, next)->
	originalUrl=req.originalUrl
	template=originalUrl.substring(1,originalUrl.length)
	res.render template,
		title: 'Cola-Frame'
);

module.exports = router
