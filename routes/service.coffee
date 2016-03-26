express = require 'express'
router = express.Router()

router.post '/account/login', (req, res, next) ->
	body = req.body
	result =
		type: false
		message: "用户名或密码错误！"
	if body.userName is "admin" and body.password is "123456"
		result =
			type: true
			user:
				id: "u0001"
				name: "Alex Tong"
				avatar: "/resources/images/avatars/alex.png"
		req.session.authenticated = true
	else
		req.session.authenticated = false
	res.send(result)

router.get("/menus", (req, res, next)->
	res.send(require("./data/menus"))
)
router.get("/message/pull", (req, res, next)->
	res.send({
		messageCount: 8
		taskCount: 22
	})
)
router.get("/products", (req, res, next)->
	res.send(require("./data/data"))
)

module.exports = router
