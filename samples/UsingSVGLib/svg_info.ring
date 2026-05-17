load "svglib.ring"

svg = new SVGWriter(400, 300)
svg.setBackground("#F5F5F5")

svg.addText("Q4 Results", 20, 30, [:fontSize = 20, :fontWeight = "bold", :fill = "#333"])

shadow = svg.createShadowFilter(2, 2, 3, "#CCC")

svg.addRoundedRect(20, 50, 110, 70, 5, [:fill = "white", :filter = shadow])
svg.addText("Revenue", 35, 75,  [:fontSize = 12, :fill = "#1565C0"])
svg.addText("$1.2M",   35, 100, [:fontSize = 18, :fontWeight = "bold", :fill = "#333"])

svg.addRoundedRect(145, 50, 110, 70, 5, [:fill = "white", :filter = shadow])
svg.addText("Growth", 160, 75,  [:fontSize = 12, :fill = "#2E7D32"])
svg.addText("+24%",   160, 100, [:fontSize = 18, :fontWeight = "bold", :fill = "#333"])

data = [:labels = ["Jan", "Feb", "Mar"], :values = [30, 45, 60]]
svg.addBarChart(data, 20, 140, 360, 140, [:title = "Monthly Trend"])

svg.save("infographic.svg")