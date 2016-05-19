cola((model)->
	model.set("categorise", [
		{id: 1, name: "休闲零食"}
		{id: 2, name: "服装鞋帽"}
		{id: 3, name: "运动器材"}
		{id: 4, name: "通讯器材"}
		{id: 5, name: "电脑配件"}
	])
	model.set("product", {})
	model.set("products", [
		{categoryId: 1, name: "核桃干"}
		{categoryId: 2, name: "耐克篮球鞋"}
		{categoryId: 3, name: "YY羽毛球拍"}
		{categoryId: 4, name: "小米手机"}
		{categoryId: 5, name: "散热器"}

	])
	model.widgetConfig({
		MappingDropDown: {
			$type: "dropdown",
			bind: "product.categoryId",
			items: "{{category in categorise}}",
			valueProperty: "id",
			textProperty: "name"
		}
		ProductTable:
			$type: "Table"
			height: "100%",
			bind: "item in products",
			columns: [
				{
					bind: "translate(item.categoryId)", caption: "分类"
				},
				{
					bind: ".name", caption: "名称"
				}
			]
	})
	model.action({
		translate: (id)->
			result=id
			model.get("categorise").each((category)->
				if category.get("id") == id
					result=category.get("name")
					return false;
			)
			return result
		showValue: ()->
			cola.alert(model.get("product.categoryId"))
	})
)