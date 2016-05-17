module.exports = [
	{
		icon: "icon browser",
		label: "全局设置",
		menus: [
#			{
#				icon: "icon setting",
#				label: "权限配置",
#				type: "subWindow",
#				path: "/frame/security/parser",
#				closeable: true
#			},
#			{
#				icon: "icon setting",
#				label: "主从表示例",
#				type: "subWindow",
#				path: "/example/master-detail",
#				closeable: true
#			},
			{
				icon: "iconfont icon-shoudan",
				label: "催收管理",
				type: "subWindow",
				path: "/example/product",
				closeable: true
			}, {
				icon: "iconfont icon-ic10",
				label: "时间线",
				type: "subWindow",
				path: "/example/time-line"
			},
			{
				icon: "iconfont icon-ic10",
				label: "产品维护",
				type: "subWindow",
				path: "/example/crud"
			},
			{
				icon: "iconfont icon-ic10",
				label: "内部打开",
				type: "subWindow",
				path: "/example/inner-open"
			},
			{
				icon: "iconfont icon-neirongshezhi",
				label: "内容设置",
				menus: [
					{
						icon: "iconfont icon-yonghuliebiao",
						label: "导航设置"
					}, {
						icon: "iconfont icon-yonghuguanli",
						label: "分类管理",
						menus: [
							{
								icon: "iconfont icon-yonghuliebiao",
								label: "用户列表",path: "/example/time-line"
							}, {
								icon: "iconfont icon-yonghuguanli",
								label: "用户组"
							}, {
								icon: "iconfont icon-zhucerenzheng",
								label: "职位管理"
							}
						]
					}, {
						icon: "iconfont icon-zhucerenzheng",
						label: "专题管理"
					}
				]
			}, {
				icon: "iconfont icon-1305quanxianshezhi",
				label: "用户权限"
				menus: [
					{
						icon: "iconfont icon-zhandianshezhi",
						label: "批量邀请"
					},
					{
						icon: "iconfont icon-yonghuliebiao",
						label: "用户列表"
					}, {
						icon: "iconfont icon-yonghuguanli",
						label: "用户组"
					}, {
						icon: "iconfont icon-zhucerenzheng",
						label: "职位管理"
					}, {
						icon: "iconfont icon-zhandianshezhi",
						label: "批量邀请"
					}, {
						icon: "iconfont icon-yonghuliebiao",
						label: "用户列表"
					}, {
						icon: "iconfont icon-yonghuguanli",
						label: "用户组"
					}, {
						icon: "iconfont icon-zhucerenzheng",
						label: "职位管理"
					}, {
						icon: "iconfont icon-zhandianshezhi",
						label: "批量邀请"
					}, {
						icon: "iconfont icon-yonghuliebiao",
						label: "用户列表"
					}, {
						icon: "iconfont icon-yonghuguanli",
						label: "用户组"
					}, {
						icon: "iconfont icon-zhucerenzheng",
						label: "职位管理"
					}, {
						icon: "iconfont icon-zhandianshezhi",
						label: "批量邀请"
					}
				]

			}, {
				icon: "iconfont icon-mail-setting",
				label: "邮件设置"
			}
		]
	}, {
		icon: "iconfont icon-yonghuguanli",
		label: "用户管理",
		menus: [
			{
				icon: "iconfont icon-yonghuliebiao",
				label: "用户列表"
			}, {
				icon: "iconfont icon-yonghuguanli",
				label: "用户组"
			}, {
				icon: "iconfont icon-zhucerenzheng",
				label: "职位管理"
			}, {
				icon: "iconfont icon-03",
				label: "批量邀请"
			}
		]
	}
];
