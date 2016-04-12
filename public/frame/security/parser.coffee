cola((model)->
	addable = (node)->
		return  node.nodes.length >= 1 or node.id or node.comment

	recursive = (childNode)->
		nodes = []
		child = childNode.firstChild
		comment = ""
		while child
			if child.nodeType == 8
				comment = child.nodeValue
			else if child.nodeType == 1
				n = makeNode(child,comment)
				addable(n) and nodes.push(n)
				comment = ""

			child = child.nextSibling
		return nodes

	makeNode = (element, comment)->
		result =
			tagName: element.nodeName
			comment: comment
			nodes: recursive(element)
			id: element.id
			visible: true
			editable: true
			nodeType: element.nodeType

		if result.tagName is "TEMPLATE"
			result.name = element.getAttribute("name")

		return result

	makeBody = (nodes)->
		body =
			tagName: "body"
			nodes: []
		comment = ""
		for child in nodes
			if child.nodeType == 8
				comment = child.nodeValue
			else if child.nodeType == 1
				node = makeNode(child, comment)
				addable(node) and body.nodes.push(node)
				comment = ""
		console.log()
		return body

	model.set("nodeList", [])
	$.ajax("./service/cola/load-body", {}).done((result)->
		nodes = jQuery.parseHTML(result)
		body = makeBody(nodes)
		model.set("node", body)
		components = []
		findComponent = (el)->
			if el.id
				components.push(el)
			for n in el.nodes
				findComponent(n)
		for n in body.nodes
			findComponent(n)

		model.set("nodeList", components)
	)

	model.set("node", {
		tagName: "body"
		nodes: []
	})

	model.action({
		switchView: (self, arg)->
			index = parseInt(self.get("userData"))
			nodeList = model.get("nodeList")
			body = model.get("node")
			if index
				handler = (el)->
					id = el.get("id")
					nodeList.each((n)->
						if n.get("id") == id
							n.set("visible", el.get("visible"))
							n.set("editable", el.get("editable"))
							return false
					)
				findComponent = (el)->
					id = el.get("id")
					if id then handler(el)
					el.get("nodes")?.each(findComponent)

				body.get("nodes").each(findComponent)
			else
				mapping = {}
				findComponent = (n)->
					id = n.get("id")
					if id then mapping[id] = n
					n.get("nodes").each(findComponent)
				body.get("nodes").each(findComponent)

				nodeList.each((el)->
					id = el.get("id")
					target = mapping[id]
					if target
						target.set("visible", el.get("visible"))
						target.set("editable", el.get("editable"))
				)
			cola.widget("cardBookDataView").setCurrentIndex(index)
		save: ()->
			index = cola.widget("cardBookDataView").getCurrentIndex()
			list = []
			pushElement = (el)->
				list.push({
					id: el.id
					visible: el.visible
					editable: el.editable
				})
			if index == 0
				body = model.get("node").toJSON()
				recursiveMakeList = (el)->
					if el.id then pushElement(el)
					recursiveMakeList(childNode) for childNode in el.nodes
				recursiveMakeList(childNode) for childNode in body.nodes
			else
				pushElement (item) for item in model.get("nodeList").toJSON()
			console.log(list)

		getNodeName: (node)->
			id = node.get("id")
			tagName = node.get("tagName")
			comment = node.get("comment")
			nodeName = ""
			if id
				nodeName = "#{tagName}##{id}"
			else
				nodeName = tagName
			if comment then nodeName += comment
			return nodeName
	})


	model.widgetConfig({
		domTree:
			$type: "Tree"
			height: "100%"
			autoCollapse: false,
			autoExpand: true,
			bind:
				recursive: true,
				expression: "node in node.nodes"
			itemClick: (self, arg)->
				self.get$Dom().find(".current-node").removeClass("current-node")
				$(arg.dom).addClass("current-node")
		domList:
			$type: "listView"
			bind: "node in nodeList"
			textProperty: "id"
	})
	NProgress.done()
)