/*
    RingSVGLib - SVG Graphics Library for Ring Programming Language
*/

# ============================================================================
# SVGWriter Class
# ============================================================================

class SVGWriter

    # Canvas settings
    nWidth
    nHeight
    cViewBox
    cBackground

    # Elements & Defs
    aElements
    aDefs

    # ID counters
    nGradientId
    nFilterId
    nClipId
    nMarkerId
    nPatternId
    nGroupId

    # Groups stack
    aGroupStack

    func init width, height
        nWidth  = width
        nHeight = height
        cViewBox    = "0 0 " + width + " " + height
        cBackground = NULL

        aElements = []
        aDefs     = []

        nGradientId = 0
        nFilterId   = 0
        nClipId     = 0
        nMarkerId   = 0
        nPatternId  = 0
        nGroupId    = 0

        aGroupStack = []

        return self

    # ========================================================================
    # Canvas Settings
    # ========================================================================

    func setSize width, height
        nWidth  = width
        nHeight = height
        cViewBox = "0 0 " + width + " " + height
        return self

    func setViewBox x, y, width, height
        cViewBox = "" + x + " " + y + " " + width + " " + height
        return self

    func setBackground color
        cBackground = svgColorToHex(color)
        return self

    # ========================================================================
    # Basic Shapes
    # All accept an options list (or NULL).
    #
    # Style keys:
    #   :fill            - fill color (default: "black")
    #   :stroke          - stroke color (default: none)
    #   :strokeWidth     - stroke width (default: 1)
    #   :strokeDash      - dash pattern string e.g. "5,3"
    #   :strokeLineCap   - "butt" | "round" | "square"
    #   :strokeLineJoin  - "miter" | "round" | "bevel"
    #   :opacity         - overall opacity 0-1
    #   :fillOpacity     - fill opacity 0-1
    #   :strokeOpacity   - stroke opacity 0-1
    #   :filter          - filter URL from createBlurFilter etc.
    #   :clipPath        - clip-path URL from createCircleClip etc.
    #   :markerEnd       - marker ID from createArrowMarker etc.
    #   :markerStart     - marker ID
    #   :id              - element id attribute
    #   :class           - element class attribute
    #
    # Transform keys:
    #   :transform       - raw SVG transform string (overrides below)
    #   :translate       - [x, y]
    #   :rotate          - angle  OR  [angle, cx, cy]
    #   :scale           - factor OR  [sx, sy]
    #   :skewX           - angle
    #   :skewY           - angle
    # ========================================================================

    func addRect x, y, width, height, options
        if options = NULL options = [] ok

        elem  = '<rect x="' + svgNum(x) + '" y="' + svgNum(y) + '" '
        elem += 'width="'   + svgNum(width)  + '" height="' + svgNum(height) + '"'

        if options[:rx] != NULL
            elem += ' rx="' + svgNum(options[:rx]) + '"'
        ok
        if options[:ry] != NULL
            elem += ' ry="' + svgNum(options[:ry]) + '"'
        ok

        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addRoundedRect x, y, width, height, radius, options
        if options = NULL options = [] ok
        options[:rx] = radius
        options[:ry] = radius
        return addRect(x, y, width, height, options)

    func addCircle cx, cy, r, options
        if options = NULL options = [] ok

        elem  = '<circle cx="' + svgNum(cx) + '" cy="' + svgNum(cy) + '" r="' + svgNum(r) + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addEllipse cx, cy, rx, ry, options
        if options = NULL options = [] ok

        elem  = '<ellipse cx="' + svgNum(cx) + '" cy="' + svgNum(cy) + '" '
        elem += 'rx="' + svgNum(rx) + '" ry="' + svgNum(ry) + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addLine x1, y1, x2, y2, options
        if options = NULL options = [] ok

        # Lines are invisible without a stroke; default to black
        if options[:stroke] = NULL
            options[:stroke] = "black"
        ok

        elem  = '<line x1="' + svgNum(x1) + '" y1="' + svgNum(y1) + '" '
        elem += 'x2="'  + svgNum(x2) + '" y2="' + svgNum(y2) + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addPolyline points, options
        if options = NULL options = [] ok

        pointsStr = ""
        pointsLen = len(points)
        for i = 1 to pointsLen
            pt = points[i]
            if i > 1 pointsStr += " " ok
            pointsStr += svgNum(pt[1]) + "," + svgNum(pt[2])
        next

        elem  = '<polyline points="' + pointsStr + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addPolygon points, options
        if options = NULL options = [] ok

        pointsStr = ""
        pointsLen = len(points)
        for i = 1 to pointsLen
            pt = points[i]
            if i > 1 pointsStr += " " ok
            pointsStr += svgNum(pt[1]) + "," + svgNum(pt[2])
        next

        elem  = '<polygon points="' + pointsStr + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addTriangle x1, y1, x2, y2, x3, y3, options
        return addPolygon([[x1, y1], [x2, y2], [x3, y3]], options)

    func addStar cx, cy, outerR, innerR, points, options
        if options = NULL options = [] ok

        starPoints = []
        angleStep  = 360 / points / 2

        for i = 0 to (points * 2 - 1)
            angle = (i * angleStep - 90) * 3.14159 / 180
            if i % 2 = 0
                r = outerR
            else
                r = innerR
            ok
            px = cx + r * cos(angle)
            py = cy + r * sin(angle)
            starPoints + [px, py]
        next

        return addPolygon(starPoints, options)

    func addArc cx, cy, r, startAngle, endAngle, options
        if options = NULL options = [] ok

        startRad = startAngle * 3.14159 / 180
        endRad   = endAngle   * 3.14159 / 180

        x1 = cx + r * cos(startRad)
        y1 = cy + r * sin(startRad)
        x2 = cx + r * cos(endRad)
        y2 = cy + r * sin(endRad)

        largeArc = 0
        if (endAngle - startAngle) > 180 largeArc = 1 ok

        d  = "M " + svgNum(x1) + " " + svgNum(y1) + " "
        d += "A " + svgNum(r)  + " " + svgNum(r)  + " 0 " + largeArc + " 1 "
        d += svgNum(x2) + " " + svgNum(y2)

        # Arcs are stroked, not filled, by default
        if options[:fill]   = NULL options[:fill]   = "none"  ok
        if options[:stroke] = NULL options[:stroke] = "black" ok

        return addPath(d, options)

    # ========================================================================
    # Path
    # ========================================================================

    func addPath d, options
        if options = NULL options = [] ok

        elem  = '<path d="' + d + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func createPath
        return new SVGPath(self)

    # ========================================================================
    # Text
    # Options: :fill :fontSize :fontFamily :fontWeight :fontStyle
    #          :textAnchor :dominantBaseline :textDecoration
    #          (plus all standard style/transform keys)
    # ========================================================================

    func addText text, x, y, options
        if options = NULL options = [] ok

        elem  = '<text x="' + svgNum(x) + '" y="' + svgNum(y) + '"'
        elem += getTextStyleAttr(options)
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '>' + svgXmlEsc(text) + '</text>'

        addElement(elem)
        return self

    func addTextCentered text, x, y, options
        if options = NULL options = [] ok
        options[:textAnchor]       = "middle"
        options[:dominantBaseline] = "middle"
        return addText(text, x, y, options)

    func addTextPath text, pathId, options
        if options = NULL options = [] ok

        startOffset = "0%"
        if options[:startOffset] != NULL
            startOffset = options[:startOffset]
        ok

        elem  = '<text'
        elem += getTextStyleAttr(options)
        elem += getStyleAttr(options)
        elem += '>'
        elem += '<textPath href="#' + pathId + '" startOffset="' + startOffset + '">'
        elem += svgXmlEsc(text)
        elem += '</textPath></text>'

        addElement(elem)
        return self

    func addMultilineText lines, x, y, lineHeight, options
        if options = NULL options = [] ok

        elem  = '<text x="' + svgNum(x) + '" y="' + svgNum(y) + '"'
        elem += getTextStyleAttr(options)
        elem += getStyleAttr(options)
        elem += '>'

        linesLen = len(lines)
        for i = 1 to linesLen
            if i = 1
                elem += '<tspan x="' + svgNum(x) + '">' + svgXmlEsc(lines[i]) + '</tspan>'
            else
                elem += '<tspan x="' + svgNum(x) + '" dy="' + svgNum(lineHeight) + '">' + svgXmlEsc(lines[i]) + '</tspan>'
            ok
        next

        elem += '</text>'
        addElement(elem)
        return self

    # ========================================================================
    # Images
    # ========================================================================

    func addImage href, x, y, width, height, options
        if options = NULL options = [] ok

        elem  = '<image href="' + svgXmlEsc(href) + '" '
        elem += 'x="' + svgNum(x) + '" y="' + svgNum(y) + '" '
        elem += 'width="' + svgNum(width) + '" height="' + svgNum(height) + '"'

        if options[:preserveAspectRatio] != NULL
            elem += ' preserveAspectRatio="' + options[:preserveAspectRatio] + '"'
        ok

        elem += getTransformAttr(options)
        elem += '/>'

        addElement(elem)
        return self

    func addImageBase64 data, mimeType, x, y, width, height, options
        href = "data:" + mimeType + ";base64," + data
        return addImage(href, x, y, width, height, options)

    # ========================================================================
    # Groups
    # Options: :id :opacity :filter :clipPath :translate :rotate :scale
    # ========================================================================

    func beginGroup options
        if options = NULL options = [] ok

        nGroupId++
        groupId = "group" + nGroupId

        if options[:id] != NULL
            groupId = options[:id]
            options[:id] = NULL
        ok

        elem  = '<g id="' + groupId + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '>'

        aGroupStack + len(aElements) + 1
        addElement(elem)

        return groupId

    func endGroup
        addElement('</g>')
        if len(aGroupStack) > 0
            del(aGroupStack, len(aGroupStack))
        ok
        return self

    # ========================================================================
    # Gradients
    # ========================================================================

    func createLinearGradient x1, y1, x2, y2, stops
        nGradientId++
        gradId = "linearGradient" + nGradientId

        defStr  = '<linearGradient id="' + gradId + '" '
        defStr += 'x1="' + svgNum(x1) + '%" y1="' + svgNum(y1) + '%" '
        defStr += 'x2="' + svgNum(x2) + '%" y2="' + svgNum(y2) + '%">'

        stopsLen = len(stops)
        for i = 1 to stopsLen
            stop    = stops[i]
            defStr += '<stop offset="' + svgNum(stop[1]) + '%" '
            defStr += 'stop-color="' + svgColorToHex(stop[2]) + '"'
            if len(stop) > 2
                defStr += ' stop-opacity="' + svgNum(stop[3]) + '"'
            ok
            defStr += '/>'
        next

        defStr += '</linearGradient>'
        aDefs + defStr

        return "url(#" + gradId + ")"

    func createRadialGradient cx, cy, r, stops
        nGradientId++
        gradId = "radialGradient" + nGradientId

        defStr  = '<radialGradient id="' + gradId + '" '
        defStr += 'cx="' + svgNum(cx) + '%" cy="' + svgNum(cy) + '%" r="' + svgNum(r) + '%">'

        stopsLen = len(stops)
        for i = 1 to stopsLen
            stop    = stops[i]
            defStr += '<stop offset="' + svgNum(stop[1]) + '%" '
            defStr += 'stop-color="' + svgColorToHex(stop[2]) + '"'
            if len(stop) > 2
                defStr += ' stop-opacity="' + svgNum(stop[3]) + '"'
            ok
            defStr += '/>'
        next

        defStr += '</radialGradient>'
        aDefs + defStr

        return "url(#" + gradId + ")"

    # ========================================================================
    # Filters
    # ========================================================================

    func createBlurFilter stdDeviation
        nFilterId++
        filterId = "blur" + nFilterId

        defStr  = '<filter id="' + filterId + '">'
        defStr += '<feGaussianBlur in="SourceGraphic" stdDeviation="' + svgNum(stdDeviation) + '"/>'
        defStr += '</filter>'
        aDefs + defStr

        return "url(#" + filterId + ")"

    func createShadowFilter dx, dy, blur, color
        nFilterId++
        filterId = "shadow" + nFilterId

        if color = NULL color = "black" ok

        defStr  = '<filter id="' + filterId + '" x="-50%" y="-50%" width="200%" height="200%">'
        defStr += '<feDropShadow dx="' + svgNum(dx) + '" dy="' + svgNum(dy) + '" '
        defStr += 'stdDeviation="' + svgNum(blur) + '" flood-color="' + svgColorToHex(color) + '"/>'
        defStr += '</filter>'
        aDefs + defStr

        return "url(#" + filterId + ")"

    func createGlowFilter blur, color
        nFilterId++
        filterId = "glow" + nFilterId

        if color = NULL color = "white" ok

        defStr  = '<filter id="' + filterId + '" x="-50%" y="-50%" width="200%" height="200%">'
        defStr += '<feGaussianBlur in="SourceAlpha" stdDeviation="' + svgNum(blur) + '" result="blur"/>'
        defStr += '<feFlood flood-color="' + svgColorToHex(color) + '"/>'
        defStr += '<feComposite in2="blur" operator="in"/>'
        defStr += '<feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>'
        defStr += '</filter>'
        aDefs + defStr

        return "url(#" + filterId + ")"

    # ========================================================================
    # Markers
    # ========================================================================

    func createArrowMarker size, color
        nMarkerId++
        markerId = "arrow" + nMarkerId

        if color = NULL color = "black" ok

        defStr  = '<marker id="' + markerId + '" viewBox="0 0 10 10" refX="9" refY="5" '
        defStr += 'markerWidth="' + svgNum(size) + '" markerHeight="' + svgNum(size) + '" orient="auto-start-reverse">'
        defStr += '<path d="M 0 0 L 10 5 L 0 10 z" fill="' + svgColorToHex(color) + '"/>'
        defStr += '</marker>'
        aDefs + defStr

        return markerId

    func createDotMarker size, color
        nMarkerId++
        markerId = "dot" + nMarkerId

        if color = NULL color = "black" ok

        defStr  = '<marker id="' + markerId + '" viewBox="0 0 10 10" refX="5" refY="5" '
        defStr += 'markerWidth="' + svgNum(size) + '" markerHeight="' + svgNum(size) + '">'
        defStr += '<circle cx="5" cy="5" r="4" fill="' + svgColorToHex(color) + '"/>'
        defStr += '</marker>'
        aDefs + defStr

        return markerId

    # ========================================================================
    # Patterns
    # ========================================================================

    func createStripePattern width, color1, color2, angle
        nPatternId++
        patternId = "stripe" + nPatternId

        if angle = NULL angle = 45 ok

        defStr  = '<pattern id="' + patternId + '" width="' + svgNum(width) + '" height="' + svgNum(width) + '" '
        defStr += 'patternUnits="userSpaceOnUse" patternTransform="rotate(' + svgNum(angle) + ')">'
        defStr += '<rect width="' + svgNum(width/2) + '" height="' + svgNum(width) + '" fill="' + svgColorToHex(color1) + '"/>'
        defStr += '<rect x="' + svgNum(width/2) + '" width="' + svgNum(width/2) + '" height="' + svgNum(width) + '" fill="' + svgColorToHex(color2) + '"/>'
        defStr += '</pattern>'
        aDefs + defStr

        return "url(#" + patternId + ")"

    func createDotPattern spacing, radius, color, bgColor
        nPatternId++
        patternId = "dots" + nPatternId

        if bgColor = NULL bgColor = "white" ok

        defStr  = '<pattern id="' + patternId + '" width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" patternUnits="userSpaceOnUse">'
        defStr += '<rect width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" fill="' + svgColorToHex(bgColor) + '"/>'
        defStr += '<circle cx="' + svgNum(spacing/2) + '" cy="' + svgNum(spacing/2) + '" r="' + svgNum(radius) + '" fill="' + svgColorToHex(color) + '"/>'
        defStr += '</pattern>'
        aDefs + defStr

        return "url(#" + patternId + ")"

    func createGridPattern spacing, strokeWidth, color, bgColor
        nPatternId++
        patternId = "grid" + nPatternId

        if bgColor     = NULL bgColor     = "white" ok
        if strokeWidth = NULL strokeWidth = 1 ok

        defStr  = '<pattern id="' + patternId + '" width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" patternUnits="userSpaceOnUse">'
        defStr += '<rect width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" fill="' + svgColorToHex(bgColor) + '"/>'
        defStr += '<path d="M ' + svgNum(spacing) + ' 0 L 0 0 0 ' + svgNum(spacing) + '" fill="none" stroke="' + svgColorToHex(color) + '" stroke-width="' + svgNum(strokeWidth) + '"/>'
        defStr += '</pattern>'
        aDefs + defStr

        return "url(#" + patternId + ")"

    # ========================================================================
    # Clipping
    # ========================================================================

    func createClipPath elements
        nClipId++
        clipId = "clip" + nClipId

        defStr  = '<clipPath id="' + clipId + '">'
        elementsLen = len(elements)
        for i = 1 to elementsLen
            defStr += elements[i]
        next
        defStr += '</clipPath>'
        aDefs + defStr

        return "url(#" + clipId + ")"

    func createCircleClip cx, cy, r
        return createClipPath(['<circle cx="' + svgNum(cx) + '" cy="' + svgNum(cy) + '" r="' + svgNum(r) + '"/>'])

    func createRectClip x, y, width, height
        return createClipPath(['<rect x="' + svgNum(x) + '" y="' + svgNum(y) + '" width="' + svgNum(width) + '" height="' + svgNum(height) + '"/>'])

    # ========================================================================
    # Charts - all internal drawing uses per-element options
    # ========================================================================

    func addBarChart data, x, y, width, height, options
        if options = NULL options = [] ok

        labels    = data[:labels]
        values    = data[:values]
        labelsLen = len(labels)

        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47"]
        if options[:colors] != NULL colors = options[:colors] ok

        padding = 40
        chartX  = x + padding
        chartY  = y + padding
        chartW  = width  - padding * 2
        chartH  = height - padding * 2

        barWidth = chartW / labelsLen * 0.7
        barGap   = chartW / labelsLen * 0.3

        maxVal = 0
        for i = 1 to labelsLen
            if values[i] > maxVal maxVal = values[i] ok
        next
        if maxVal = 0 maxVal = 1 ok

        addLine(chartX, chartY, chartX, chartY + chartH,
            [:stroke = "#666666", :strokeWidth = 1, :fill = "none"])
        addLine(chartX, chartY + chartH, chartX + chartW, chartY + chartH,
            [:stroke = "#666666", :strokeWidth = 1, :fill = "none"])

        for i = 1 to labelsLen
            barH     = (values[i] / maxVal) * chartH
            barX     = chartX + (i - 1) * (barWidth + barGap) + barGap / 2
            barY     = chartY + chartH - barH
            colorIdx = ((i - 1) % len(colors)) + 1

            addRect(barX, barY, barWidth, barH, [:fill = colors[colorIdx]])
            addTextCentered(labels[i], barX + barWidth / 2, chartY + chartH + 15,
                [:fontSize = 10, :fill = "#333333"])

            if options[:showValues] = true
                addTextCentered("" + values[i], barX + barWidth / 2, barY - 5,
                    [:fontSize = 10, :fill = "#333333"])
            ok
        next

        if options[:title] != NULL
            addTextCentered(options[:title], x + width / 2, y + 15,
                [:fontSize = 14, :fontWeight = "bold", :fill = "#333333"])
        ok

        return self

    func addLineChart data, x, y, width, height, options
        if options = NULL options = [] ok

        labels    = data[:labels]
        values    = data[:values]
        labelsLen = len(labels)

        color = "#4472C4"
        if options[:color] != NULL color = options[:color] ok

        padding = 40
        chartX  = x + padding
        chartY  = y + padding
        chartW  = width  - padding * 2
        chartH  = height - padding * 2

        maxVal = 0
        for i = 1 to labelsLen
            if values[i] > maxVal maxVal = values[i] ok
        next
        if maxVal = 0 maxVal = 1 ok

        addLine(chartX, chartY, chartX, chartY + chartH,
            [:stroke = "#666666", :strokeWidth = 1, :fill = "none"])
        addLine(chartX, chartY + chartH, chartX + chartW, chartY + chartH,
            [:stroke = "#666666", :strokeWidth = 1, :fill = "none"])

        points = []
        stepX  = chartW / (labelsLen - 1)
        for i = 1 to labelsLen
            px = chartX + (i - 1) * stepX
            py = chartY + chartH - (values[i] / maxVal) * chartH
            points + [px, py]
        next

        addPolyline(points, [:stroke = color, :strokeWidth = 2, :fill = "none"])

        pointsLen = len(points)
        for i = 1 to pointsLen
            addCircle(points[i][1], points[i][2], 4, [:fill = color])
            addTextCentered(labels[i], points[i][1], chartY + chartH + 15,
                [:fontSize = 10, :fill = "#333333"])
        next

        if options[:title] != NULL
            addTextCentered(options[:title], x + width / 2, y + 15,
                [:fontSize = 14, :fontWeight = "bold", :fill = "#333333"])
        ok

        return self

    func addPieChart data, cx, cy, radius, options
        if options = NULL options = [] ok

        labels    = data[:labels]
        values    = data[:values]
        labelsLen = len(labels)

        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47", "#FF6384", "#36A2EB"]
        if options[:colors] != NULL colors = options[:colors] ok

        total = 0
        for i = 1 to labelsLen total += values[i] next
        if total = 0 total = 1 ok

        startAngle = -90
        for i = 1 to labelsLen
            sliceAngle = (values[i] / total) * 360
            endAngle   = startAngle + sliceAngle
            colorIdx   = ((i - 1) % len(colors)) + 1

            startRad = startAngle * 3.14159 / 180
            endRad   = endAngle   * 3.14159 / 180

            x1 = cx + radius * cos(startRad)
            y1 = cy + radius * sin(startRad)
            x2 = cx + radius * cos(endRad)
            y2 = cy + radius * sin(endRad)

            largeArc = 0
            if sliceAngle > 180 largeArc = 1 ok

            d  = "M " + svgNum(cx) + " " + svgNum(cy) + " "
            d += "L " + svgNum(x1) + " " + svgNum(y1) + " "
            d += "A " + svgNum(radius) + " " + svgNum(radius) + " 0 " + largeArc + " 1 "
            d += svgNum(x2) + " " + svgNum(y2) + " Z"

            addPath(d, [:fill = colors[colorIdx], :stroke = "white", :strokeWidth = 2])

            startAngle = endAngle
        next

        if options[:showLegend] = true
            legendX = cx + radius + 20
            legendY = cy - radius + 20
            for i = 1 to labelsLen
                colorIdx = ((i - 1) % len(colors)) + 1
                addRect(legendX, legendY + (i - 1) * 20, 12, 12, [:fill = colors[colorIdx]])
                pct = floor((values[i] / total) * 100)
                addText(labels[i] + " (" + pct + "%)", legendX + 18, legendY + (i - 1) * 20 + 10,
                    [:fontSize = 11, :fill = "#333333"])
            next
        ok

        if options[:title] != NULL
            addTextCentered(options[:title], cx, cy - radius - 20,
                [:fontSize = 14, :fontWeight = "bold", :fill = "#333333"])
        ok

        return self

    func addDonutChart data, cx, cy, outerRadius, innerRadius, options
        if options = NULL options = [] ok

        labels    = data[:labels]
        values    = data[:values]
        labelsLen = len(labels)

        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47"]
        if options[:colors] != NULL colors = options[:colors] ok

        total = 0
        for i = 1 to labelsLen total += values[i] next
        if total = 0 total = 1 ok

        startAngle = -90
        for i = 1 to labelsLen
            sliceAngle = (values[i] / total) * 360
            endAngle   = startAngle + sliceAngle
            colorIdx   = ((i - 1) % len(colors)) + 1

            startRad = startAngle * 3.14159 / 180
            endRad   = endAngle   * 3.14159 / 180

            ox1 = cx + outerRadius * cos(startRad)
            oy1 = cy + outerRadius * sin(startRad)
            ox2 = cx + outerRadius * cos(endRad)
            oy2 = cy + outerRadius * sin(endRad)

            ix1 = cx + innerRadius * cos(startRad)
            iy1 = cy + innerRadius * sin(startRad)
            ix2 = cx + innerRadius * cos(endRad)
            iy2 = cy + innerRadius * sin(endRad)

            largeArc = 0
            if sliceAngle > 180 largeArc = 1 ok

            d  = "M "  + svgNum(ox1) + " " + svgNum(oy1) + " "
            d += "A "  + svgNum(outerRadius) + " " + svgNum(outerRadius) + " 0 " + largeArc + " 1 "
            d += svgNum(ox2) + " " + svgNum(oy2) + " "
            d += "L "  + svgNum(ix2) + " " + svgNum(iy2) + " "
            d += "A "  + svgNum(innerRadius) + " " + svgNum(innerRadius) + " 0 " + largeArc + " 0 "
            d += svgNum(ix1) + " " + svgNum(iy1) + " Z"

            addPath(d, [:fill = colors[colorIdx], :stroke = "white", :strokeWidth = 2])

            startAngle = endAngle
        next

        if options[:centerText] != NULL
            addTextCentered(options[:centerText], cx, cy,
                [:fontSize = 16, :fontWeight = "bold", :fill = "#333333"])
        ok

        return self

    # ========================================================================
    # Diagrams
    # ========================================================================

    func addFlowchartBox text, x, y, width, height, options
        if options = NULL options = [] ok

        boxType   = "rect"
        if options[:type] != NULL boxType = options[:type] ok

        fillColor = "#4472C4"
        if options[:fill] != NULL fillColor = options[:fill] ok

        textColor = "white"
        if options[:textColor] != NULL textColor = options[:textColor] ok

        boxOpts = [:fill = fillColor, :stroke = "#333333", :strokeWidth = 1]

        switch boxType
            on "rect"
                addRect(x, y, width, height, boxOpts)
            on "rounded"
                addRoundedRect(x, y, width, height, 8, boxOpts)
            on "diamond"
                cx2 = x + width / 2
                cy2 = y + height / 2
                addPolygon([
                    [cx2, y],
                    [x + width, cy2],
                    [cx2, y + height],
                    [x, cy2]
                ], boxOpts)
            on "oval"
                addEllipse(x + width / 2, y + height / 2, width / 2, height / 2, boxOpts)
            on "parallelogram"
                offset = width * 0.15
                addPolygon([
                    [x + offset, y],
                    [x + width, y],
                    [x + width - offset, y + height],
                    [x, y + height]
                ], boxOpts)
        off

        addTextCentered(text, x + width / 2, y + height / 2,
            [:fontSize = 12, :fill = textColor])

        return self

    func addConnector x1, y1, x2, y2, options
        if options = NULL options = [] ok

        connType = "line"
        if options[:type] != NULL connType = options[:type] ok

        arrowId = NULL
        if options[:arrow] = true
            arrowId = createArrowMarker(6, "#333333")
        ok

        lineOpts = [:stroke = "#333333", :strokeWidth = 1.5, :fill = "none"]
        if arrowId != NULL lineOpts[:markerEnd] = arrowId ok

        switch connType
            on "line"
                addLine(x1, y1, x2, y2, lineOpts)
            on "elbow"
                midY = (y1 + y2) / 2
                d    = "M " + svgNum(x1) + " " + svgNum(y1) + " "
                d   += "L " + svgNum(x1) + " " + svgNum(midY) + " "
                d   += "L " + svgNum(x2) + " " + svgNum(midY) + " "
                d   += "L " + svgNum(x2) + " " + svgNum(y2)
                addPath(d, lineOpts)
            on "curve"
                midX = (x1 + x2) / 2
                d    = "M " + svgNum(x1) + " " + svgNum(y1) + " "
                d   += "C " + svgNum(midX) + " " + svgNum(y1) + " "
                d   += svgNum(midX) + " " + svgNum(y2) + " "
                d   += svgNum(x2) + " " + svgNum(y2)
                addPath(d, lineOpts)
        off

        return self

    func addOrgChartBox name, title, x, y, width, height, options
        if options = NULL options = [] ok

        fillColor = "#4472C4"
        if options[:fill] != NULL fillColor = options[:fill] ok

        addRoundedRect(x, y, width, height, 5,
            [:fill = fillColor, :stroke = "#333333", :strokeWidth = 1])
        addTextCentered(name, x + width / 2, y + height / 2 - 8,
            [:fontSize = 12, :fontWeight = "bold", :fill = "white"])
        addTextCentered(title, x + width / 2, y + height / 2 + 10,
            [:fontSize = 10, :fill = "white"])

        return self

    # ========================================================================
    # Icons and Symbols
    # ========================================================================

    func addCheckmark x, y, size, options
        if options = NULL options = [] ok

        color = "#2E7D32"
        if options[:color] != NULL color = options[:color] ok

        d  = "M " + svgNum(x + size * 0.15) + " " + svgNum(y + size * 0.5)  + " "
        d += "L " + svgNum(x + size * 0.4)  + " " + svgNum(y + size * 0.75) + " "
        d += "L " + svgNum(x + size * 0.85) + " " + svgNum(y + size * 0.25)

        addPath(d, [:stroke = color, :strokeWidth = size / 6,
                    :fill = "none", :strokeLineCap = "round", :strokeLineJoin = "round"])
        return self

    func addCross x, y, size, options
        if options = NULL options = [] ok

        color = "#C62828"
        if options[:color] != NULL color = options[:color] ok

        lineOpts = [:stroke = color, :strokeWidth = size / 6, :fill = "none", :strokeLineCap = "round"]
        addLine(x + size * 0.2, y + size * 0.2, x + size * 0.8, y + size * 0.8, lineOpts)
        addLine(x + size * 0.8, y + size * 0.2, x + size * 0.2, y + size * 0.8, lineOpts)

        return self

    func addPlus x, y, size, options
        if options = NULL options = [] ok

        color = "#1565C0"
        if options[:color] != NULL color = options[:color] ok

        mid      = size / 2
        lineOpts = [:stroke = color, :strokeWidth = size / 6, :fill = "none", :strokeLineCap = "round"]
        addLine(x + mid,         y + size * 0.15, x + mid,         y + size * 0.85, lineOpts)
        addLine(x + size * 0.15, y + mid,         x + size * 0.85, y + mid,         lineOpts)

        return self

    func addMinus x, y, size, options
        if options = NULL options = [] ok

        color = "#E65100"
        if options[:color] != NULL color = options[:color] ok

        mid = size / 2
        addLine(x + size * 0.15, y + mid, x + size * 0.85, y + mid,
            [:stroke = color, :strokeWidth = size / 6, :fill = "none", :strokeLineCap = "round"])

        return self

    func addArrowIcon x, y, size, direction, options
        if options = NULL options = [] ok

        color    = "#333333"
        if options[:color] != NULL color = options[:color] ok

        mid      = size / 2
        polyOpts = [:fill = color]

        switch direction
            on "right"
                addPolygon([
                    [x + size * 0.2, y + size * 0.3],
                    [x + size * 0.8, y + mid],
                    [x + size * 0.2, y + size * 0.7]
                ], polyOpts)
            on "left"
                addPolygon([
                    [x + size * 0.8, y + size * 0.3],
                    [x + size * 0.2, y + mid],
                    [x + size * 0.8, y + size * 0.7]
                ], polyOpts)
            on "up"
                addPolygon([
                    [x + size * 0.3, y + size * 0.8],
                    [x + mid,        y + size * 0.2],
                    [x + size * 0.7, y + size * 0.8]
                ], polyOpts)
            on "down"
                addPolygon([
                    [x + size * 0.3, y + size * 0.2],
                    [x + mid,        y + size * 0.8],
                    [x + size * 0.7, y + size * 0.2]
                ], polyOpts)
        off

        return self

    # ========================================================================
    # Internal Helpers
    # ========================================================================

    func getStyleAttr options
        attr = ""

        # Fill (default: black)
        fill = "#000000"
        if options[:fill] != NULL
            fill = svgColorToHex(options[:fill])
        ok
        attr += ' fill="' + fill + '"'

        if options[:fillOpacity] != NULL
            attr += ' fill-opacity="' + svgNum(options[:fillOpacity]) + '"'
        ok

        # Stroke
        stroke = "none"
        if options[:stroke] != NULL
            stroke = svgColorToHex(options[:stroke])
        ok
        if stroke != "none"
            attr += ' stroke="' + stroke + '"'

            strokeWidth = 1
            if options[:strokeWidth] != NULL strokeWidth = options[:strokeWidth] ok
            attr += ' stroke-width="' + svgNum(strokeWidth) + '"'

            if options[:strokeLineCap] != NULL
                attr += ' stroke-linecap="' + options[:strokeLineCap] + '"'
            ok
            if options[:strokeLineJoin] != NULL
                attr += ' stroke-linejoin="' + options[:strokeLineJoin] + '"'
            ok
            if options[:strokeDash] != NULL
                attr += ' stroke-dasharray="' + options[:strokeDash] + '"'
            ok
        ok

        if options[:strokeOpacity] != NULL
            attr += ' stroke-opacity="' + svgNum(options[:strokeOpacity]) + '"'
        ok

        if options[:opacity] != NULL
            attr += ' opacity="' + svgNum(options[:opacity]) + '"'
        ok

        if options[:filter]   != NULL attr += ' filter="'    + options[:filter]   + '"' ok
        if options[:clipPath] != NULL attr += ' clip-path="' + options[:clipPath] + '"' ok

        if options[:markerEnd]   != NULL attr += ' marker-end="url(#'   + options[:markerEnd]   + ')"' ok
        if options[:markerStart] != NULL attr += ' marker-start="url(#' + options[:markerStart] + ')"' ok

        if options[:id]    != NULL attr += ' id="'    + options[:id]    + '"' ok
        if options[:class] != NULL attr += ' class="' + options[:class] + '"' ok

        return attr

    func getTextStyleAttr options
        attr = ""

        fontFamily = "Arial, sans-serif"
        if options[:fontFamily] != NULL fontFamily = options[:fontFamily] ok
        attr += ' font-family="' + fontFamily + '"'

        fontSize = 14
        if options[:fontSize] != NULL fontSize = options[:fontSize] ok
        attr += ' font-size="' + svgNum(fontSize) + '"'

        if options[:fontWeight] != NULL and options[:fontWeight] != "normal"
            attr += ' font-weight="' + options[:fontWeight] + '"'
        ok
        if options[:fontStyle] != NULL and options[:fontStyle] != "normal"
            attr += ' font-style="' + options[:fontStyle] + '"'
        ok
        if options[:textAnchor] != NULL and options[:textAnchor] != "start"
            attr += ' text-anchor="' + options[:textAnchor] + '"'
        ok
        if options[:dominantBaseline] != NULL
            attr += ' dominant-baseline="' + options[:dominantBaseline] + '"'
        ok
        if options[:textDecoration] != NULL
            attr += ' text-decoration="' + options[:textDecoration] + '"'
        ok

        return attr

    func getTransformAttr options
        if options[:transform] != NULL
            return ' transform="' + options[:transform] + '"'
        ok

        transforms = ""

        if options[:translate] != NULL
            t = options[:translate]
            transforms += "translate(" + svgNum(t[1]) + "," + svgNum(t[2]) + ") "
        ok
        if options[:rotate] != NULL
            r = options[:rotate]
            if isList(r)
                transforms += "rotate(" + svgNum(r[1]) + "," + svgNum(r[2]) + "," + svgNum(r[3]) + ") "
            else
                transforms += "rotate(" + svgNum(r) + ") "
            ok
        ok
        if options[:scale] != NULL
            s = options[:scale]
            if isList(s)
                transforms += "scale(" + svgNum(s[1]) + "," + svgNum(s[2]) + ") "
            else
                transforms += "scale(" + svgNum(s) + ") "
            ok
        ok
        if options[:skewX] != NULL transforms += "skewX(" + svgNum(options[:skewX]) + ") " ok
        if options[:skewY] != NULL transforms += "skewY(" + svgNum(options[:skewY]) + ") " ok

        if len(transforms) > 0
            return ' transform="' + trim(transforms) + '"'
        ok

        return ""

    func addElement elem
        aElements + elem

    func getElementTag element
        start   = 2
        endPos  = 2
        elemLen = len(element)
        for i = 2 to elemLen
            c = element[i]
            if c = " " or c = ">" or c = "/"
                endPos = i - 1
                exit
            ok
        next
        return substr(element, start, endPos - start + 1)

    # ========================================================================
    # Output
    # ========================================================================

    func toString
        svgOutput  = '<?xml version="1.0" encoding="UTF-8"?>' + char(10)
        svgOutput += '<svg xmlns="http://www.w3.org/2000/svg" '
        svgOutput += 'width="' + svgNum(nWidth) + '" height="' + svgNum(nHeight) + '" '
        svgOutput += 'viewBox="' + cViewBox + '">' + char(10)

        if cBackground != NULL and cBackground != "none"
            svgOutput += '<rect width="100%" height="100%" fill="' + cBackground + '"/>' + char(10)
        ok

        if len(aDefs) > 0
            svgOutput += '<defs>' + char(10)
            defsLen = len(aDefs)
            for i = 1 to defsLen
                svgOutput += '  ' + aDefs[i] + char(10)
            next
            svgOutput += '</defs>' + char(10)
        ok

        elementsLen = len(aElements)
        for i = 1 to elementsLen
            svgOutput += '  ' + aElements[i] + char(10)
        next

        svgOutput += '</svg>'
        return svgOutput

    func save filename
        content = toString()
        write(filename, content)
        return fexists(filename)

    func toDataURI
        content = toString()
        return "data:image/svg+xml," + content
