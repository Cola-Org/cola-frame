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
		menuTree:
			$type: "tree",
			autoExpand:true,
			autoCollapse:false,
			bind:
				expression: "menu in menus"
				child:
					recursive: true,
					expression: "menu in menu.menus"
	})
	model.action({
		showUserSidebar: ()->
			cola.widget("userSidebar").show()
		menuItemClick: (item)->

		toggleSidebar: ()->
			className = "collapsed"
			$dom = $("#frameworkSidebarBox")
			$dom.toggleClass(className, !$dom.hasClass(className));
	})



)