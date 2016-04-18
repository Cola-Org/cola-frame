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
router.get ['/site'], (req, res, next) ->
		res.render '.site',
			title: 'Cola-Frame'
router.get ['/readme'], (req, res, next) ->
	res.render 'index',
		title: 'Cola-Frame'

module.exports = router
