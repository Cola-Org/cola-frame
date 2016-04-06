cola((model)->
	model.describe("menus", {
		provider:
			url: App.prop("service.menus")
	})

	model.describe("user", {
		provider:
			url: App.prop("service.user.detail")
	})


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

	window.refreshMessage = ()->
		model.describe("messages", {
			provider:
				url: App.prop("service.messagePull")
		})
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
#			height: 300

		subMenuTree:
			$type: "tree"
			autoExpand: true
			bind:
				expression: "menu in subMenu"
				child:
					recursive: true
					expression: "menu in menu.menus"
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
		signIn: ()->
			cola.widget("formSignIn").setMessages(null)
			data = model.get("login")
			if data.validate()
				login()
			else
				showLoginMessage("用户名或密码不能为空！")
		dropdownIconVisible: (item)->
			return !!item.get("menus")
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
			data = item.toJSON()
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
	})

	$("#frameworkSidebar").accordion({exclusive: false}).delegate(".menu-item", "click", ()->
		$("#frameworkSidebar").find(".menu-item.current-item").removeClass("current-item");
		$fly(@).addClass("current-item")
	)
	$("#rightContainer>.layer-dimmer").on("click", ()->
		cola.widget("subMenuLayer").hide();
	)
)