/*
    RingSVGLib Demo - SVG Graphics Creation in Ring
    ================================================
    This demo showcases various features of RingSVGLib
*/

load "ringsvglib.ring"

? "=============================================="
? "   RingSVGLib Demo - SVG Graphics in Ring"
? "=============================================="
? ""

# Demo 1: Basic Shapes
? "Demo 1: Creating basic shapes..."
svg = new SVGWriter(400, 300)
svg.setBackground("white")

svg.setFill("blue")
svg.addRect(20, 20, 80, 60, NULL)

svg.setFill("red")
svg.addCircle(180, 50, 40, NULL)

svg.setFill("green")
svg.addEllipse(300, 50, 50, 30, NULL)

svg.setFill("orange")
svg.addRoundedRect(20, 120, 80, 60, 10, NULL)

svg.setFill("purple")
svg.addTriangle(180, 100, 140, 180, 220, 180, NULL)

svg.setFill("teal")
svg.addPolygon([[280, 100], [320, 120], [340, 160], [300, 180], [260, 160]], NULL)

svg.setFill("crimson")
svg.addStar(70, 250, 40, 20, 5, NULL)

if svg.save("demo1_shapes.svg")
    ? "  Created: demo1_shapes.svg"
else
    ? "  FAILED: demo1_shapes.svg"
ok

# Demo 2: Lines and Strokes
? "Demo 2: Creating lines and strokes..."
svg = new SVGWriter(400, 300)
svg.setBackground("#F5F5F5")

svg.setStroke("black", 2)
svg.noFill()
svg.addLine(20, 30, 180, 30, NULL)

svg.setStroke("red", 3)
svg.addLine(20, 60, 180, 60, NULL)

svg.setStroke("blue", 4)
svg.setStrokeDash("10,5")
svg.addLine(20, 90, 180, 90, NULL)

svg.setStrokeDash("")
svg.setStroke("green", 3)
svg.setStrokeLineCap("round")
svg.addLine(20, 120, 180, 120, NULL)

svg.resetStyle()
svg.setStroke("coral", 3)
svg.noFill()
svg.addPolyline([[220, 30], [260, 70], [300, 40], [340, 80], [380, 50]], NULL)

svg.setStroke("maroon", 3)
svg.addArc(100, 220, 50, 0, 270, NULL)

if svg.save("demo2_lines.svg")
    ? "  Created: demo2_lines.svg"
else
    ? "  FAILED: demo2_lines.svg"
ok

# Demo 3: Text
? "Demo 3: Creating text elements..."
svg = new SVGWriter(400, 300)
svg.setBackground("white")

svg.setFill("black")
svg.addText("Hello, SVG World!", 20, 40, NULL)

svg.setFill("blue")
svg.addText("Bold Text", 20, 80, [:fontWeight = "bold"])

svg.setFill("green")
svg.addText("Italic Text", 20, 120, [:fontStyle = "italic"])

svg.setFill("red")
svg.addText("Large Text", 20, 170, [:fontSize = 28])

svg.setFill("purple")
svg.addText("Custom Font", 20, 210, [:fontFamily = "Georgia, serif", :fontSize = 20])

svg.setFill("orange")
svg.addTextCentered("Centered Text", 200, 260, [:fontSize = 18])

svg.setFill("teal")
svg.addMultilineText(["Line 1: Hello", "Line 2: World", "Line 3: SVG!"], 280, 40, 20, [:fontSize = 14])

if svg.save("demo3_text.svg")
    ? "  Created: demo3_text.svg"
else
    ? "  FAILED: demo3_text.svg"
ok

# Demo 4: Gradients
? "Demo 4: Creating gradients..."
svg = new SVGWriter(400, 300)
svg.setBackground("white")

grad1 = svg.createLinearGradient(0, 0, 100, 0, [[0, "blue"], [100, "cyan"]])
svg.setFill(grad1)
svg.addRect(20, 20, 150, 80, NULL)

grad2 = svg.createLinearGradient(0, 0, 0, 100, [[0, "red"], [50, "yellow"], [100, "orange"]])
svg.setFill(grad2)
svg.addRect(200, 20, 150, 80, NULL)

grad3 = svg.createLinearGradient(0, 0, 100, 100, [[0, "purple"], [100, "pink"]])
svg.setFill(grad3)
svg.addRect(20, 130, 150, 80, NULL)

grad4 = svg.createRadialGradient(50, 50, 50, [[0, "white"], [100, "green"]])
svg.setFill(grad4)
svg.addCircle(320, 170, 60, NULL)

if svg.save("demo4_gradients.svg")
    ? "  Created: demo4_gradients.svg"
else
    ? "  FAILED: demo4_gradients.svg"
ok

# Demo 5: Patterns
? "Demo 5: Creating patterns..."
svg = new SVGWriter(400, 300)
svg.setBackground("white")

stripes = svg.createStripePattern(10, "blue", "white", 45)
svg.setFill(stripes)
svg.addRect(20, 20, 150, 100, NULL)

dots = svg.createDotPattern(15, 3, "red", "white")
svg.setFill(dots)
svg.addRect(200, 20, 150, 100, NULL)

grid = svg.createGridPattern(20, 1, "#CCCCCC", "white")
svg.setFill(grid)
svg.addRect(20, 150, 150, 100, NULL)

hStripes = svg.createStripePattern(8, "green", "lightgreen", 0)
svg.setFill(hStripes)
svg.addCircle(320, 200, 60, NULL)

if svg.save("demo5_patterns.svg")
    ? "  Created: demo5_patterns.svg"
else
    ? "  FAILED: demo5_patterns.svg"
ok

# Demo 6: Filters (Effects)
? "Demo 6: Creating filter effects..."
svg = new SVGWriter(400, 250)
svg.setBackground("white")

blur = svg.createBlurFilter(3)
svg.setFill("blue")
svg.addRect(20, 20, 100, 60, [:filter = blur])
svg.addRect(20, 100, 100, 60, NULL)
svg.setFill("black")
svg.addText("Blur vs Normal", 20, 180, [:fontSize = 12])

shadow = svg.createShadowFilter(4, 4, 3, "gray")
svg.setFill("red")
svg.addRect(200, 20, 100, 60, [:filter = shadow])
svg.setFill("black")
svg.addText("Drop Shadow", 200, 100, [:fontSize = 12])

glow = svg.createGlowFilter(5, "yellow")
svg.setFill("orange")
svg.addCircle(250, 180, 35, [:filter = glow])

if svg.save("demo6_filters.svg")
    ? "  Created: demo6_filters.svg"
else
    ? "  FAILED: demo6_filters.svg"
ok

# Demo 7: Transformations
? "Demo 7: Creating transformations..."
svg = new SVGWriter(400, 250)
svg.setBackground("#F0F0F0")

svg.setFill("blue")
svg.addRect(20, 20, 60, 40, NULL)
svg.setFill("black")
svg.addText("Original", 20, 80, [:fontSize = 10])

svg.setFill("red")
svg.addRect(20, 20, 60, 40, [:translate = [100, 0]])
svg.addText("Translated", 120, 80, [:fontSize = 10])

svg.setFill("green")
svg.addRect(250, 50, 60, 40, [:rotate = [30, 280, 70]])
svg.addText("Rotated", 250, 120, [:fontSize = 10])

svg.setFill("purple")
svg.addRect(20, 150, 60, 40, [:scale = 1.5])
svg.addText("Scaled", 20, 220, [:fontSize = 10])

svg.setFill("orange")
svg.addRect(200, 150, 60, 40, [:skewX = 20])
svg.addText("Skewed", 200, 210, [:fontSize = 10])

if svg.save("demo7_transforms.svg")
    ? "  Created: demo7_transforms.svg"
else
    ? "  FAILED: demo7_transforms.svg"
ok

# Demo 8: Groups
? "Demo 8: Creating groups..."
svg = new SVGWriter(400, 250)
svg.setBackground("white")

svg.beginGroup([:id = "button1"])
svg.setFill("#4472C4")
svg.addRoundedRect(20, 20, 120, 40, 5, NULL)
svg.setFill("white")
svg.addTextCentered("Click Me", 80, 42, [:fontSize = 14])
svg.endGroup()

svg.beginGroup([:id = "card"])
shadow = svg.createShadowFilter(2, 2, 3, "#999")
svg.setFill("white")
svg.setStroke("#DDD", 1)
svg.addRoundedRect(20, 80, 200, 100, 8, [:filter = shadow])
svg.setFill("#333")
svg.addText("Card Title", 35, 110, [:fontSize = 16, :fontWeight = "bold"])
svg.setFill("#666")
svg.addMultilineText(["This is a card", "with grouped elements."], 35, 135, 18, [:fontSize = 12])
svg.endGroup()

if svg.save("demo8_groups.svg")
    ? "  Created: demo8_groups.svg"
else
    ? "  FAILED: demo8_groups.svg"
ok

# Demo 9: Paths
? "Demo 9: Creating custom paths..."
svg = new SVGWriter(400, 250)
svg.setBackground("white")

svg.setFill("red")
svg.addPath("M 80 30 C 80 10, 50 10, 50 30 C 50 50, 80 70, 80 90 C 80 70, 110 50, 110 30 C 110 10, 80 10, 80 30 Z", NULL)

path = svg.createPath()
path.moveTo(150, 60)
path.curveTo(180, 20, 220, 100, 250, 60)
path.curveTo(280, 20, 320, 100, 350, 60)
svg.setStroke("blue", 3)
svg.noFill()
path.draw(NULL)

path2 = svg.createPath()
path2.moveTo(30, 130)
path2.lineTo(100, 130)
path2.lineTo(100, 110)
path2.lineTo(140, 150)
path2.lineTo(100, 190)
path2.lineTo(100, 170)
path2.lineTo(30, 170)
path2.closePath()
svg.setFill("green")
svg.noStroke()
path2.draw(NULL)

if svg.save("demo9_paths.svg")
    ? "  Created: demo9_paths.svg"
else
    ? "  FAILED: demo9_paths.svg"
ok

# Demo 10: Bar Chart
? "Demo 10: Creating bar chart..."
svg = new SVGWriter(500, 350)
svg.setBackground("white")

data = [:labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"], :values = [120, 180, 150, 220, 190, 250]]
svg.addBarChart(data, 30, 30, 440, 280, [:title = "Monthly Sales", :showValues = true])

if svg.save("demo10_bar_chart.svg")
    ? "  Created: demo10_bar_chart.svg"
else
    ? "  FAILED: demo10_bar_chart.svg"
ok

# Demo 11: Line Chart
? "Demo 11: Creating line chart..."
svg = new SVGWriter(500, 350)
svg.setBackground("white")

data = [:labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], :values = [45, 62, 58, 78, 85, 72, 90]]
svg.addLineChart(data, 30, 30, 440, 280, [:title = "Weekly Visitors", :color = "#E91E63"])

if svg.save("demo11_line_chart.svg")
    ? "  Created: demo11_line_chart.svg"
else
    ? "  FAILED: demo11_line_chart.svg"
ok

# Demo 12: Pie Chart
? "Demo 12: Creating pie chart..."
svg = new SVGWriter(500, 350)
svg.setBackground("white")

data = [:labels = ["Desktop", "Mobile", "Tablet", "Other"], :values = [55, 30, 10, 5]]
svg.addPieChart(data, 180, 180, 120, [:title = "Device Usage", :showLegend = true])

if svg.save("demo12_pie_chart.svg")
    ? "  Created: demo12_pie_chart.svg"
else
    ? "  FAILED: demo12_pie_chart.svg"
ok

# Demo 13: Donut Chart
? "Demo 13: Creating donut chart..."
svg = new SVGWriter(400, 300)
svg.setBackground("white")

data = [:labels = ["Complete", "In Progress", "Pending"], :values = [65, 25, 10]]
svg.addDonutChart(data, 200, 150, 100, 50, [:centerText = "65%", :colors = ["#2E7D32", "#FFC107", "#757575"]])

if svg.save("demo13_donut_chart.svg")
    ? "  Created: demo13_donut_chart.svg"
else
    ? "  FAILED: demo13_donut_chart.svg"
ok

# Demo 14: Flowchart
? "Demo 14: Creating flowchart..."
svg = new SVGWriter(400, 350)
svg.setBackground("white")

svg.addFlowchartBox("Start", 150, 20, 100, 40, [:type = "rounded", :fill = "#4CAF50"])
svg.addFlowchartBox("Input Data", 150, 90, 100, 40, [:type = "parallelogram", :fill = "#2196F3"])
svg.addFlowchartBox("Valid?", 150, 160, 100, 60, [:type = "diamond", :fill = "#FF9800"])
svg.addFlowchartBox("Process", 30, 260, 100, 40, [:type = "rect", :fill = "#9C27B0"])
svg.addFlowchartBox("Error", 270, 260, 100, 40, [:type = "rect", :fill = "#F44336"])
svg.addFlowchartBox("End", 150, 320, 100, 40, [:type = "rounded", :fill = "#607D8B"])

svg.addConnector(200, 60, 200, 90, [:arrow = true])
svg.addConnector(200, 130, 200, 160, [:arrow = true])
svg.addConnector(150, 190, 80, 260, [:type = "elbow", :arrow = true])
svg.addConnector(250, 190, 320, 260, [:type = "elbow", :arrow = true])
svg.addConnector(80, 300, 150, 340, [:type = "elbow", :arrow = true])

svg.setFill("#666")
svg.addText("Yes", 90, 230, [:fontSize = 11])
svg.addText("No", 270, 230, [:fontSize = 11])

if svg.save("demo14_flowchart.svg")
    ? "  Created: demo14_flowchart.svg"
else
    ? "  FAILED: demo14_flowchart.svg"
ok

# Demo 15: Org Chart
? "Demo 15: Creating org chart..."
svg = new SVGWriter(500, 300)
svg.setBackground("white")

svg.addOrgChartBox("John Smith", "CEO", 180, 20, 140, 50, [:fill = "#1565C0"])
svg.addOrgChartBox("Alice Brown", "VP Engineering", 30, 100, 140, 50, [:fill = "#2E7D32"])
svg.addOrgChartBox("Bob Wilson", "VP Sales", 180, 100, 140, 50, [:fill = "#C62828"])
svg.addOrgChartBox("Carol Davis", "VP Marketing", 330, 100, 140, 50, [:fill = "#7B1FA2"])

svg.setStroke("#999", 2)
svg.noFill()
svg.addLine(250, 70, 250, 85, NULL)
svg.addLine(100, 85, 400, 85, NULL)
svg.addLine(100, 85, 100, 100, NULL)
svg.addLine(250, 85, 250, 100, NULL)
svg.addLine(400, 85, 400, 100, NULL)

if svg.save("demo15_org_chart.svg")
    ? "  Created: demo15_org_chart.svg"
else
    ? "  FAILED: demo15_org_chart.svg"
ok

# Demo 16: Icons
? "Demo 16: Creating icons..."
svg = new SVGWriter(350, 150)
svg.setBackground("white")

svg.addCheckmark(20, 20, 50, [:color = "green"])
svg.setFill("black")
svg.addText("Success", 20, 90, [:fontSize = 11])

svg.addCross(90, 20, 50, [:color = "red"])
svg.addText("Error", 95, 90, [:fontSize = 11])

svg.addPlus(160, 20, 50, [:color = "blue"])
svg.addText("Add", 170, 90, [:fontSize = 11])

svg.addMinus(230, 20, 50, [:color = "orange"])
svg.addText("Remove", 225, 90, [:fontSize = 11])

svg.setFill("gold")
svg.addStar(320, 45, 30, 15, 5, NULL)
svg.setFill("black")
svg.addText("Star", 305, 90, [:fontSize = 11])

svg.addArrowIcon(20, 100, 35, "right", [:color = "#333"])
svg.addArrowIcon(70, 100, 35, "left", [:color = "#333"])
svg.addArrowIcon(120, 100, 35, "up", [:color = "#333"])
svg.addArrowIcon(170, 100, 35, "down", [:color = "#333"])

if svg.save("demo16_icons.svg")
    ? "  Created: demo16_icons.svg"
else
    ? "  FAILED: demo16_icons.svg"
ok

# Demo 17: Markers
? "Demo 17: Creating markers..."
svg = new SVGWriter(400, 200)
svg.setBackground("white")

arrowMarker = svg.createArrowMarker(8, "blue")
dotMarker = svg.createDotMarker(6, "red")

svg.setStroke("blue", 2)
svg.noFill()
svg.addLine(20, 40, 180, 40, [:markerEnd = arrowMarker])
svg.setFill("black")
svg.addText("Arrow End", 200, 45, [:fontSize = 11])

svg.addLine(20, 80, 180, 80, [:markerStart = arrowMarker, :markerEnd = arrowMarker])
svg.addText("Both Ends", 200, 85, [:fontSize = 11])

svg.setStroke("red", 2)
svg.addLine(20, 120, 180, 120, [:markerStart = dotMarker, :markerEnd = dotMarker])
svg.setFill("black")
svg.addText("Dot Markers", 200, 125, [:fontSize = 11])

if svg.save("demo17_markers.svg")
    ? "  Created: demo17_markers.svg"
else
    ? "  FAILED: demo17_markers.svg"
ok

# Demo 18: Dashboard
? "Demo 18: Creating dashboard..."
svg = new SVGWriter(600, 400)
svg.setBackground("#F5F5F5")

svg.setFill("#1565C0")
svg.addRect(0, 0, 600, 50, NULL)
svg.setFill("white")
svg.addText("Analytics Dashboard", 20, 32, [:fontSize = 20, :fontWeight = "bold"])

shadow = svg.createShadowFilter(2, 2, 3, "#CCC")
svg.setFill("white")
svg.addRoundedRect(20, 70, 170, 80, 6, [:filter = shadow])
svg.setFill("#1565C0")
svg.addText("Users", 35, 95, [:fontSize = 12])
svg.setFill("#333")
svg.addText("24,521", 35, 125, [:fontSize = 22, :fontWeight = "bold"])
svg.setFill("#4CAF50")
svg.addText("+12%", 120, 125, [:fontSize = 12])

svg.setFill("white")
svg.addRoundedRect(210, 70, 170, 80, 6, [:filter = shadow])
svg.setFill("#E65100")
svg.addText("Revenue", 225, 95, [:fontSize = 12])
svg.setFill("#333")
svg.addText("$89,430", 225, 125, [:fontSize = 22, :fontWeight = "bold"])

svg.setFill("white")
svg.addRoundedRect(400, 70, 180, 80, 6, [:filter = shadow])
svg.setFill("#7B1FA2")
svg.addText("Orders", 415, 95, [:fontSize = 12])
svg.setFill("#333")
svg.addText("1,247", 415, 125, [:fontSize = 22, :fontWeight = "bold"])

svg.setFill("white")
svg.addRoundedRect(20, 170, 350, 210, 6, [:filter = shadow])
svg.setFill("#333")
svg.addText("Monthly Sales", 35, 195, [:fontSize = 14, :fontWeight = "bold"])

chartData = [:labels = ["Jan", "Feb", "Mar", "Apr", "May"], :values = [42, 58, 49, 72, 65]]
svg.addBarChart(chartData, 25, 200, 340, 170, [:colors = ["#42A5F5"]])

svg.setFill("white")
svg.addRoundedRect(390, 170, 190, 210, 6, [:filter = shadow])
svg.setFill("#333")
svg.addText("Traffic", 405, 195, [:fontSize = 14, :fontWeight = "bold"])

pieData = [:labels = ["Organic", "Direct", "Social"], :values = [50, 30, 20]]
svg.addPieChart(pieData, 485, 295, 60, [:colors = ["#4CAF50", "#2196F3", "#E91E63"]])

if svg.save("demo18_dashboard.svg")
    ? "  Created: demo18_dashboard.svg"
else
    ? "  FAILED: demo18_dashboard.svg"
ok

# Demo 19: Quick Function
? "Demo 19: Using quick SVG function..."
elements = [
    ["rect", 10, 10, 80, 50, [:fill = "blue"]],
    ["circle", 150, 35, 30, [:fill = "red"]],
    ["line", 200, 20, 280, 60, [:stroke = "green", :strokeWidth = 3]],
    ["text", "Quick SVG!", 10, 90, [:fontSize = 16, :fill = "purple"]]
]
quickSVG("demo19_quick.svg", 300, 110, elements)
? "  Created: demo19_quick.svg"

? ""
? "=============================================="
? "   All demos completed!"
? "=============================================="
? ""
? "Created files:"
? "  1. demo1_shapes.svg - Basic shapes"
? "  2. demo2_lines.svg - Lines and strokes"
? "  3. demo3_text.svg - Text elements"
? "  4. demo4_gradients.svg - Gradients"
? "  5. demo5_patterns.svg - Patterns"
? "  6. demo6_filters.svg - Filter effects"
? "  7. demo7_transforms.svg - Transformations"
? "  8. demo8_groups.svg - Groups"
? "  9. demo9_paths.svg - Custom paths"
? "  10. demo10_bar_chart.svg - Bar chart"
? "  11. demo11_line_chart.svg - Line chart"
? "  12. demo12_pie_chart.svg - Pie chart"
? "  13. demo13_donut_chart.svg - Donut chart"
? "  14. demo14_flowchart.svg - Flowchart"
? "  15. demo15_org_chart.svg - Org chart"
? "  16. demo16_icons.svg - Icons"
? "  17. demo17_markers.svg - Markers"
? "  18. demo18_dashboard.svg - Dashboard"
? "  19. demo19_quick.svg - Quick function"
? ""
? "Open these files in any web browser."
