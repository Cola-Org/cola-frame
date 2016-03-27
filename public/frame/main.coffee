cola((model)->
	model.describe("menus", {
		provider:
			url: Frame.prop("service.menus")
	})
	model.describe("messages", {
		provider:
			url: Frame.prop("service.messagePull")
	})
	model.describe("user", {
		provider:
			url: Frame.prop("service.user.detail")
	})

	model.widgetConfig({
		subMenuTree:
			$type: "tree",
			autoExpand: true,
			bind:
				expression: "menu in subMenu"
				child:
					recursive: true,
					expression: "menu in menu.menus"
	})
	model.action({
		showUserSidebar: ()->
			cola.widget("userSidebar").show()
		logout: ()->
			$.ajax({
				type: "POST",
				url: Frame.prop("service.logout")
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
				Frame.open(data.path, data)

		hideSubMenuLayer: ()->
			cola.widget("subMenuLayer").hide()
		toggleSidebar: ()->
			className = "collapsed"
			$dom = $("#frameworkSidebarBox")
			$dom.toggleClass(className, !$dom.hasClass(className));
	})

	$("#frameworkSidebar").accordion({exclusive: false})
)