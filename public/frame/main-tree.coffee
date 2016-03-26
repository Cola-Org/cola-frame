cola((model)->
#	menuMode="tree"
	menuMode = "new"

	class TabManager
		constructor: ()->
			@_tabs = {}
		close: (path)->
			delete @_tabs[path]
		open: (data)->
			path = data.path
			viewTab = cola.widget("viewTab")
			if path
				if @_tabs[path]
					tab = viewTab.getTab(path)
					viewTab.setCurrentTab(tab)
				else
					if data.type != "subWindow"
						window.open(data.path)
						return
					tab = new cola.TabButton({
						afterClose: (self, arg)=> @.close(self.get("name"))
						content: {
							$type: "iFrame"
							path: data.path
						}
						icon: data.icon
						name: path
						closeable: data.closeable or true
						caption: data.label
					})
					viewTab = cola.widget("viewTab")
					@_tabs[path] = tab
					viewTab.addTab(tab)
					viewTab.setCurrentTab(tab)

	tabManager = new TabManager()

	menus = [
		{
			icon: "iconfont icon-zhandianshezhi"
			label: "全局设置"
			menus: [
				{
					icon: "iconfont icon-zhuye"
					label: "系统管理"
					type: "newWindow"
					path: "/framework/main"
					target: ""
					closeable: true
				}
				{
					icon: "iconfont icon-zhuye"
					label: "产品维护"
					type: "subWindow"
					path: "/example/product"
					target: ""
					closeable: true
				}
				{
					icon: "iconfont icon-ic10"
					label: "站点功能"
				}
				{
					icon: "iconfont icon-neirongshezhi"
					label: "内容设置"
					menus: [
						{
							icon: "iconfont icon-yonghuliebiao"
							label: "导航设置"
						}
						{
							icon: "iconfont icon-yonghuguanli"
							label: "分类管理"
							menus: [
								{
									icon: "iconfont icon-yonghuliebiao"
									label: "用户列表"
								}
								{
									icon: "iconfont icon-yonghuguanli"
									label: "用户组"
								}
								{
									icon: "iconfont icon-zhucerenzheng"
									label: "职位管理"
								}
								{
									icon: "iconfont icon-zhandianshezhi"
									label: "批量邀请"
								}
							]
						}
						{
							icon: "iconfont icon-zhucerenzheng"
							label: "专题管理"
						}
					]
				}
				{
					icon: "iconfont icon-yonghuguanli"
					label: "用户权限"
				}
				{
					icon: "iconfont icon-mail-setting"
					label: "邮件设置"
				}
			]
		},
		{
			icon: "iconfont icon-yonghuguanli"
			label: "用户管理"
			menus: [
				{
					icon: "iconfont icon-yonghuliebiao"
					label: "用户列表"
				}
				{
					icon: "iconfont icon-yonghuguanli"
					label: "用户组"
				}
				{
					icon: "iconfont icon-zhucerenzheng"
					label: "职位管理"
				}
				{
					icon: "iconfont icon-zhandianshezhi"
					label: "批量邀请"
				}
			]
		}
	]

	recursive = (d)->
		if d.menus
			d.hasChild = true
			recursive(item) for item in d.menus
		else
			d.hasChild = false

	recursive(menu) for menu in menus

	model.set("menus", menus)
	model.set("user", {
		name: "Alex Tong"
		avatar: "/resources/images/avatars/alex.png"
		messageCount: 8
		taskCount: 22
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
		menuTree:
			$type: "tree",
			autoExpand:true,
			autoCollapse:false,
			bind:
				hasChildProperty: "hasChild"
				expression: "menu in menus"
				child:
					recursive: true,
					hasChildProperty: "hasChild",
					expression: "menu in menu.menus"


	})
	model.action({
		showUserSidebar: ()->
			cola.widget("userSidebar").show()
		menuItemClick: (item)->
			data = item.toJSON()
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
				tabManager.open(data)

		hideSubMenuLayer: ()->
			cola.widget("subMenuLayer").hide()
		toggleSidebar: ()->
			className = "collapsed"
			$dom = $("#frameworkSidebarBox")
			$dom.toggleClass(className, !$dom.hasClass(className));
	})


	if menuMode == "tree"
		domConfig = []
		for menu in menus
			domConfig.push(makeMenuItemDom(menu))
		fragment = $.xCreate(domConfig)
		$("#frameworkSidebar").append(fragment).accordion({exclusive: false})
	else
		$("#frameworkSidebar").accordion({exclusive: false})
)