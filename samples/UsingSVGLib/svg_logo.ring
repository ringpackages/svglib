load "svglib.ring"

svg = new SVGWriter(200, 200)
svg.setBackground("white")

grad = svg.createRadialGradient(100, 30, 100, [
    [0,   "#4FC3F7"],
    [100, "#0288D1"]
])
svg.addCircle(100, 100, 100, [:fill = grad])
svg.addTextCentered("Ring", 100, 115, [:fill = "white", :fontSize = 72, :fontWeight = "bold"])

svg.save("logo.svg")