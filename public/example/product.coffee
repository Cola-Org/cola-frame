cola((model)->
	$(".ui.accordion").accordion({exclusive: false})

	model.describe("items", {
		provider:
			url: "/service/products"
	})

	model.action({
		getColor:(status)->
			if status is "完成"
				return "positive-text"
			else
				return "negative-text"
	})
	model.widgetConfig({
		productTable: {
			$type: "table",
			bind: "item in items",
			showHeader: true,
			height:500
			columns: [{
				$type: "select"
			}, {
				caption: "已跟次数",
				bind: "item.ygCount+'次'"

			}, {
				caption: "催收状态",
				template: "csStatus"
				align:"center"
			}, {
				caption: "待跟进日",
				bind: ".dgDate"
			}, {
				caption: "委托方",
				bind: ".wtf"
			},{
				caption: "受理方",

				bind: ".slf"
			},{
				caption: "委案日期",
				bind: ".waDate"
			},{
				caption: "剩余天数",
				bind: "item.syDay+'天'"
			},{
				caption: "委案金额",
				bind: "formatNumber(item.waje,'¥##,###.00')"
			},{
				caption: "已还金额",
				bind: "formatNumber(item.yhje,'¥##,###.00')"
			},{
				caption: "期数",
				bind: "item.qs+'期'"
			},{
				caption: "姓名",
				bind: ".name"
			},{
				caption: "证件号",
				bind: ".id"
			},{
				caption: "卡号",
				bind: ".cardNo"
			},{
				caption: "地区",
				bind: ".region"
			},{
				caption: "催收组",
				bind: ".csz"
			},{
				caption: "催收员",
				bind: ".csy"
			}]
		}
	});
)