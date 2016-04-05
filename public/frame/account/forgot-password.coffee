cola((model)->
	model.describe(
		userName:
			validators: {$type: "required", message: ""}
		password:
			validators: {$type: "required", message: ""}
	)
	mainPath = "#{window.location.origin}#{App.prop("mainView")}"
	model.set("userName", $.cookie("_userName"), {path: "/"})

	showMessage = (content)->
		cola.widget("formSignIn").setMessages([{
			type: "error"
			text: content
		}])
	submit = ()->
		data = model.get()
		cola.widget("containerSignIn").addClass("loading")
		$.ajax({
			type: "POST",
			url: App.prop("service.login")
			data: JSON.stringify(data.toJSON())
			contentType: "application/json"
		}).done((result) ->
			cola.widget("containerSignIn").removeClass("loading")
			unless result.type
				showMessage(result.message)
				return
			if model.get("cacheInfo") then  $.cookie("_userName", model.get("userName"), {path: "/", expires: 365})
			window.location = mainPath
		).fail(() ->
			cola.widget("containerSignIn").removeClass("loading")
			return
		)
	model.action({
		signIn: () ->
			cola.widget("formSignIn").setMessages(null)
			data = model.get()
			if data.validate()
				submit()
			else
				showMessage("用户名或密码不能为空！")

	})
)