cola((model)->
	model.describe("products", {
		dataType:
			name: "Product",
			properties:
				name:
					validators: ["required"]
				price:
					dataType: "number"
		provider:
			name: "provider1"
			url: "/service/product/?categoryId=1"
			pageSize: 10
	})

	model.action({
		getSelections: ()->
			count = 0;
			model.get("products").each((product)->
				if product.get("selected") then count++
			)

			cola.alert("用户选择了#{count}")
		selectable: (item)->
			return item.get("id") % 2 > 0
		blur: (self, arg)->
			self.get$Dom().closest(".product-price").removeClass("focus")
	})

	model.widgetConfig({
		productTable: {
			$type: "table",
			showHeader: true,
			bind: "item in products",
			highlightCurrentItem: true,
			currentPageOnly: true,
			height: "100%",
			columns: [
				{
					caption: "选择"
					template: "select"
				},
				{
					bind: ".id", caption: "产品编号"
				},
				{
					caption: "产品名称", bind: ".productName"
				},
				{
					bind: ".reorderLevel", caption: "订货量", align: "right"
				},
				{
					template: "price", caption: "价格", align: "center", class: "sss"
				},
				{
					bind: ".quantityPerUnit", caption: "经营商"
				}
			],
			renderCell: (self, arg)->
				caption = arg.column.get("caption")
				if arg.column.get("caption") == "价格"
					$(arg.dom).addClass("product-price")
					$(arg.dom).on("click", ()->
						$fly(arg.dom).addClass("focus")
						$input = $fly(arg.dom).find(".ui.input")
						cola.widget($input[0]).focus()
					)
				else if caption == "产品名称"
					$(arg.dom).parent().addClass("product-name")


			renderRow: (self, arg)->
				item = arg.item;
				rowDom = arg.dom;

				$fly(rowDom).addClass("product-item")
				$(arg.dom).delegate(".product-name", "click", ()->
					$rowDom = $(rowDom)
					nextIsDetail = $rowDom.next().hasClass("row-detail")
					oldNodes = $rowDom.parent().find(">.row-detail")
					oldNodes.prev().find(".product-name.expanded").removeClass("expanded")
					oldNodes.find('>td>div').animate({
							height: "0px"
						},
						()->
							oldNodes.remove()
					)
					if nextIsDetail then return
					context = {}
					innerDom = $.xCreate({
						tagName: "tr"
						class: "row-detail"
						content: [
							{
								tagName: "td"
								colspan: 6
								content: {
									tagName: "div"
									contextKey: "tablePane"
								}
							}
						]
					}, context)
					model.set("tempList", [
						{
							id: "01"
							name: "alex"
						}
					])

					oldSub = model.get("subProducts")
					model.set("employeeId", "23523678")
					if oldSub
						oldSub.flush()
					else
						model.describe("subProducts", {
							provider:
								url: "/service/employee/?id={{employeeId}}"
								pageSize: 10
						})

					table = new cola.Table({
						height: "100%",
						bind: "item in subProducts",
						columns: [
							{
								bind: ".id", caption: "编号"
							},
							{
								bind: ".lastName", caption: "名称"
							}
						]
					})
					$rowDom.after(innerDom);
					$rowDom.find(".product-name").addClass("expanded")
					$(innerDom).find(">td>div").animate({
							height: "200px"
						}
					)
					table.appendTo(context.tablePane)
				)
		}
	});
)