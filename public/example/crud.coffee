cola((model)->
	$(".ui.accordion").accordion({exclusive: false})

	model.describe("products", {
		dataType:
			name: "Product",
			properties:
				id:
					validators: ["required"]
				name:
					validators: ["required"]
				price:
					dataType: "number"
		provider:
			name: "provider1"
			url: "/service/shoes"
			pageSize: 4
			beforeSend:(self,arg)->
				data=arg.options.data
				condition=model.get("condition")
				if condition
					condition=condition.toJSON()
					for key,value of condition
						if value
							data[key]=value
	})
	model.set("condition",{})
	model.describe("editItem", "Product");
	model.action({
		getColor: (status)->
			if status is "完成"
				return "positive-text"
			else
				return "negative-text"
		search:()->
			model.get("products").flush()

		add: ()->
			model.set("editItem", {})
			cola.widget("editLayer").show()
		edit: ()->
			item = model.get("products").current;
			model.set("editItem", item.toJSON());
			cola.widget("editLayer").show()
		cancel: ()->
			cola.widget("editLayer").hide()
		ok: ()->
			editItem = model.get("editItem")
			if editItem.validate()
				id = editItem.get("id")
				data = editItem.toJSON()
#				NProgress.start()
#				$.ajax("./service/product/", {
#					data: JSON.stringify(data),
#					type: if data.id then "PUT" else "POST",
#					contentType: "application/json",
#					complete: ()->
#						cola.widget("editLayer").hide();
#						NProgress.done()
#				})
		del: (item)->
			item.remove();
#			此处编写调用后台直接删除
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
			$type: "table", showHeader: true,
			bind: "item in products",
			highlightCurrentItem: true,
			currentPageOnly: true,
			columns: [{
				bind: ".id", caption: "产品编号"
			}, {
				bind: ".name", caption: "产品名称"
			}, {
				bind: "formatNumber(item.originalPrice, '¥#,##0.00')", caption: "原价", align: "right"
			}, {
				bind: "formatNumber(item.price, '¥#,##0.00')", caption: "价格", align: "right"
			}, {
				bind: ".shop", caption: "经营商"
			}, {
				caption: "操作", align: "center", template: "operations"
			}]
		}
	});
)