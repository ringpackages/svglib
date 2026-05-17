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
    
    # Elements
    aElements
    aDefs
    
    # Current style state
    cFill
    cStroke
    nStrokeWidth
    cStrokeLineCap
    cStrokeLineJoin
    cStrokeDashArray
    nOpacity
    nFillOpacity
    nStrokeOpacity
    
    # Text defaults
    cFontFamily
    nFontSize
    cFontWeight
    cFontStyle
    cTextAnchor
    
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
        nWidth = width
        nHeight = height
        cViewBox = "0 0 " + width + " " + height
        cBackground = NULL
        
        aElements = []
        aDefs = []
        
        # Default styles
        cFill = "#000000"
        cStroke = "none"
        nStrokeWidth = 1
        cStrokeLineCap = "butt"
        cStrokeLineJoin = "miter"
        cStrokeDashArray = ""
        nOpacity = 1
        nFillOpacity = 1
        nStrokeOpacity = 1
        
        # Text defaults
        cFontFamily = "Arial, sans-serif"
        nFontSize = 14
        cFontWeight = "normal"
        cFontStyle = "normal"
        cTextAnchor = "start"
        
        # ID counters
        nGradientId = 0
        nFilterId = 0
        nClipId = 0
        nMarkerId = 0
        nPatternId = 0
        nGroupId = 0
        
        aGroupStack = []
        
        return self
    
    # ========================================================================
    # Canvas Settings
    # ========================================================================
    
    func setSize width, height
        nWidth = width
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
    # Style Settings
    # ========================================================================
    
    func setFill color
        cFill = svgColorToHex(color)
        return self
    
    func setStroke color, width
        cStroke = svgColorToHex(color)
        if width != NULL
            nStrokeWidth = width
        ok
        return self
    
    func setStrokeWidth width
        nStrokeWidth = width
        return self
    
    func setStrokeDash dashArray
        cStrokeDashArray = dashArray
        return self
    
    func setStrokeLineCap cap
        cStrokeLineCap = cap
        return self
    
    func setStrokeLineJoin join
        cStrokeLineJoin = join
        return self
    
    func setOpacity opacity
        nOpacity = opacity
        return self
    
    func setFillOpacity opacity
        nFillOpacity = opacity
        return self
    
    func setStrokeOpacity opacity
        nStrokeOpacity = opacity
        return self
    
    func noFill
        cFill = "none"
        return self
    
    func noStroke
        cStroke = "none"
        return self
    
    func resetStyle
        cFill = "#000000"
        cStroke = "none"
        nStrokeWidth = 1
        cStrokeLineCap = "butt"
        cStrokeLineJoin = "miter"
        cStrokeDashArray = ""
        nOpacity = 1
        nFillOpacity = 1
        nStrokeOpacity = 1
        return self
    
    # ========================================================================
    # Text Settings
    # ========================================================================
    
    func setFont family, size
        cFontFamily = family
        if size != NULL
            nFontSize = size
        ok
        return self
    
    func setFontSize size
        nFontSize = size
        return self
    
    func setFontWeight weight
        cFontWeight = weight
        return self
    
    func setFontStyle style
        cFontStyle = style
        return self
    
    func setTextAnchor anchor
        cTextAnchor = anchor
        return self
    
    # ========================================================================
    # Basic Shapes
    # ========================================================================
    
    func addRect x, y, width, height, options
        if options = NULL options = [] ok
        
        elem = '<rect x="' + svgNum(x) + '" y="' + svgNum(y) + '" '
        elem += 'width="' + svgNum(width) + '" height="' + svgNum(height) + '"'
        
        # Rounded corners
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
        
        elem = '<circle cx="' + svgNum(cx) + '" cy="' + svgNum(cy) + '" r="' + svgNum(r) + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'
        
        addElement(elem)
        return self
    
    func addEllipse cx, cy, rx, ry, options
        if options = NULL options = [] ok
        
        elem = '<ellipse cx="' + svgNum(cx) + '" cy="' + svgNum(cy) + '" '
        elem += 'rx="' + svgNum(rx) + '" ry="' + svgNum(ry) + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'
        
        addElement(elem)
        return self
    
    func addLine x1, y1, x2, y2, options
        if options = NULL options = [] ok
        
        # Lines need stroke
        if options[:stroke] = NULL and cStroke = "none"
            options[:stroke] = cFill
        ok
        
        elem = '<line x1="' + svgNum(x1) + '" y1="' + svgNum(y1) + '" '
        elem += 'x2="' + svgNum(x2) + '" y2="' + svgNum(y2) + '"'
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
        
        elem = '<polyline points="' + pointsStr + '"'
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
        
        elem = '<polygon points="' + pointsStr + '"'
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
        angleStep = 360 / points / 2
        
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
        
        # Convert angles to radians
        startRad = startAngle * 3.14159 / 180
        endRad = endAngle * 3.14159 / 180
        
        # Calculate start and end points
        x1 = cx + r * cos(startRad)
        y1 = cy + r * sin(startRad)
        x2 = cx + r * cos(endRad)
        y2 = cy + r * sin(endRad)
        
        # Large arc flag
        largeArc = 0
        if (endAngle - startAngle) > 180
            largeArc = 1
        ok
        
        # Path data
        d = "M " + svgNum(x1) + " " + svgNum(y1) + " "
        d += "A " + svgNum(r) + " " + svgNum(r) + " 0 " + largeArc + " 1 "
        d += svgNum(x2) + " " + svgNum(y2)
        
        options[:fill] = "none"
        if options[:stroke] = NULL
            options[:stroke] = cFill
        ok
        
        return addPath(d, options)
    
    # ========================================================================
    # Path
    # ========================================================================
    
    func addPath d, options
        if options = NULL options = [] ok
        
        elem = '<path d="' + d + '"'
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '/>'
        
        addElement(elem)
        return self
    
    func createPath
        return new SVGPath(self)
    
    # ========================================================================
    # Text
    # ========================================================================
    
    func addText text, x, y, options
        if options = NULL options = [] ok
        
        elem = '<text x="' + svgNum(x) + '" y="' + svgNum(y) + '"'
        elem += getTextStyleAttr(options)
        elem += getStyleAttr(options)
        elem += getTransformAttr(options)
        elem += '>' + svgXmlEsc(text) + '</text>'
        
        addElement(elem)
        return self
    
    func addTextCentered text, x, y, options
        if options = NULL options = [] ok
        options[:textAnchor] = "middle"
        options[:dominantBaseline] = "middle"
        return addText(text, x, y, options)
    
    func addTextPath text, pathId, options
        if options = NULL options = [] ok
        
        startOffset = "0%"
        if options[:startOffset] != NULL
            startOffset = options[:startOffset]
        ok
        
        elem = '<text'
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
        
        elem = '<text x="' + svgNum(x) + '" y="' + svgNum(y) + '"'
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
        
        elem = '<image href="' + svgXmlEsc(href) + '" '
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
    # ========================================================================
    
    func beginGroup options
        if options = NULL options = [] ok
        
        nGroupId++
        groupId = "group" + nGroupId
        
        if options[:id] != NULL
            groupId = options[:id]
            options[:id] = NULL   # prevent getStyleAttr from writing id a second time
        ok
        
        elem = '<g id="' + groupId + '"'
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
        
        defStr = '<linearGradient id="' + gradId + '" '
        defStr += 'x1="' + svgNum(x1) + '%" y1="' + svgNum(y1) + '%" '
        defStr += 'x2="' + svgNum(x2) + '%" y2="' + svgNum(y2) + '%">'
        
        stopsLen = len(stops)
        for i = 1 to stopsLen
            stop = stops[i]
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
        
        defStr = '<radialGradient id="' + gradId + '" '
        defStr += 'cx="' + svgNum(cx) + '%" cy="' + svgNum(cy) + '%" r="' + svgNum(r) + '%">'
        
        stopsLen = len(stops)
        for i = 1 to stopsLen
            stop = stops[i]
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
        
        defStr = '<filter id="' + filterId + '">'
        defStr += '<feGaussianBlur in="SourceGraphic" stdDeviation="' + svgNum(stdDeviation) + '"/>'
        defStr += '</filter>'
        aDefs + defStr
        
        return "url(#" + filterId + ")"
    
    func createShadowFilter dx, dy, blur, color
        nFilterId++
        filterId = "shadow" + nFilterId
        
        if color = NULL color = "black" ok
        
        defStr = '<filter id="' + filterId + '" x="-50%" y="-50%" width="200%" height="200%">'
        defStr += '<feDropShadow dx="' + svgNum(dx) + '" dy="' + svgNum(dy) + '" '
        defStr += 'stdDeviation="' + svgNum(blur) + '" flood-color="' + svgColorToHex(color) + '"/>'
        defStr += '</filter>'
        aDefs + defStr
        
        return "url(#" + filterId + ")"
    
    func createGlowFilter blur, color
        nFilterId++
        filterId = "glow" + nFilterId
        
        if color = NULL color = "white" ok
        
        defStr = '<filter id="' + filterId + '" x="-50%" y="-50%" width="200%" height="200%">'
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
        
        if color = NULL color = cFill ok
        
        defStr = '<marker id="' + markerId + '" viewBox="0 0 10 10" refX="9" refY="5" '
        defStr += 'markerWidth="' + svgNum(size) + '" markerHeight="' + svgNum(size) + '" orient="auto-start-reverse">'
        defStr += '<path d="M 0 0 L 10 5 L 0 10 z" fill="' + svgColorToHex(color) + '"/>'
        defStr += '</marker>'
        aDefs + defStr
        
        return markerId
    
    func createDotMarker size, color
        nMarkerId++
        markerId = "dot" + nMarkerId
        
        if color = NULL color = cFill ok
        
        defStr = '<marker id="' + markerId + '" viewBox="0 0 10 10" refX="5" refY="5" '
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
        
        defStr = '<pattern id="' + patternId + '" width="' + svgNum(width) + '" height="' + svgNum(width) + '" '
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
        
        defStr = '<pattern id="' + patternId + '" width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" patternUnits="userSpaceOnUse">'
        defStr += '<rect width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" fill="' + svgColorToHex(bgColor) + '"/>'
        defStr += '<circle cx="' + svgNum(spacing/2) + '" cy="' + svgNum(spacing/2) + '" r="' + svgNum(radius) + '" fill="' + svgColorToHex(color) + '"/>'
        defStr += '</pattern>'
        aDefs + defStr
        
        return "url(#" + patternId + ")"
    
    func createGridPattern spacing, strokeWidth, color, bgColor
        nPatternId++
        patternId = "grid" + nPatternId
        
        if bgColor = NULL bgColor = "white" ok
        if strokeWidth = NULL strokeWidth = 1 ok
        
        defStr = '<pattern id="' + patternId + '" width="' + svgNum(spacing) + '" height="' + svgNum(spacing) + '" patternUnits="userSpaceOnUse">'
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
        
        defStr = '<clipPath id="' + clipId + '">'
        
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
    # Charts
    # ========================================================================
    
    func addBarChart data, x, y, width, height, options
        if options = NULL options = [] ok
        
        labels = data[:labels]
        values = data[:values]
        labelsLen = len(labels)
        
        # Default colors
        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47"]
        if options[:colors] != NULL
            colors = options[:colors]
        ok
        
        # Calculate dimensions
        padding = 40
        chartX = x + padding
        chartY = y + padding
        chartW = width - padding * 2
        chartH = height - padding * 2
        
        barWidth = chartW / labelsLen * 0.7
        barGap = chartW / labelsLen * 0.3
        
        # Find max value
        maxVal = 0
        for i = 1 to labelsLen
            if values[i] > maxVal maxVal = values[i] ok
        next
        if maxVal = 0 maxVal = 1 ok
        
        # Draw axes
        setStroke("#666666", 1)
        noFill()
        addLine(chartX, chartY, chartX, chartY + chartH, NULL)
        addLine(chartX, chartY + chartH, chartX + chartW, chartY + chartH, NULL)
        
        # Draw bars
        noStroke()
        for i = 1 to labelsLen
            barH = (values[i] / maxVal) * chartH
            barX = chartX + (i - 1) * (barWidth + barGap) + barGap / 2
            barY = chartY + chartH - barH
            
            colorIdx = ((i - 1) % len(colors)) + 1
            setFill(colors[colorIdx])
            addRect(barX, barY, barWidth, barH, NULL)
            
            # Label
            setFill("#333333")
            addTextCentered(labels[i], barX + barWidth / 2, chartY + chartH + 15, [:fontSize = 10])
            
            # Value on bar
            if options[:showValues] = true
                addTextCentered("" + values[i], barX + barWidth / 2, barY - 5, [:fontSize = 10])
            ok
        next
        
        # Title
        if options[:title] != NULL
            setFill("#333333")
            addTextCentered(options[:title], x + width / 2, y + 15, [:fontSize = 14, :fontWeight = "bold"])
        ok
        
        resetStyle()
        return self
    
    func addLineChart data, x, y, width, height, options
        if options = NULL options = [] ok
        
        labels = data[:labels]
        values = data[:values]
        labelsLen = len(labels)
        
        color = "#4472C4"
        if options[:color] != NULL color = options[:color] ok
        
        # Calculate dimensions
        padding = 40
        chartX = x + padding
        chartY = y + padding
        chartW = width - padding * 2
        chartH = height - padding * 2
        
        # Find max value
        maxVal = 0
        for i = 1 to labelsLen
            if values[i] > maxVal maxVal = values[i] ok
        next
        if maxVal = 0 maxVal = 1 ok
        
        # Draw axes
        setStroke("#666666", 1)
        noFill()
        addLine(chartX, chartY, chartX, chartY + chartH, NULL)
        addLine(chartX, chartY + chartH, chartX + chartW, chartY + chartH, NULL)
        
        # Calculate points
        points = []
        stepX = chartW / (labelsLen - 1)
        for i = 1 to labelsLen
            px = chartX + (i - 1) * stepX
            py = chartY + chartH - (values[i] / maxVal) * chartH
            points + [px, py]
        next
        
        # Draw line
        setStroke(color, 2)
        noFill()
        addPolyline(points, NULL)
        
        # Draw points
        noStroke()
        setFill(color)
        pointsLen = len(points)
        for i = 1 to pointsLen
            addCircle(points[i][1], points[i][2], 4, NULL)
        next
        
        # Labels
        setFill("#333333")
        for i = 1 to labelsLen
            addTextCentered(labels[i], points[i][1], chartY + chartH + 15, [:fontSize = 10])
        next
        
        # Title
        if options[:title] != NULL
            addTextCentered(options[:title], x + width / 2, y + 15, [:fontSize = 14, :fontWeight = "bold"])
        ok
        
        resetStyle()
        return self
    
    func addPieChart data, cx, cy, radius, options
        if options = NULL options = [] ok
        
        labels = data[:labels]
        values = data[:values]
        labelsLen = len(labels)
        
        # Default colors
        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47", "#FF6384", "#36A2EB"]
        if options[:colors] != NULL
            colors = options[:colors]
        ok
        
        # Calculate total
        total = 0
        for i = 1 to labelsLen
            total += values[i]
        next
        if total = 0 total = 1 ok
        
        # Draw slices
        startAngle = -90
        for i = 1 to labelsLen
            sliceAngle = (values[i] / total) * 360
            endAngle = startAngle + sliceAngle
            
            colorIdx = ((i - 1) % len(colors)) + 1
            
            # Draw slice using path
            startRad = startAngle * 3.14159 / 180
            endRad = endAngle * 3.14159 / 180
            
            x1 = cx + radius * cos(startRad)
            y1 = cy + radius * sin(startRad)
            x2 = cx + radius * cos(endRad)
            y2 = cy + radius * sin(endRad)
            
            largeArc = 0
            if sliceAngle > 180 largeArc = 1 ok
            
            d = "M " + svgNum(cx) + " " + svgNum(cy) + " "
            d += "L " + svgNum(x1) + " " + svgNum(y1) + " "
            d += "A " + svgNum(radius) + " " + svgNum(radius) + " 0 " + largeArc + " 1 "
            d += svgNum(x2) + " " + svgNum(y2) + " Z"
            
            setFill(colors[colorIdx])
            setStroke("white", 2)
            addPath(d, NULL)
            
            startAngle = endAngle
        next
        
        # Legend
        if options[:showLegend] = true
            legendX = cx + radius + 20
            legendY = cy - radius + 20
            
            setFill("#333333")
            for i = 1 to labelsLen
                colorIdx = ((i - 1) % len(colors)) + 1
                
                noStroke()
                setFill(colors[colorIdx])
                addRect(legendX, legendY + (i - 1) * 20, 12, 12, NULL)
                
                setFill("#333333")
                pct = floor((values[i] / total) * 100)
                addText(labels[i] + " (" + pct + "%)", legendX + 18, legendY + (i - 1) * 20 + 10, [:fontSize = 11])
            next
        ok
        
        # Title
        if options[:title] != NULL
            setFill("#333333")
            addTextCentered(options[:title], cx, cy - radius - 20, [:fontSize = 14, :fontWeight = "bold"])
        ok
        
        resetStyle()
        return self
    
    func addDonutChart data, cx, cy, outerRadius, innerRadius, options
        if options = NULL options = [] ok
        
        labels = data[:labels]
        values = data[:values]
        labelsLen = len(labels)
        
        # Default colors
        colors = ["#4472C4", "#ED7D31", "#A5A5A5", "#FFC000", "#5B9BD5", "#70AD47"]
        if options[:colors] != NULL
            colors = options[:colors]
        ok
        
        # Calculate total
        total = 0
        for i = 1 to labelsLen
            total += values[i]
        next
        if total = 0 total = 1 ok
        
        # Draw slices
        startAngle = -90
        for i = 1 to labelsLen
            sliceAngle = (values[i] / total) * 360
            endAngle = startAngle + sliceAngle
            
            colorIdx = ((i - 1) % len(colors)) + 1
            
            startRad = startAngle * 3.14159 / 180
            endRad = endAngle * 3.14159 / 180
            
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
            
            d = "M " + svgNum(ox1) + " " + svgNum(oy1) + " "
            d += "A " + svgNum(outerRadius) + " " + svgNum(outerRadius) + " 0 " + largeArc + " 1 "
            d += svgNum(ox2) + " " + svgNum(oy2) + " "
            d += "L " + svgNum(ix2) + " " + svgNum(iy2) + " "
            d += "A " + svgNum(innerRadius) + " " + svgNum(innerRadius) + " 0 " + largeArc + " 0 "
            d += svgNum(ix1) + " " + svgNum(iy1) + " Z"
            
            setFill(colors[colorIdx])
            setStroke("white", 2)
            addPath(d, NULL)
            
            startAngle = endAngle
        next
        
        # Center text
        if options[:centerText] != NULL
            setFill("#333333")
            noStroke()
            addTextCentered(options[:centerText], cx, cy, [:fontSize = 16, :fontWeight = "bold"])
        ok
        
        resetStyle()
        return self
    
    # ========================================================================
    # Diagrams
    # ========================================================================
    
    func addFlowchartBox text, x, y, width, height, options
        if options = NULL options = [] ok
        
        boxType = "rect"
        if options[:type] != NULL boxType = options[:type] ok
        
        fillColor = "#4472C4"
        if options[:fill] != NULL fillColor = options[:fill] ok
        
        textColor = "white"
        if options[:textColor] != NULL textColor = options[:textColor] ok
        
        setFill(fillColor)
        setStroke("#333333", 1)
        
        switch boxType
            on "rect"
                addRect(x, y, width, height, NULL)
            on "rounded"
                addRoundedRect(x, y, width, height, 8, NULL)
            on "diamond"
                cx = x + width / 2
                cy = y + height / 2
                addPolygon([
                    [cx, y],
                    [x + width, cy],
                    [cx, y + height],
                    [x, cy]
                ], NULL)
            on "oval"
                addEllipse(x + width / 2, y + height / 2, width / 2, height / 2, NULL)
            on "parallelogram"
                offset = width * 0.15
                addPolygon([
                    [x + offset, y],
                    [x + width, y],
                    [x + width - offset, y + height],
                    [x, y + height]
                ], NULL)
        off
        
        setFill(textColor)
        noStroke()
        addTextCentered(text, x + width / 2, y + height / 2, [:fontSize = 12])
        
        resetStyle()
        return self
    
    func addConnector x1, y1, x2, y2, options
        if options = NULL options = [] ok
        
        connType = "line"
        if options[:type] != NULL connType = options[:type] ok
        
        arrowId = NULL
        if options[:arrow] = true
            arrowId = createArrowMarker(6, "#333333")
        ok
        
        setStroke("#333333", 1.5)
        noFill()
        
        switch connType
            on "line"
                addLine(x1, y1, x2, y2, [:markerEnd = arrowId])
            on "elbow"
                midY = (y1 + y2) / 2
                d = "M " + svgNum(x1) + " " + svgNum(y1) + " "
                d += "L " + svgNum(x1) + " " + svgNum(midY) + " "
                d += "L " + svgNum(x2) + " " + svgNum(midY) + " "
                d += "L " + svgNum(x2) + " " + svgNum(y2)
                addPath(d, [:markerEnd = arrowId])
            on "curve"
                midX = (x1 + x2) / 2
                d = "M " + svgNum(x1) + " " + svgNum(y1) + " "
                d += "C " + svgNum(midX) + " " + svgNum(y1) + " "
                d += svgNum(midX) + " " + svgNum(y2) + " "
                d += svgNum(x2) + " " + svgNum(y2)
                addPath(d, [:markerEnd = arrowId])
        off
        
        resetStyle()
        return self
    
    func addOrgChartBox name, title, x, y, width, height, options
        if options = NULL options = [] ok
        
        fillColor = "#4472C4"
        if options[:fill] != NULL fillColor = options[:fill] ok
        
        setFill(fillColor)
        setStroke("#333333", 1)
        addRoundedRect(x, y, width, height, 5, NULL)
        
        setFill("white")
        noStroke()
        addTextCentered(name, x + width / 2, y + height / 2 - 8, [:fontSize = 12, :fontWeight = "bold"])
        addTextCentered(title, x + width / 2, y + height / 2 + 10, [:fontSize = 10])
        
        resetStyle()
        return self
    
    # ========================================================================
    # Icons and Symbols
    # ========================================================================
    
    func addCheckmark x, y, size, options
        if options = NULL options = [] ok
        
        color = "#2E7D32"
        if options[:color] != NULL color = options[:color] ok
        
        setStroke(color, size / 6)
        noFill()
        setStrokeLineCap("round")
        setStrokeLineJoin("round")
        
        d = "M " + svgNum(x + size * 0.15) + " " + svgNum(y + size * 0.5) + " "
        d += "L " + svgNum(x + size * 0.4) + " " + svgNum(y + size * 0.75) + " "
        d += "L " + svgNum(x + size * 0.85) + " " + svgNum(y + size * 0.25)
        
        addPath(d, NULL)
        resetStyle()
        return self
    
    func addCross x, y, size, options
        if options = NULL options = [] ok
        
        color = "#C62828"
        if options[:color] != NULL color = options[:color] ok
        
        setStroke(color, size / 6)
        noFill()
        setStrokeLineCap("round")
        
        addLine(x + size * 0.2, y + size * 0.2, x + size * 0.8, y + size * 0.8, NULL)
        addLine(x + size * 0.8, y + size * 0.2, x + size * 0.2, y + size * 0.8, NULL)
        
        resetStyle()
        return self
    
    func addPlus x, y, size, options
        if options = NULL options = [] ok
        
        color = "#1565C0"
        if options[:color] != NULL color = options[:color] ok
        
        setStroke(color, size / 6)
        noFill()
        setStrokeLineCap("round")
        
        mid = size / 2
        addLine(x + mid, y + size * 0.15, x + mid, y + size * 0.85, NULL)
        addLine(x + size * 0.15, y + mid, x + size * 0.85, y + mid, NULL)
        
        resetStyle()
        return self
    
    func addMinus x, y, size, options
        if options = NULL options = [] ok
        
        color = "#E65100"
        if options[:color] != NULL color = options[:color] ok
        
        setStroke(color, size / 6)
        noFill()
        setStrokeLineCap("round")
        
        mid = size / 2
        addLine(x + size * 0.15, y + mid, x + size * 0.85, y + mid, NULL)
        
        resetStyle()
        return self
    
    func addArrowIcon x, y, size, direction, options
        if options = NULL options = [] ok
        
        color = "#333333"
        if options[:color] != NULL color = options[:color] ok
        
        setFill(color)
        noStroke()
        
        mid = size / 2
        switch direction
            on "right"
                addPolygon([
                    [x + size * 0.2, y + size * 0.3],
                    [x + size * 0.8, y + mid],
                    [x + size * 0.2, y + size * 0.7]
                ], NULL)
            on "left"
                addPolygon([
                    [x + size * 0.8, y + size * 0.3],
                    [x + size * 0.2, y + mid],
                    [x + size * 0.8, y + size * 0.7]
                ], NULL)
            on "up"
                addPolygon([
                    [x + size * 0.3, y + size * 0.8],
                    [x + mid, y + size * 0.2],
                    [x + size * 0.7, y + size * 0.8]
                ], NULL)
            on "down"
                addPolygon([
                    [x + size * 0.3, y + size * 0.2],
                    [x + mid, y + size * 0.8],
                    [x + size * 0.7, y + size * 0.2]
                ], NULL)
        off
        
        resetStyle()
        return self
    
    # ========================================================================
    # Animation
    # ========================================================================
    
    func addAnimatedElement element, animations
        # Add animation to an element
        animStr = ""
        
        animationsLen = len(animations)
        for i = 1 to animationsLen
            anim = animations[i]
            animType = anim[:type]
            
            animStr += '<animate'
            animStr += ' attributeName="' + anim[:attribute] + '"'
            if anim[:from] != NULL
                animStr += ' from="' + anim[:from] + '"'
            ok
            animStr += ' to="' + anim[:to] + '"'
            animStr += ' dur="' + anim[:duration] + '"'
            if anim[:repeatCount] != NULL
                animStr += ' repeatCount="' + anim[:repeatCount] + '"'
            ok
            if anim[:fill] != NULL
                animStr += ' fill="' + anim[:fill] + '"'
            ok
            animStr += '/>'
        next
        
        # Insert animation before closing tag
        if right(element, 2) = "/>"
            element = left(element, len(element) - 2) + ">" + animStr + "</" + getElementTag(element) + ">"
        ok
        
        return element
    
    # ========================================================================
    # Helper Methods
    # ========================================================================
    
    func getStyleAttr options
        attr = ""
        
        # Fill
        fill = cFill
        if options[:fill] != NULL
            fill = svgColorToHex(options[:fill])
        ok
        if fill != "none"
            attr += ' fill="' + fill + '"'
        else
            attr += ' fill="none"'
        ok
        
        # Fill opacity
        fillOpacity = nFillOpacity
        if options[:fillOpacity] != NULL fillOpacity = options[:fillOpacity] ok
        if fillOpacity < 1
            attr += ' fill-opacity="' + svgNum(fillOpacity) + '"'
        ok
        
        # Stroke
        stroke = cStroke
        if options[:stroke] != NULL
            stroke = svgColorToHex(options[:stroke])
        ok
        if stroke != "none"
            attr += ' stroke="' + stroke + '"'
            
            strokeWidth = nStrokeWidth
            if options[:strokeWidth] != NULL strokeWidth = options[:strokeWidth] ok
            attr += ' stroke-width="' + svgNum(strokeWidth) + '"'
            
            if cStrokeLineCap != "butt"
                attr += ' stroke-linecap="' + cStrokeLineCap + '"'
            ok
            if cStrokeLineJoin != "miter"
                attr += ' stroke-linejoin="' + cStrokeLineJoin + '"'
            ok
            if len(cStrokeDashArray) > 0
                attr += ' stroke-dasharray="' + cStrokeDashArray + '"'
            ok
        ok
        
        # Stroke opacity
        strokeOpacity = nStrokeOpacity
        if options[:strokeOpacity] != NULL strokeOpacity = options[:strokeOpacity] ok
        if strokeOpacity < 1
            attr += ' stroke-opacity="' + svgNum(strokeOpacity) + '"'
        ok
        
        # Overall opacity
        opacity = nOpacity
        if options[:opacity] != NULL opacity = options[:opacity] ok
        if opacity < 1
            attr += ' opacity="' + svgNum(opacity) + '"'
        ok
        
        # Filter
        if options[:filter] != NULL
            attr += ' filter="' + options[:filter] + '"'
        ok
        
        # Clip path
        if options[:clipPath] != NULL
            attr += ' clip-path="' + options[:clipPath] + '"'
        ok
        
        # Marker
        if options[:markerEnd] != NULL
            attr += ' marker-end="url(#' + options[:markerEnd] + ')"'
        ok
        if options[:markerStart] != NULL
            attr += ' marker-start="url(#' + options[:markerStart] + ')"'
        ok
        
        # ID
        if options[:id] != NULL
            attr += ' id="' + options[:id] + '"'
        ok
        
        # Class
        if options[:class] != NULL
            attr += ' class="' + options[:class] + '"'
        ok
        
        return attr
    
    func getTextStyleAttr options
        attr = ""
        
        fontFamily = cFontFamily
        if options[:fontFamily] != NULL fontFamily = options[:fontFamily] ok
        attr += ' font-family="' + fontFamily + '"'
        
        fontSize = nFontSize
        if options[:fontSize] != NULL fontSize = options[:fontSize] ok
        attr += ' font-size="' + svgNum(fontSize) + '"'
        
        fontWeight = cFontWeight
        if options[:fontWeight] != NULL fontWeight = options[:fontWeight] ok
        if fontWeight != "normal"
            attr += ' font-weight="' + fontWeight + '"'
        ok
        
        fontStyle = cFontStyle
        if options[:fontStyle] != NULL fontStyle = options[:fontStyle] ok
        if fontStyle != "normal"
            attr += ' font-style="' + fontStyle + '"'
        ok
        
        textAnchor = cTextAnchor
        if options[:textAnchor] != NULL textAnchor = options[:textAnchor] ok
        if textAnchor != "start"
            attr += ' text-anchor="' + textAnchor + '"'
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
        
        if options[:skewX] != NULL
            transforms += "skewX(" + svgNum(options[:skewX]) + ") "
        ok
        
        if options[:skewY] != NULL
            transforms += "skewY(" + svgNum(options[:skewY]) + ") "
        ok
        
        if len(transforms) > 0
            return ' transform="' + trim(transforms) + '"'
        ok
        
        return ""
    
    func addElement elem
        aElements + elem
    
    func getElementTag element
        # Extract tag name from element
        start = 2
        endPos = 2
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
        svgOutput = '<?xml version="1.0" encoding="UTF-8"?>' + char(10)
        svgOutput += '<svg xmlns="http://www.w3.org/2000/svg" '
        svgOutput += 'width="' + svgNum(nWidth) + '" height="' + svgNum(nHeight) + '" '
        svgOutput += 'viewBox="' + cViewBox + '">' + char(10)
        
        # Background
        if cBackground != NULL and cBackground != "none"
            svgOutput += '<rect width="100%" height="100%" fill="' + cBackground + '"/>' + char(10)
        ok
        
        # Definitions
        if len(aDefs) > 0
            svgOutput += '<defs>' + char(10)
            defsLen = len(aDefs)
            for i = 1 to defsLen
                svgOutput += '  ' + aDefs[i] + char(10)
            next
            svgOutput += '</defs>' + char(10)
        ok
        
        # Elements
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
        # Simple base64 encoding would go here
        # For now, return the raw SVG as data URI
        return "data:image/svg+xml," + content