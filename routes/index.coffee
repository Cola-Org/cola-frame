express = require 'express'
router = express.Router()

# GET home page.
router.get ['/','/frame/main'], (req, res, next) ->
	if req.session.authenticated
		res.render 'frame/main',
			title: 'Cola-Frame'
	else
		res.render 'frame/account/login',
			title: '登录'

module.exports = router
