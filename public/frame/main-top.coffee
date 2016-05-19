cola((model)->
	logo = App.prop("app.logo.path")
	appName = App.prop("app.name")
	if logo
		$("#appHeader").append($.xCreate({
			tagName: "img"
			class: "img ui mini image"
			src: logo
		}))
	if appName
		$("#appHeader").append($.xCreate({
			tagName: "span"
			content: appName
		}))

#	model.set("menus", [
#		{
#			icon: "iconfont icon-yonghuguanli",
#			label: "销售管理",
#			menus: [
#				{
#					icon: "iconfont icon-yonghuliebiao",
#					label: "销售订单",
#					menus: [
#						{
#							label: "全部订单"
#						},
#						{
#							label: "未完成订单"
#						},
#						{
#							label: "未收款订单"
#						}
#					]
#				}, {
#					icon: "iconfont icon-yonghuguanli",
#					label: "销售收款",
#					menus: [
#						{
#							label: "全部对账单"
#						},
#						{
#							label: "已收款对账单"
#						}
#					]
#				}, {
#					icon: "iconfont icon-zhucerenzheng",
#					label: "销售提成",
#					menus: [
#						{
#							label: "全部提成"
#						},
#						{
#							label: "未分配提成"
#						},
#						{
#							label: "已分配提成"
#						}
#					]
#				}
#			]
#		},
#		{
#			icon: "iconfont icon-yonghuguanli",
#			label: "用户管理",
#			menus: [
#				{
#					icon: "iconfont icon-yonghuliebiao",
#					label: "用户列表"
#				},
#				{
#					icon: "iconfont icon-yonghuguanli",
#					label: "用户组"
#				},
#				{
#					icon: "iconfont icon-zhucerenzheng",
#					label: "职位管理"
#				},
#				{
#					icon: "iconfont icon-03",
#					label: "批量邀请"
#				}
#			]
#		}])

	model.describe("menus", {
		provider:
			url: App.prop("service.menus")
	})


	model.describe("user", {
		provider:
			url: App.prop("service.user.detail")
	})
	model.set("subMenus", [])

	model.dataType({
		name: "Login"
		properties: {
			userName:
				validators: {$type: "required", message: ""}
			password:
				validators: {$type: "required", message: ""}
		}
	})
	model.describe("login", "Login")
	model.set("login", {})
	model.set("messages", {})

	errorCount = 0
	longPollingTimeOut = null
	window.refreshMessage = ()->
		options = {}
		if longPollingTimeOut then clearTimeout(longPollingTimeOut)
		if App.prop("longPollingTimeout")
			options.timeout = App.prop("longPollingTimeout")
		$.ajax(App.prop("service.messagePull"), options).done((messages)->
			if messages
				errorCount = 0
				for message in messages
					model.set("messages.#{message.type}", message.content)
			if App.prop("liveMessage")
				longPollingTimeOut = setTimeout(refreshMessage, App.prop("longPollingInterval"))
		).error((xhr, status, ex)->
			if App.prop("liveMessage")
				if status == "timeout"
					longPollingTimeOut = setTimeout(refreshMessage, App.prop("longPollingInterval"))
				else
					errorCount++
					longPollingTimeOut = setTimeout(refreshMessage, 5000 * Math.pow(2, Math.min(6, (errorCount - 1))))
		)


	longPollingTimeOut = setTimeout(refreshMessage, 1000)

	refreshMessage()

	loginCallback = null
	window.login = (callback)->
		cola.widget("loginDialog").show()
		if callback and typeof  callback == "function"
			loginCallback = callback
	login = ()->
		data = model.get("login")
		cola.widget("containerSignIn").addClass("loading")
		$.ajax({
			type: "POST",
			url: App.prop("service.login")
			data: JSON.stringify(data.toJSON())
			contentType: "application/json"
		}).done((result) ->
			cola.widget("containerSignIn").removeClass("loading")
			unless result.type
				showMessage(result.message)
				return
			cola.widget("loginDialog").hide()
			if loginCallback
				callback = loginCallback
				loginCallback = null
				callback()
		).fail(() ->
			cola.widget("containerSignIn").removeClass("loading")
			return
		)
	model.widgetConfig({
		loginDialog:
			$type: "dialog"
			width: 400

		subMenuTree:
			$type: "tree"
			autoExpand: true
			bind:
				expression: "menu in subMenu"
				child:
					recursive: true
					expression: "menu in menu.menus"
			itemClick: (self, arg)->
				data = arg.item.get("data").toJSON()
				menus = data.menus
				if menus and menus.length > 0
					return
				else
					App.open(data.path, data)
					cola.widget("subMenuLayer").hide()
		subMenuLayer:
			beforeShow: ()->
				$("#viewTab").parent().addClass("lock")
			beforeHide: ()->
				$("#viewTab").parent().removeClass("lock")
	})
	showLoginMessage = (content)->
		cola.widget("formSignIn").setMessages([{
			type: "error"
			text: content
		}])
	model.action({
		changeMain: (item)->
			model.get("menus").setCurrent(item)

#			model.set("subMenus", item.get("menus").toJSON())
			$("#frameworkSidebar").accordion("refresh")

		signIn: ()->
			cola.widget("formSignIn").setMessages(null)
			data = model.get("login")
			if data.validate()
				login()
			else
				showLoginMessage("用户名或密码不能为空！")
		dropdownIconVisible: (item)->
			menus = item.get("menus")
			result = false
			if menus and menus.entityCount > 0
				result = true
			return result
		showUserSidebar: ()->
			cola.widget("userSidebar").show()
		logout: ()->
			$.ajax({
				type: "POST",
				url: App.prop("service.logout")
			}).done((result) ->
				if result.type
					window.location.reload()
			).fail(() ->
				alert("退出失败，请检查网络连接！")
				return
			)

		menuItemClick: (item)->
			data = item.toJSON("never")
			menus = data.menus
			recursive = (d)->
				if d.menus
					recursive(item) for item in d.menus
				else
					d.hasChild = false
			if menus
				recursive(data) for menu in menus
				model.set("subMenu", menus)
				model.set("currentMenu", data)
				cola.widget("subMenuLayer").show()
			else
				model.set("subMenu", [])
				cola.widget("subMenuLayer").hide()
				App.open(data.path, data)

		hideSubMenuLayer: ()->
			cola.widget("subMenuLayer").hide()
		toggleSidebar: ()->
			className = "collapsed"
			$dom = $("#frameworkSidebarBox")
			$dom.toggleClass(className, !$dom.hasClass(className));
		messageBtnClick: ()->
			action = App.prop("message.action")
			if action and typeof action is "object"
				App.open(action.path, action)
			return

		taskBtnClick: ()->
			action = App.prop("task.action")
			if action and typeof action is "object"
				App.open(action.path, action)
	})

	$("#frameworkSidebar").accordion({exclusive: false}).delegate(".menu-item", "click", ()->
		$("#frameworkSidebar").find(".menu-item.current-item").removeClass("current-item");
		$fly(@).addClass("current-item")
	)
	$("#rightContainer>.layer-dimmer").on("click", ()->
		cola.widget("subMenuLayer").hide();
	)
)

cola.ready(()->
	workbench = App.prop("workbench")
	if workbench then App.open(workbench.path, workbench)
)