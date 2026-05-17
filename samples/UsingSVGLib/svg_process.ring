load "svglib.ring"

svg = new SVGWriter(500, 150)
svg.setBackground("white")

colors = ["#4CAF50", "#2196F3", "#FF9800", "#9C27B0"]
labels = ["Start", "Process", "Review", "Complete"]

for i = 1 to 4
    x = 20 + (i-1) * 120
    svg.addFlowchartBox(labels[i], x, 50, 90, 50, [
        :type = "rounded",
        :fill = colors[i]
    ])

    if i < 4
        svg.addConnector(x + 90, 75, x + 120, 75, [:arrow = true])
    ok
next

svg.save("process.svg")
