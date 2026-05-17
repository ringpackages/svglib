# RingSVGLib Documentation

## Overview

RingSVGLib is a library for creating Scalable Vector Graphics (SVG) files using the Ring programming language. It generates standard SVG files that can be viewed in any web browser, embedded in HTML, or used in other applications.

## Features

- **Basic Shapes** - Rectangles, circles, ellipses, polygons, stars
- **Lines & Paths** - Lines, polylines, arcs, custom paths with curves
- **Text** - Formatted text, multiline, centered, text on path
- **Gradients** - Linear and radial gradients with multiple stops
- **Patterns** - Stripes, dots, grids, custom patterns
- **Filters** - Blur, drop shadow, glow effects
- **Transformations** - Translate, rotate, scale, skew
- **Groups** - Group elements together
- **Clipping** - Clip shapes with masks
- **Markers** - Arrows and dots on lines
- **Charts** - Bar, line, pie, donut charts
- **Diagrams** - Flowcharts, org charts
- **Icons** - Checkmarks, crosses, arrows, stars
- **No Dependencies** - Pure Ring implementation

## Installation

	ringpm install svglib from ringpackages

---

## Quick Start

### Simple SVG

```ring
load "ringsvglib.ring"

svg = new SVGWriter(400, 300)
svg.setBackground("white")
svg.setFill("blue")
svg.addCircle(200, 150, 50, NULL)
svg.save("circle.svg")
```

### Quick Function

```ring
load "ringsvglib.ring"

elements = [
    ["rect", 10, 10, 80, 50, [:fill = "blue"]],
    ["circle", 150, 35, 30, [:fill = "red"]],
    ["text", "Hello!", 10, 90, [:fontSize = 16]]
]
quickSVG("output.svg", 200, 100, elements)
```

---

## API Reference

### SVGWriter Class

#### Constructor

```ring
svg = new SVGWriter(width, height)
```

Creates a new SVG canvas.

---

### Canvas Settings

| Method | Description |
|--------|-------------|
| `setSize(w, h)` | Set canvas size |
| `setViewBox(x, y, w, h)` | Set viewBox |
| `setBackground(color)` | Set background color |

---

### Style Settings

| Method | Description |
|--------|-------------|
| `setFill(color)` | Set fill color |
| `setStroke(color, width)` | Set stroke color and width |
| `setStrokeWidth(width)` | Set stroke width |
| `setStrokeDash(pattern)` | Set dash pattern (e.g., "5,3") |
| `setStrokeLineCap(cap)` | "butt", "round", "square" |
| `setStrokeLineJoin(join)` | "miter", "round", "bevel" |
| `setOpacity(value)` | Set overall opacity (0-1) |
| `setFillOpacity(value)` | Set fill opacity |
| `setStrokeOpacity(value)` | Set stroke opacity |
| `noFill()` | Remove fill |
| `noStroke()` | Remove stroke |
| `resetStyle()` | Reset to defaults |

---

### Text Settings

| Method | Description |
|--------|-------------|
| `setFont(family, size)` | Set font family and size |
| `setFontSize(size)` | Set font size |
| `setFontWeight(weight)` | "normal", "bold", "lighter" |
| `setFontStyle(style)` | "normal", "italic", "oblique" |
| `setTextAnchor(anchor)` | "start", "middle", "end" |

---

### Basic Shapes

#### Rectangle

```ring
svg.addRect(x, y, width, height, options)
svg.addRoundedRect(x, y, width, height, radius, options)
```

#### Circle & Ellipse

```ring
svg.addCircle(cx, cy, r, options)
svg.addEllipse(cx, cy, rx, ry, options)
```

#### Line

```ring
svg.addLine(x1, y1, x2, y2, options)
```

#### Polyline & Polygon

```ring
svg.addPolyline(points, options)  # points = [[x1,y1], [x2,y2], ...]
svg.addPolygon(points, options)
```

#### Triangle & Star

```ring
svg.addTriangle(x1, y1, x2, y2, x3, y3, options)
svg.addStar(cx, cy, outerR, innerR, points, options)
```

#### Arc

```ring
svg.addArc(cx, cy, r, startAngle, endAngle, options)
```

**Common Options:**
- `:fill` - Fill color
- `:stroke` - Stroke color
- `:strokeWidth` - Stroke width
- `:opacity` - Opacity (0-1)
- `:transform` - Transform string
- `:translate` - [x, y]
- `:rotate` - angle or [angle, cx, cy]
- `:scale` - factor or [sx, sy]
- `:filter` - Filter URL
- `:clipPath` - Clip path URL

---

### Paths

#### Direct Path

```ring
svg.addPath(d, options)
```

#### Path Builder

```ring
path = svg.createPath()
path.moveTo(x, y)
path.lineTo(x, y)
path.horizontalTo(x)
path.verticalTo(y)
path.curveTo(x1, y1, x2, y2, x, y)      # Cubic bezier
path.smoothCurveTo(x2, y2, x, y)        # Smooth cubic
path.quadraticTo(x1, y1, x, y)          # Quadratic bezier
path.smoothQuadraticTo(x, y)            # Smooth quadratic
path.arcTo(rx, ry, rotation, largeArc, sweep, x, y)
path.closePath()
path.draw(options)
```

**Example:**
```ring
path = svg.createPath()
path.moveTo(50, 50)
path.curveTo(100, 0, 150, 100, 200, 50)
path.lineTo(200, 150)
path.closePath()
svg.setFill("blue")
path.draw(NULL)
```

---

### Text

```ring
svg.addText(text, x, y, options)
svg.addTextCentered(text, x, y, options)
svg.addMultilineText(lines, x, y, lineHeight, options)
svg.addTextPath(text, pathId, options)
```

**Options:**
- `:fontSize` - Font size
- `:fontFamily` - Font family
- `:fontWeight` - "normal", "bold"
- `:fontStyle` - "normal", "italic"
- `:textAnchor` - "start", "middle", "end"
- `:dominantBaseline` - "auto", "middle", "hanging"
- `:textDecoration` - "underline", "line-through"

---

### Gradients

#### Linear Gradient

```ring
gradientUrl = svg.createLinearGradient(x1, y1, x2, y2, stops)
```

- x1, y1, x2, y2: Direction in percentages (0-100)
- stops: [[offset%, color], [offset%, color, opacity], ...]

```ring
grad = svg.createLinearGradient(0, 0, 100, 0, [
    [0, "red"],
    [50, "yellow"],
    [100, "green"]
])
svg.setFill(grad)
svg.addRect(0, 0, 200, 100, NULL)
```

#### Radial Gradient

```ring
gradientUrl = svg.createRadialGradient(cx, cy, r, stops)
```

```ring
grad = svg.createRadialGradient(50, 50, 50, [
    [0, "white"],
    [100, "blue"]
])
svg.setFill(grad)
svg.addCircle(100, 100, 80, NULL)
```

---

### Patterns

```ring
pattern = svg.createStripePattern(width, color1, color2, angle)
pattern = svg.createDotPattern(spacing, radius, color, bgColor)
pattern = svg.createGridPattern(spacing, strokeWidth, color, bgColor)
```

```ring
stripes = svg.createStripePattern(10, "blue", "white", 45)
svg.setFill(stripes)
svg.addRect(0, 0, 200, 100, NULL)
```

---

### Filters

```ring
filter = svg.createBlurFilter(stdDeviation)
filter = svg.createShadowFilter(dx, dy, blur, color)
filter = svg.createGlowFilter(blur, color)
```

```ring
shadow = svg.createShadowFilter(4, 4, 3, "gray")
svg.addRect(50, 50, 100, 60, [:filter = shadow])
```

---

### Markers

```ring
markerId = svg.createArrowMarker(size, color)
markerId = svg.createDotMarker(size, color)
```

```ring
arrow = svg.createArrowMarker(8, "black")
svg.addLine(50, 50, 200, 50, [:markerEnd = arrow])
```

---

### Clipping

```ring
clipUrl = svg.createCircleClip(cx, cy, r)
clipUrl = svg.createRectClip(x, y, width, height)
clipUrl = svg.createClipPath(elements)
```

```ring
clip = svg.createCircleClip(100, 100, 50)
svg.addRect(50, 50, 100, 100, [:clipPath = clip])
```

---

### Groups

```ring
groupId = svg.beginGroup(options)
# ... add elements ...
svg.endGroup()
```

```ring
svg.beginGroup([:id = "myGroup", :translate = [100, 50]])
svg.addRect(0, 0, 50, 30, NULL)
svg.addCircle(25, 15, 10, NULL)
svg.endGroup()
```

---

### Charts

#### Bar Chart

```ring
svg.addBarChart(data, x, y, width, height, options)
```

#### Line Chart

```ring
svg.addLineChart(data, x, y, width, height, options)
```

#### Pie Chart

```ring
svg.addPieChart(data, cx, cy, radius, options)
```

#### Donut Chart

```ring
svg.addDonutChart(data, cx, cy, outerR, innerR, options)
```

**Data Format:**
```ring
data = [
    :labels = ["A", "B", "C"],
    :values = [10, 20, 30]
]
```

**Options:**
- `:title` - Chart title
- `:colors` - Array of colors
- `:showValues` - Show values on bars
- `:showLegend` - Show legend (pie)
- `:centerText` - Center text (donut)

---

### Diagrams

#### Flowchart

```ring
svg.addFlowchartBox(text, x, y, width, height, options)
svg.addConnector(x1, y1, x2, y2, options)
```

**Box Types:** "rect", "rounded", "diamond", "oval", "parallelogram"
**Connector Types:** "line", "elbow", "curve"

#### Org Chart

```ring
svg.addOrgChartBox(name, title, x, y, width, height, options)
```

---

### Icons

```ring
svg.addCheckmark(x, y, size, options)
svg.addCross(x, y, size, options)
svg.addPlus(x, y, size, options)
svg.addMinus(x, y, size, options)
svg.addArrowIcon(x, y, size, direction, options)
```

**Directions:** "up", "down", "left", "right"

---

### Output

```ring
svg.save(filename)       # Save to file
svg.toString()           # Get SVG string
svg.toDataURI()          # Get as data URI
```

---

## Color Reference

### Named Colors
black, white, red, green, blue, yellow, orange, purple, pink, gray/grey, navy, teal, maroon, silver, lime, aqua, cyan, fuchsia, magenta, olive, brown, coral, crimson, gold, indigo, ivory, khaki, lavender, salmon, tan, violet, wheat, skyblue, steelblue, tomato, turquoise

### Hex Colors
```ring
svg.setFill("#FF5733")
svg.setFill("FF5733")    # Without #
```

### Special Values
```ring
svg.setFill("none")        # No fill
svg.setFill("transparent") # Transparent
```

---

## Constants

### Anchors
- `SVG_ANCHOR_START`, `SVG_ANCHOR_MIDDLE`, `SVG_ANCHOR_END`

### Line Caps
- `SVG_CAP_BUTT`, `SVG_CAP_ROUND`, `SVG_CAP_SQUARE`

### Line Joins
- `SVG_JOIN_MITER`, `SVG_JOIN_ROUND`, `SVG_JOIN_BEVEL`

### Font Weights
- `SVG_WEIGHT_NORMAL`, `SVG_WEIGHT_BOLD`, `SVG_WEIGHT_LIGHTER`

### Shape Types
- `PPT_SHAPE_RECT`, `PPT_SHAPE_ELLIPSE`, `PPT_SHAPE_LINE`

---

## Complete Examples

### Logo Design

```ring
load "ringsvglib.ring"

svg = new SVGWriter(200, 200)
svg.setBackground("white")

# Circle background
grad = svg.createRadialGradient(30, 30, 70, [
    [0, "#4FC3F7"],
    [100, "#0288D1"]
])
svg.setFill(grad)
svg.addCircle(100, 100, 80, NULL)

# Letter R
svg.setFill("white")
svg.setFont("Arial", 72)
svg.addTextCentered("R", 100, 115, [:fontWeight = "bold"])

svg.save("logo.svg")
```

### Infographic

```ring
load "ringsvglib.ring"

svg = new SVGWriter(400, 300)
svg.setBackground("#F5F5F5")

# Title
svg.setFill("#333")
svg.addText("Q4 Results", 20, 30, [:fontSize = 20, :fontWeight = "bold"])

# KPI Cards
shadow = svg.createShadowFilter(2, 2, 3, "#CCC")

svg.setFill("white")
svg.addRoundedRect(20, 50, 110, 70, 5, [:filter = shadow])
svg.setFill("#1565C0")
svg.addText("Revenue", 35, 75, [:fontSize = 12])
svg.setFill("#333")
svg.addText("$1.2M", 35, 100, [:fontSize = 18, :fontWeight = "bold"])

svg.setFill("white")
svg.addRoundedRect(145, 50, 110, 70, 5, [:filter = shadow])
svg.setFill("#2E7D32")
svg.addText("Growth", 160, 75, [:fontSize = 12])
svg.setFill("#333")
svg.addText("+24%", 160, 100, [:fontSize = 18, :fontWeight = "bold"])

# Chart
data = [:labels = ["Jan", "Feb", "Mar"], :values = [30, 45, 60]]
svg.addBarChart(data, 20, 140, 360, 140, [:title = "Monthly Trend"])

svg.save("infographic.svg")
```

### Process Diagram

```ring
load "ringsvglib.ring"

svg = new SVGWriter(500, 150)
svg.setBackground("white")

# Process boxes
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
```

---

## Tips

1. **Use Groups** for complex drawings
2. **Reuse Gradients** - create once, use multiple times
3. **Use Filters Sparingly** - they can be performance-heavy
4. **Test in Multiple Browsers** for compatibility
5. **Use viewBox** for responsive SVGs

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Colors not showing | Check color format, use quotes |
| Text cut off | Increase canvas size or adjust position |
| Gradients not working | Ensure stops are 0-100 range |
| File not saving | Check file path permissions |

---

## Technical Notes

- **Format:** SVG 1.1 / 2.0 compatible
- **Encoding:** UTF-8
- **Platform:** Windows and Linux
- **Dependencies:** None
