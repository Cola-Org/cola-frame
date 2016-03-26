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
	makeMenuItemDom = (data, i)->
		contentDom = [
			{
				class: "title menu-item"
				content: [
					{
						tagName: "i"
						class: data.icon
					}
					{
						tagName: "span"
						content: data.label
					}
				]
			}
		]
		if data.menus
			menusDom = []
			for itemDate in data.menus
				menusDom.push(makeMenuItemDom(itemDate))
			contentDom.push({
				class: "content"
				content: menusDom
			})
		return {
		tagName: "div"
		class: "item"
		content: contentDom
		}
	model.widgetConfig({
		subMenuTree:
			$type: "tree",
			autoExpand: true,
			bind:
				hasChildProperty: "hasChild"
				expression: "menu in subMenu"
				child:
					recursive: true,
					hasChildProperty: "hasChild",
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
			console.log(event.target)
			if event.target
				$(event.target).closest()
			menus = data.menus
			recursive = (d)->
				if d.menus
					d.hasChild = true
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