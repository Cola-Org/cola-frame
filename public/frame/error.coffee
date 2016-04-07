cola((model)->
	waitingTime = 15
	model.set("timer", waitingTime)
	homePath = App.prop("mainView")

	model.set("home", homePath)
	$("#timeProgress").progress({
		total: waitingTime
	})

	value = 1
	setInterval(()->
		value++
		if value >= waitingTime
			window.location = homePath
		model.set("timer", waitingTime - value)
		$("#timeProgress").progress({
			value: Math.round(value / waitingTime * 10000) / 100.00
		})
	, 1000)
)

