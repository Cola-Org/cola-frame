win = window.parent
while win
	try
		if win.App
			rootApp = win.App
			rootWindow = win
			break
		if win == win.parent then break
		win = win.parent
	catch e

unless rootApp
	properties =
		mainView: "./frame/main"
		loginPath: "./login"
		longPollingTimeout: 0
		longPollingInterval: 2000
		"service.messagePull": "./service/message/pull"
		"service.login": "./service/account/login"
		"service.logout": "./service/account/logout"
		"service.menus": "./service/menus"
		"service.user.detail": "./service/user/detail"
		title: ""

App = window.App =
	_tabs: {}
	getRootWindow: ()->
		return if rootApp then rootWindow else window

	open: (path, config)->
		if rootApp
			rootApp.open.apply(path, config)
			return
		else
			viewTab = cola.widget("viewTab")
			if @_tabs[path]
				tab = viewTab.getTab(path)
				viewTab.setCurrentTab(tab)
				return
			else
				if config.type != "subWindow"
					window.open(path)
					return
				tab = new cola.TabButton({
					afterClose: (self, arg)=> @.close(self.get("name"))
					content:
						$type: "iFrame"
						path: config.path
					icon: config.icon
					name: path
					closeable: config.closeable or true
					caption: config.label
				})
				viewTab = cola.widget("viewTab")
				@_tabs[path] = tab
				viewTab.addTab(tab)
				viewTab.setCurrentTab(tab)
	close: (path)->
		delete @_tabs[path]
	goLogin: (callback)->
		if rootApp
			return rootApp.goLogin(callback)
		else
			login(callback)

	setTitle: (title)->
		document.title = title
	setFavicon: (path)->
		for rel in ["icon", "shortcut icon"]
			icon = $("link[rel='#{rel}']")
			if icon.length > 0
				icon.attr("href", path)
			else
				document.head.appendChild($.xCreate({
					tagName: "link"
					rel: "icon"
					href: path
				}))
	refreshMessage: ()->
		if rootApp
			rootApp.refreshMessage()
		else
			refreshMessage?()

	prop: (key, value)->
		if arguments.length == 1
			if typeof  key == "string"
				return properties[key]
			else if key
				for p in key
					if key.hasOwnProperty(p) then properties[p] = key[p]
		else
			properties[key] = value

title = App.getTitle("title")
if title then App.setTitle(title)
cola.defaultAction("setting", (key)->
	return App.prop(key)
)

cola.defaultAction("numberString", (number)->
	return ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve",
	        "thirteen", "fourteen", "fifteen", "sixteen"][number - 1];
)
$(document).ajaxError((event, jqXHR)->
	if jqXHR.status == 401
		App.goLogin();
		return false;
	else
		message = jqXHR.responseJSON;
		if message then throw new cola.Exception(message)
	return
);
language = $.cookie("_language") || window.navigator.language;

if language
	document.write("<script src=\"resources/cola-ui/i18n/#{language}/cola.js\"></script>");
	document.write("<script src=\"resources/i18n/#{language}/common.js\"></script>");

$(NProgress.done)
getAjaxID = (event)->
	id = ""
	for key,value of event
		if key.indexOf("jQuery") == 0
			id = key
			break
	if id
		unless parseInt(id.replace("jQuery", "")) > 0
			id = ""
	return id

startedAjaxList = [];

$(document).ajaxStart((event)->
	id = getAjaxID(event)
	startedAjaxList.push(id)
	unless NProgress.isStarted()
		NProgress.start()
)
$(document).ajaxComplete((event)->
	id = getAjaxID(event)
	index = startedAjaxList.indexOf(id)
	if index > -1 then startedAjaxList.splice(index, 1)
	if startedAjaxList.length == 0 then NProgress.done()
)

