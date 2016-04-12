cola((model)->
	$(".ui.accordion").accordion({exclusive: false})

	model.describe("items", {
		provider:
			url: "/service/products"
			pageSize: 4
	})
	model.set("customItem", {})

	model.action({
		getColor: (status)->
			if status is "完成"
				return "positive-text"
			else
				return "negative-text"
		add: ()->
			newItem = model.get("items").insert()

			cola.widget("editLayer").show()
		edit: ()->
			cola.widget("editLayer").show()
		back:()->
			cola.widget("editLayer").hide()
	})
	model.widgetConfig({
		editLayer: {
			$type: "layer"
			width: "100%"
			onShow: ()->
				$("#mainView").hide()
			beforeHide: ()->
				$("#mainView").show()
		}
		productTable: {
			$type: "table",
			bind: "item in items",
			showHeader: true,
			height: 500
			columns: [{
				$type: "select"
			}, {
				caption: "已跟次数",
				template: "ygCount"
			}, {
				caption: "催收状态",
				template: "csStatus"
			}, {
				caption: "待跟进日",
				template: "dgDate"
			}, {
				caption: "委托方",
				template: "wtf"
			}, {
				caption: "受理方",

				template: "slf"
			}, {
				caption: "委案日期",
				template: "waDate"
			}, {
				caption: "剩余天数",
				template: "syDay"
			}, {
				caption: "委案金额",
				template: "waje"
			}, {
				caption: "已还金额",
				template: "yhje"
			}, {
				caption: "期数",
				template: "qs"
			}, {
				caption: "姓名",
				template: "name"
			}, {
				caption: "证件号",
				template: "id"
			}, {
				caption: "卡号",
				template: "cardNo"
			}, {
				caption: "地区",
				template: "region"
			}, {
				caption: "催收组",
				template: "csz"
			}, {
				caption: "催收员",
				template: "csy"
			}]
		}
	});
)