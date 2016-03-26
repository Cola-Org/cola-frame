module.exports = [
	{
		icon: "iconfont icon-zhandianshezhi",
		label: "全局设置",
		menus: [
			{
				icon: "iconfont icon-zhuye",
				label: "系统管理",
				type: "newWindow",
				path: "/frame/main",
				target: "",
				closeable: true
			}, {
				icon: "iconfont icon-shoudan",
				label: "催收管理",
				type: "subWindow",
				path: "/example/product",
				target: "",
				closeable: true
			}, {
				icon: "iconfont icon-ic10",
				label: "站点功能"
			}, {
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
						icon: "iconfont icon-zhucerenzheng",
						label: "专题管理"
					}
				]
			}, {
				icon: "iconfont icon-1305quanxianshezhi",
				label: "用户权限"
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
