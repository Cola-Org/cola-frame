cola((model)->
	$(".ui.accordion").accordion({exclusive: false})

	model.describe("employees", {
		dataType:
			name: "Employee",
			properties: {
				lastName: {
					validators: ["required", {$type: "length", min: 4, max: 20}]
				},
				firstName: {
					validators: ["required", {$type: "length", min: 4, max: 20}]
				},
				sex: {dataType: "boolean", defaultValue: true, validators: ["required"]},
				birthDate: {dataType: "date"},
				hireDate: {dataType: "date"},
				phone: {validators: ["required"]}
			}
		provider:
			name: "provider1"
			url: "./service/employee/"
			pageSize: 4
			beforeSend: (self, arg)->
				data = arg.options.data
				contain = model.get("contain")

				data.contain=contain
	})
	model.set("countries", [
		{name:"中国"},
		{name:"美国"},
		{name:"加拿大"},
		{name:"印度尼西亚"},
		{name:"马来西亚"},
		{name:"英国"},
		{name:"韩国"},
		{name:"蒙古国"},
		{name:"俄罗斯"}
	])
	model.describe("editItem", "Employee");
	model.action({
		getColor: (status)->
			if status is "完成"
				return "positive-text"
			else
				return "negative-text"
		search: ()->
			model.get("employees").flush()

		add: ()->
			model.set("editItem", {
				sex:true
			})
			cola.widget("editLayer").show()
		edit: (item)->
			model.set("editItem", item.toJSON());
			cola.widget("editLayer").show()
		cancel: ()->
			cola.widget("editLayer").hide()
		ok: ()->
			debugger
			editItem = model.get("editItem")
			validate = editItem.validate()
			console.log(validate)
			if validate
				id = editItem.get("id")
				data = editItem.toJSON()
				NProgress.start()
				$.ajax("./service/employee/", {
					data: JSON.stringify(data),
					type: if data.id then "PUT" else "POST",
					contentType: "application/json",
					complete: ()->
						cola.widget("editLayer").hide();
						NProgress.done()
				})
		del: (item)->
			item.remove();
#			此处编写调用后台直接删除
	})
	model.widgetConfig({
		radioGroup: {
			items: [{
				value: true,
				label: "男"
			}, {
				value: false,
				label: "女"
			}]
		},

		editLayer: {
			$type: "layer"
			width: "100%"
			onShow: ()->
				$("#mainView").hide()
			beforeHide: ()->
				$("#mainView").show()
		}
		shopDropDown: {
			$type: "dropdown",
			class: "error",
			openMode: "drop",
			items: "{{shop in shops}}",
			valueProperty: "name",
			bind: "editItem.shop"
		}
		birthDatePicker:{
			$type:"datePicker"
			bind:"editItem.birthDate"
		}
		hireDatePicker:{
			$type:"datePicker"
			bind:"editItem.hireDate"
		}
		countryDropDown:{
			$type: "dropdown",
			class: "error",
			openMode: "drop",
			items: "{{country in countries}}",
			valueProperty: "name",
			bind:"editItem.country"
		}

		employeeTable: {
			$type: "table", showHeader: true,
			bind: "item in employees",
			highlightCurrentItem: true,
			currentPageOnly: true,
			columns: [{
				bind: ".id", caption: "ID"
			}, {
				bind: ".lastName", caption: "Last Name"
			}, {
				bind: ".firstName", caption: "First Name"
			}, {
				bind: ".title", caption: "Title"
			}, {
				bind: ".titleOfCourtesy", caption: "Title Of Courtesy"
			}, {
				bind: ".sex", caption: "Sex"
			}, {
				bind: "formatDate(employee.birthDate, 'yyyy-MM-dd')", caption: "Birthday"
			}, {
				bind: ".phone", caption: "phone"
			}, {
				caption: "Operation", align: "center", template: "operations"
			}]
		}
	});
)