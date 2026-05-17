/*
    RingSVGLib - SVG Graphics Library for Ring Programming Language
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
    colors = [
        :black = "#000000",
        :white = "#FFFFFF",
        :red = "#FF0000",
        :green = "#00FF00",
        :blue = "#0000FF",
        :yellow = "#FFFF00",
        :orange = "#FFA500",
        :purple = "#800080",
        :pink = "#FFC0CB",
        :gray = "#808080",
        :grey = "#808080",
        :navy = "#000080",
        :teal = "#008080",
        :maroon = "#800000",
        :silver = "#C0C0C0",
        :lime = "#00FF00",
        :aqua = "#00FFFF",
        :cyan = "#00FFFF",
        :fuchsia = "#FF00FF",
        :magenta = "#FF00FF",
        :olive = "#808000",
        :brown = "#A52A2A",
        :coral = "#FF7F50",
        :crimson = "#DC143C",
        :gold = "#FFD700",
        :indigo = "#4B0082",
        :ivory = "#FFFFF0",
        :khaki = "#F0E68C",
        :lavender = "#E6E6FA",
        :salmon = "#FA8072",
        :tan = "#D2B48C",
        :violet = "#EE82EE",
        :wheat = "#F5DEB3",
        :skyblue = "#87CEEB",
        :steelblue = "#4682B4",
        :tomato = "#FF6347",
        :turquoise = "#40E0D0"
    ]
    
    if colors[color] != NULL
        return colors[color]
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
    # Format number for SVG (remove trailing zeros)
    if isNumber(value)
        if value = floor(value)
            return "" + value
        else
            return "" + value
        ok
    ok
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
