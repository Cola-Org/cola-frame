cola((model)->
	model.dataType({
		name: "Product",
		properties: {
			productName: {validators: ["required"]},
			id: {
				dataType: "number"
			},
			categoryId: {
				dataType: "number"
			},
			quantityPerUnit: {
				dataType: "number"
			},
			unitPrice: {
				dataType: "number"
			},
			unitsInStock: {
				dataType: "number"
			},
			unitsOnOrder: {
				dataType: "number"
			}
		}
	});

	model.dataType({
		name: "Category",
		properties: {
			categoryName: {validators: ["required"]},
			products: {
				dataType: "Product",
				provider: {
					url: "/service/product/",
					pageSize: 5
					beforeSend: (self, arg)->
						arg.options.data.categoryId = arg.model.get("categorys.id")
						NProgress.start();
					complete: (sefl, arg)->
						NProgress.done();
				}
			}
		}
	});
	model.describe("categorys", {
		dataType: "Category",
		provider:
			url: "/service/category/"
			pageSize: 5
	})
	model.describe("customProduct", "Product")
	model.describe("customCategory", "Category")
	model.describe("products", [])
	model.action({
		addCategory: ()->
			model.set("customCategory", {
			})
			cola.widget("categoryLayer").show()

		addProduct: ()->
			current = model.get("categorys").current;
			model.set("customProduct", {
				categoryId: current.get("id")
			})
			cola.widget("productLayer").show()
		productCancel: ()->
			model.set("customProduct", {})
			cola.widget("productLayer").hide()
		productSave: ()->
			product = model.get("customProduct")
			result = product.validate()

			if result
				data = product.toJSON()
				NProgress.start()
				$.ajax("./service/product/", {
					data: JSON.stringify(data),
					type: if data.id then "PUT" else "POST",
					contentType: "application/json",
					complete: ()->
						model.get("categorys").current.get("products").flush();
						cola.widget("productLayer").hide();
						NProgress.done()
				})
		categoryCancel: ()->
			model.set("customCategory", {})
			cola.widget("categoryLayer").hide()
		categorySave: ()->
			category = model.get("customCategory")
			result = category.validate()
			if result
				data = category.toJSON()
				console.log(data)
				NProgress.start()
				$.ajax("./service/category/", {
					data: JSON.stringify(data),
					type: if data.id then "PUT" else "POST",
					contentType: "application/json",
					complete: ()->
						cola.widget("categoryLayer").hide();
						NProgress.done()
				})

	})
	model.widgetConfig({
		productLayer: {
			$type: "Layer"
		}
		categoryLayer: {
			$type: "Layer"
		}
		categoryList: {
			$type: "table",
			bind: "item in categorys",
			showHeader: true,

			columns: [
				{
					bind: ".id"
					caption: "分类编号"
				},
				{
					bind: ".categoryName"
					caption: "分类名"
				},
				{
					bind: ".description"
					caption: "描述信息"
				}
			],
			currentPageOnly: true,
			autoLoadPage: false,
			changeCurrentItem: true,
			highlightCurrentItem: true
		}
		productList: {
			$type: "table",
			bind: "item in categorys.products",
			showHeader: true,
			columns: [
				{
					bind: ".id"
					caption: "编号"
				},
				{
					bind: ".productName"
					caption: "产品名称"
				},
				{
					bind: ".quantityPerUnit"
					caption: "规格"
				},
				{
					bind: ".unitPrice"
					caption: "单价"
				},
				{
					bind: ".unitsInStock"
					caption: "库存"
				},
				{
					bind: ".unitsOnOrder"
					caption: "订单量"
				}
			]
		}
		productPager: {
			$type: "pager"
			bind: "categorys.products"
		}
		categoryPager: {
			$type: "pager"
			bind: "categorys"
		}
	});

	window.cModel = model;
)