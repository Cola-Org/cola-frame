cola((model)->
	model.set("node", [
		{
			name: "name1",
			nodes: [
				{name: "name1-0"},
				{name: "name1-1"},
				{name: "name1-2"},
				{name: "name1-3"},
				{name: "name1-4"},
			]
		},
		{
			name: "name2",
			nodes: [
				{
					name: "name2-0",
					nodes: [
						{name: "name2-1-0"},
						{name: "name2-1-1"},
						{name: "name2-1-2"},
						{name: "name2-1-3"},
						{name: "name2-1-4"},
					]
				},
				{name: "name2-1"},
				{name: "name2-2"},
				{name: "name2-3"},
				{name: "name2-4"},
			]
		}
		{
			name: "name3",
			nodes: [
				{name: "name3-0"},
				{name: "name3-1"},
				{name: "name3-2"},
				{name: "name3-3"},
				{name: "name3-4"},
			]
		}
		{
			name: "name4",
			nodes: [
				{name: "name4-0"},
				{name: "name4-1"},
				{name: "name4-2"},
				{name: "name4-3"},
				{name: "name4-4"},
			]
		}
	])

	model.widgetConfig({
		TreeDemo: {
			$type: "Tree"
			height: "100%"
			autoCollapse: false,
			autoExpand: true,
			bind:
				recursive: true,
				textProperty: "name"
				expression: "node in node.nodes"

		}

	});
)