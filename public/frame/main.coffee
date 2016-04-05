cola((model)->
	model.describe("menus", {
		provider:
			url: App.prop("service.menus")
	})
	model.describe("messages", {
		provider:
			url: App.prop("service.messagePull")
	})
	model.describe("user", {
		provider:
			url: App.prop("service.user.detail")
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
		subMenuLayer:
			beforeShow: ()->
				$("#viewTab").parent().addClass("lock")
			beforeHide: ()->
				$("#viewTab").parent().removeClass("lock")
	})
	model.action({
		dropdownDisplay: (item)->
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