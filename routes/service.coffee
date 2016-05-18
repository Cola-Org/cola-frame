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
router.post '/account/logout', (req, res, next) ->
	req.session.authenticated = false
	res.send({
		type: true
		message: "已安全退出！"
	})
router.get("/menus", (req, res, next)->
	res.send(require("./data/menus"))
)
router.get("/shortcut-menus", (req, res, next)->
	res.send({
		label: "企业账户管理中心",
		menus: [
			{
				icon: "iconfont icon-yonghuliebiao",
				label: "标准定价",
				path: "/example/time-line"
			}, {
				icon: "iconfont icon-yonghuguanli",
				label: "特殊定价",
				menus: [
					{
						icon: "iconfont icon-yonghuliebiao",
						label: "用户列表", path: "/example/time-line"
					}, {
						icon: "iconfont icon-yonghuguanli",
						label: "用户组"
					}, {
						icon: "iconfont icon-zhucerenzheng",
						label: "职位管理"
					}
				]
			}
		]
	})
)
router.get("/message/pull", (req, res, next)->
	res.send([
		{
			type: "message",
			content: 8
		},
		{
			type: "task",
			content: 22
		}
	])
)
router.get("/products", (req, res, next)->
	data = require("./data/data")
	res.send({$entityCount: 20, $data: data})
)
router.get("/shoes", (req, res, next)->
	items = require("./data/shoes")
	query = req.query
	pageSize = parseInt(query.pageSize or 5)
	pageNo = parseInt(query.pageNo or 1)
	from = (pageNo - 1) * pageSize
	limit = from + pageSize

	if query.id and query.id.length > 0
		result = []
		for item in items
			if item.id.toString().indexOf(query.id) >= 0 then result.push(item)
		res.send({
			$entityCount: result.length
			$data: result.slice(from, limit)
		})
	else
		res.send({
			$entityCount: items.length
			$data: items.slice(from, limit)
		})
)
router.get("/user/detail", (req, res, next)->
	res.send({
		id: "u0001"
		name: "Alex Tong"
		avatar: "/resources/images/avatars/alex.png"
	})
)
module.exports = router
