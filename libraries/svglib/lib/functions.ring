/*
    SVGLib - SVG Graphics Library for Ring Programming Language
*/

# ============================================================================
# Helper Functions
# ============================================================================

func svgColorToHex color
    if color = NULL return "none" ok
    if !isString(color)
        color = "" + color
    ok
    
    if lower(color) = "none" or lower(color) = "transparent"
        return "none"
    ok
    
    # Pass through gradient/pattern/filter references unchanged
    if left(lower(color), 4) = "url("
        return color
    ok
    
    color = lower(color)
    
    if aSVGcolors[color] != NULL
        return aSVGcolors[color]
    ok
    
    if left(color, 1) != "#"
        return "#" + upper(color)
    ok
    
    return upper(color)

func svgXmlEsc str
    if str = NULL return "" ok
    str = "" + str
    str = substr(str, "&", "&amp;")
    str = substr(str, "<", "&lt;")
    str = substr(str, ">", "&gt;")
    str = substr(str, '"', "&quot;")
    str = substr(str, "'", "&apos;")
    return str

func svgNum value
    return "" + value

# Quick function to create simple SVG
func quickSVG filename, width, height, elements
    svg = new SVGWriter(width, height)
    
    elementsLen = len(elements)
    for i = 1 to elementsLen
        elem = elements[i]
        elemType = elem[1]
        
        switch elemType
            on "rect"
                svg.addRect(elem[2], elem[3], elem[4], elem[5], elem[6])
            on "circle"
                svg.addCircle(elem[2], elem[3], elem[4], elem[5])
            on "line"
                svg.addLine(elem[2], elem[3], elem[4], elem[5], elem[6])
            on "text"
                svg.addText(elem[2], elem[3], elem[4], elem[5])
        off
    next
    
    return svg.save(filename)
