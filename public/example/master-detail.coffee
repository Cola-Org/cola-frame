cola((model)->
	$(".ui.accordion").accordion({exclusive: false})
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
			products: {
				dataType: "Product",
				provider: {
					url: "/service/product/?categoryId={id}",
					pageSize: 5
					beforeSend: (self, arg)->
						NProgress.start();
					success: (self, arg)->
						model.set("products", model.get("categorys").current.get("products"))
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
	model.describe("products", [])
	model.action({
		addCategory: ()->
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
			console.log(result)
			if result
				data = product.toJSON()
#				NProgress.start()
#				$.ajax("./service/product/", {
#					data: JSON.stringify(data),
#					type: if data.id then "PUT" else "POST",
#					contentType: "application/json",
#					complete: ()->
#						model.get("categorys").current.get("products").flush();
#						cola.widget("productLayer").hide();
#						NProgress.done()
#				})
	})
	model.widgetConfig({
		categoryList: {
			$type: "table",
			bind: "item in categorys",
			showHeader: true,

			columns: [
				{
					bind: ".id"
				},
				{
					bind: ".categoryName"
				},
				{
					bind: ".description"
				}
			],
			currentPageOnly: true,
			autoLoadPage: false,
			highlightCurrentItem: true,
			renderRow: (self, arg)->
				$fly(arg.dom).click(()->
					products = arg.item.get("products")
					model.get("categorys").setCurrent(arg.item);
					products = products or []
					model.set("products", products)
				)
		}
		productList: {
			$type: "table",
			bind: "item in products",
			showHeader: true,
			columns: [
				{
					bind: ".id"
				},
				{
					bind: ".productName"
				},
				{
					bind: ".quantityPerUnit"
				},
				{
					bind: ".unitPrice"
				},
				{
					bind: ".unitsInStock"
				},
				{
					bind: ".unitsOnOrder"
				}
			]
		}
		productPager: {
			$type: "pager"
			bind: "products"
		}
		categoryPager:{
			$type: "pager"
			bind: "categorys"
		}
	});

	window.cModel = model;
)