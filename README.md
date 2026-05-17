# RingSVGLib Documentation

## Overview

RingSVGLib is a pure Ring library for creating Scalable Vector Graphics (SVG) files using the Ring programming language. It generates standard SVG files that can be viewed in any web browser, embedded in HTML, or used in other applications.

## Features

- **Basic Shapes** — Rectangles, circles, ellipses, polygons, stars
- **Lines & Paths** — Lines, polylines, arcs, custom paths with curves
- **Text** — Formatted text, multiline, centered, text on path
- **Gradients** — Linear and radial gradients with multiple stops
- **Patterns** — Stripes, dots, grids, custom patterns
- **Filters** — Blur, drop shadow, glow effects
- **Transformations** — Translate, rotate, scale, skew (per element)
- **Groups** — Group elements together
- **Clipping** — Clip shapes with masks
- **Markers** — Arrows and dots on lines
- **Charts** — Bar, line, pie, donut charts
- **Diagrams** — Flowcharts, org charts
- **Icons** — Checkmarks, crosses, arrows, stars
- **No Dependencies** — Pure Ring implementation

---

## Installation

	ringpm install svglib from ringpackages	

---

## Quick Start

### Simple SVG

```ring
load "ringsvglib.ring"

svg = new SVGWriter(400, 300)
svg.setBackground("white")
svg.addCircle(200, 150, 50, [:fill = "blue"])
svg.save("circle.svg")
```

### Quick Function

```ring
load "ringsvglib.ring"

elements = [
    ["rect",   10, 10, 80, 50, [:fill = "blue"]],
    ["circle", 150, 35, 30,    [:fill = "red"]],
    ["text",   "Hello!", 10, 90, [:fontSize = 16]]
]
quickSVG("output.svg", 200, 100, elements)
```

---

## Options Reference

Every drawing function accepts an `options` list as its final argument. Pass `NULL` to use all defaults.

### Style Options

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `:fill` | color | `"black"` | Fill color |
| `:stroke` | color | `"none"` | Stroke color |
| `:strokeWidth` | number | `1` | Stroke width in pixels |
| `:strokeDash` | string | — | Dash pattern, e.g. `"5,3"` |
| `:strokeLineCap` | string | — | `"butt"`, `"round"`, `"square"` |
| `:strokeLineJoin` | string | — | `"miter"`, `"round"`, `"bevel"` |
| `:opacity` | 0–1 | — | Overall opacity |
| `:fillOpacity` | 0–1 | — | Fill opacity |
| `:strokeOpacity` | 0–1 | — | Stroke opacity |
| `:filter` | URL string | — | From `createBlurFilter` etc. |
| `:clipPath` | URL string | — | From `createCircleClip` etc. |
| `:markerEnd` | marker ID | — | From `createArrowMarker` etc. |
| `:markerStart` | marker ID | — | From `createArrowMarker` etc. |
| `:id` | string | — | Element `id` attribute |
| `:class` | string | — | Element `class` attribute |

### Transform Options

| Key | Type | Description |
|-----|------|-------------|
| `:transform` | string | Raw SVG transform (overrides all below) |
| `:translate` | `[x, y]` | Translate |
| `:rotate` | angle or `[angle, cx, cy]` | Rotate |
| `:scale` | factor or `[sx, sy]` | Scale |
| `:skewX` | angle | Skew on X axis |
| `:skewY` | angle | Skew on Y axis |

### Text-Specific Options

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `:fontSize` | number | `14` | Font size |
| `:fontFamily` | string | `"Arial, sans-serif"` | Font family |
| `:fontWeight` | string | `"normal"` | `"normal"`, `"bold"`, `"lighter"` |
| `:fontStyle` | string | `"normal"` | `"normal"`, `"italic"`, `"oblique"` |
| `:textAnchor` | string | `"start"` | `"start"`, `"middle"`, `"end"` |
| `:dominantBaseline` | string | — | `"auto"`, `"middle"`, `"hanging"` |
| `:textDecoration` | string | — | `"underline"`, `"line-through"` |

**Important defaults:**
- `addLine` defaults `:stroke` to `"black"` when not specified (lines are invisible without a stroke).
- `addArc` defaults `:fill` to `"none"` and `:stroke` to `"black"`.
- All other shapes default `:fill` to `"black"` and `:stroke` to `"none"`.

---

## API Reference

### SVGWriter Class

#### Constructor

```ring
svg = new SVGWriter(width, height)
```

---

### Canvas Settings

| Method | Description |
|--------|-------------|
| `setSize(w, h)` | Set canvas size |
| `setViewBox(x, y, w, h)` | Set viewBox |
| `setBackground(color)` | Set background color |

---

### Basic Shapes

#### Rectangle

```ring
svg.addRect(x, y, width, height, options)
svg.addRoundedRect(x, y, width, height, radius, options)
```

```ring
svg.addRect(20, 20, 100, 60, [:fill = "blue", :stroke = "navy", :strokeWidth = 2])
svg.addRoundedRect(20, 100, 100, 60, 10, [:fill = "coral"])
```

#### Circle & Ellipse

```ring
svg.addCircle(cx, cy, r, options)
svg.addEllipse(cx, cy, rx, ry, options)
```

```ring
svg.addCircle(100, 100, 50, [:fill = "red", :opacity = 0.8])
svg.addEllipse(200, 100, 60, 30, [:fill = "green"])
```

#### Line

```ring
svg.addLine(x1, y1, x2, y2, options)
```

```ring
# stroke defaults to "black" if not specified
svg.addLine(10, 10, 200, 10, [:stroke = "red", :strokeWidth = 3])
svg.addLine(10, 30, 200, 30, [:stroke = "blue", :strokeDash = "8,4"])
```

#### Polyline & Polygon

```ring
svg.addPolyline(points, options)   # points = [[x1,y1], [x2,y2], ...]
svg.addPolygon(points, options)
```

#### Triangle & Star

```ring
svg.addTriangle(x1, y1, x2, y2, x3, y3, options)
svg.addStar(cx, cy, outerR, innerR, numPoints, options)
```

```ring
svg.addStar(100, 100, 50, 25, 5, [:fill = "gold", :stroke = "orange", :strokeWidth = 1])
```

#### Arc

```ring
svg.addArc(cx, cy, r, startAngle, endAngle, options)
```

Arc defaults: `:fill = "none"`, `:stroke = "black"`.

```ring
svg.addArc(100, 100, 60, 0, 270, [:stroke = "purple", :strokeWidth = 3])
```

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
path.curveTo(x1, y1, x2, y2, x, y)       # Cubic bezier
path.smoothCurveTo(x2, y2, x, y)         # Smooth cubic
path.quadraticTo(x1, y1, x, y)           # Quadratic bezier
path.smoothQuadraticTo(x, y)             # Smooth quadratic
path.arcTo(rx, ry, rotation, largeArc, sweep, x, y)
path.closePath()
path.draw(options)                        # Renders the path
```

```ring
path = svg.createPath()
path.moveTo(50, 50)
path.curveTo(100, 0, 150, 100, 200, 50)
path.lineTo(200, 150)
path.closePath()
path.draw([:fill = "blue", :stroke = "navy", :strokeWidth = 1])
```

---

### Text

```ring
svg.addText(text, x, y, options)
svg.addTextCentered(text, x, y, options)
svg.addMultilineText(lines, x, y, lineHeight, options)
svg.addTextPath(text, pathId, options)
```

```ring
svg.addText("Hello!", 20, 40, [:fill = "black", :fontSize = 18, :fontWeight = "bold"])
svg.addTextCentered("Centered", 200, 150, [:fill = "blue", :fontSize = 14])
svg.addMultilineText(["Line one", "Line two"], 20, 60, 22, [:fill = "#333", :fontSize = 13])
```

---

### Gradients

#### Linear Gradient

```ring
gradientUrl = svg.createLinearGradient(x1, y1, x2, y2, stops)
```

Coordinates are percentages (0–100). Stops: `[[offset%, color], ...]`

```ring
grad = svg.createLinearGradient(0, 0, 100, 0, [
    [0,   "red"],
    [50,  "yellow"],
    [100, "green"]
])
svg.addRect(0, 0, 200, 100, [:fill = grad])
```

#### Radial Gradient

```ring
gradientUrl = svg.createRadialGradient(cx, cy, r, stops)
```

```ring
grad = svg.createRadialGradient(50, 50, 50, [
    [0,   "white"],
    [100, "blue"]
])
svg.addCircle(100, 100, 80, [:fill = grad])
```

---

### Patterns

```ring
patternUrl = svg.createStripePattern(width, color1, color2, angle)
patternUrl = svg.createDotPattern(spacing, radius, color, bgColor)
patternUrl = svg.createGridPattern(spacing, strokeWidth, color, bgColor)
```

```ring
stripes = svg.createStripePattern(10, "blue", "white", 45)
svg.addRect(0, 0, 200, 100, [:fill = stripes])
```

---

### Filters

```ring
filterUrl = svg.createBlurFilter(stdDeviation)
filterUrl = svg.createShadowFilter(dx, dy, blur, color)
filterUrl = svg.createGlowFilter(blur, color)
```

```ring
shadow = svg.createShadowFilter(4, 4, 3, "gray")
svg.addRect(50, 50, 100, 60, [:fill = "white", :filter = shadow])
```

---

### Markers

```ring
markerId = svg.createArrowMarker(size, color)
markerId = svg.createDotMarker(size, color)
```

```ring
arrow = svg.createArrowMarker(8, "black")
svg.addLine(50, 50, 200, 50, [:stroke = "black", :strokeWidth = 2, :markerEnd = arrow])
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
svg.addRect(50, 50, 100, 100, [:fill = "blue", :clipPath = clip])
```

---

### Groups

```ring
groupId = svg.beginGroup(options)
# ... add elements ...
svg.endGroup()
```

Group options: `:id`, `:opacity`, `:filter`, `:clipPath`, transform keys.

```ring
svg.beginGroup([:id = "myGroup", :translate = [100, 50]])
svg.addRect(0, 0, 50, 30, [:fill = "blue"])
svg.addCircle(25, 15, 10, [:fill = "red"])
svg.endGroup()
```

---

### Charts

All chart functions accept a `data` list with `:labels` and `:values` keys.

#### Bar Chart

```ring
svg.addBarChart(data, x, y, width, height, options)
```

Chart options: `:title`, `:colors` (array), `:showValues` (true/false)

#### Line Chart

```ring
svg.addLineChart(data, x, y, width, height, options)
```

Chart options: `:title`, `:color`

#### Pie Chart

```ring
svg.addPieChart(data, cx, cy, radius, options)
```

Chart options: `:title`, `:colors`, `:showLegend`

#### Donut Chart

```ring
svg.addDonutChart(data, cx, cy, outerR, innerR, options)
```

Chart options: `:title`, `:colors`, `:centerText`

**Data format:**
```ring
data = [
    :labels = ["A", "B", "C"],
    :values = [10, 20, 30]
]
```

**Example:**
```ring
data = [:labels = ["Jan", "Feb", "Mar"], :values = [30, 45, 60]]
svg.addBarChart(data, 20, 20, 360, 260, [:title = "Monthly Trend", :showValues = true])
```

---

### Diagrams

#### Flowchart

```ring
svg.addFlowchartBox(text, x, y, width, height, options)
svg.addConnector(x1, y1, x2, y2, options)
```

Box options: `:type` (`"rect"`, `"rounded"`, `"diamond"`, `"oval"`, `"parallelogram"`), `:fill`, `:textColor`

Connector options: `:type` (`"line"`, `"elbow"`, `"curve"`), `:arrow` (true/false)

#### Org Chart

```ring
svg.addOrgChartBox(name, title, x, y, width, height, options)
```

Options: `:fill`

---

### Icons

```ring
svg.addCheckmark(x, y, size, options)   # options: :color
svg.addCross(x, y, size, options)
svg.addPlus(x, y, size, options)
svg.addMinus(x, y, size, options)
svg.addArrowIcon(x, y, size, direction, options)
```

Directions for `addArrowIcon`: `"up"`, `"down"`, `"left"`, `"right"`

```ring
svg.addCheckmark(20, 20, 40, [:color = "green"])
svg.addArrowIcon(80, 20, 40, "right", [:color = "blue"])
```

---

### Output

```ring
svg.save(filename)    # Save to file, returns true on success
svg.toString()        # Get SVG as a string
svg.toDataURI()       # Get as data URI
```

---

## Color Reference

### Named Colors

black, white, red, green, blue, yellow, orange, purple, pink, gray/grey, navy, teal, maroon, silver, lime, aqua, cyan, fuchsia, magenta, olive, brown, coral, crimson, gold, indigo, ivory, khaki, lavender, salmon, tan, violet, wheat, skyblue, steelblue, tomato, turquoise

### Hex Colors

```ring
svg.addCircle(100, 100, 50, [:fill = "#FF5733"])
svg.addCircle(200, 100, 50, [:fill = "FF5733"])   # # is optional
```

### Special Values

```ring
[:fill = "none"]          # No fill
[:fill = "transparent"]   # Transparent
```

### Gradient/Pattern URLs

```ring
grad = svg.createLinearGradient(...)
svg.addRect(0, 0, 200, 100, [:fill = grad])   # Pass the URL string directly
```

---

## Constants

### Anchors
`SVG_ANCHOR_START`, `SVG_ANCHOR_MIDDLE`, `SVG_ANCHOR_END`

### Line Caps
`SVG_CAP_BUTT`, `SVG_CAP_ROUND`, `SVG_CAP_SQUARE`

### Line Joins
`SVG_JOIN_MITER`, `SVG_JOIN_ROUND`, `SVG_JOIN_BEVEL`

### Font Weights
`SVG_WEIGHT_NORMAL`, `SVG_WEIGHT_BOLD`, `SVG_WEIGHT_LIGHTER`

---

## Complete Examples

### Logo Design

```ring
load "ringsvglib.ring"

svg = new SVGWriter(200, 200)
svg.setBackground("white")

grad = svg.createRadialGradient(30, 30, 70, [
    [0,   "#4FC3F7"],
    [100, "#0288D1"]
])
svg.addCircle(100, 100, 80, [:fill = grad])
svg.addTextCentered("R", 100, 115, [:fill = "white", :fontSize = 72, :fontWeight = "bold"])

svg.save("logo.svg")
```

### Infographic

```ring
load "ringsvglib.ring"

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
```

### Process Diagram

```ring
load "ringsvglib.ring"

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
```

---

## Migration Guide (v1.x → v2.0)

| v1.x | v2.0 |
|------|-------|
| `svg.setFill("blue")` then `svg.addRect(...)` | `svg.addRect(..., [:fill = "blue"])` |
| `svg.setStroke("black", 2)` | Pass `:stroke = "black", :strokeWidth = 2` in options |
| `svg.noFill()` | Pass `:fill = "none"` in options |
| `svg.noStroke()` | Omit `:stroke` (default is `"none"`) |
| `svg.resetStyle()` | No-op; each call is already independent |
| `svg.setFillOpacity(0.5)` | Pass `:fillOpacity = 0.5` in options |
| `svg.setStrokeDash("5,3")` | Pass `:strokeDash = "5,3"` in options |
| `svg.setFont("Arial", 16)` | Pass `:fontFamily = "Arial", :fontSize = 16` in options |

---

## Tips

1. Pass `NULL` as options when you want all defaults.
2. Gradients and pattern URLs are plain strings; pass them as the `:fill` value.
3. Use `beginGroup` / `endGroup` to apply a shared transform or filter to many elements at once.
4. Filters can be performance-heavy; use them sparingly.
5. Use `setViewBox` to make SVGs scale responsively.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Shape invisible | Check `:fill` and `:stroke`; shapes with neither are not visible |
| Line not showing | `addLine` needs `:stroke`; it defaults to `"black"` but custom colors must be set |
| Colors not applying | Ensure colors are strings in quotes |
| Text cut off | Increase canvas size or adjust x/y position |
| Gradients not working | Ensure stops are in 0–100 range |
| File not saving | Check file path and write permissions |

---

## Technical Notes

- **Format:** SVG 1.1 / 2.0 compatible
- **Encoding:** UTF-8
- **Dependencies:** None (pure Ring)
