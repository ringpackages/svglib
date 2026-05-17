/*
    SVGLib - SVG Graphics Library for Ring Programming Language
*/

# ============================================================================
# SVGPath Class - Path Builder
# ============================================================================

class SVGPath

    oSVG
    cPath
    
    func init svg
        oSVG = svg
        cPath = ""
        return self
    
    func moveTo x, y
        cPath += "M " + svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func lineTo x, y
        cPath += "L " + svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func horizontalTo x
        cPath += "H " + svgNum(x) + " "
        return self
    
    func verticalTo y
        cPath += "V " + svgNum(y) + " "
        return self
    
    func curveTo x1, y1, x2, y2, x, y
        cPath += "C " + svgNum(x1) + " " + svgNum(y1) + " "
        cPath += svgNum(x2) + " " + svgNum(y2) + " "
        cPath += svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func smoothCurveTo x2, y2, x, y
        cPath += "S " + svgNum(x2) + " " + svgNum(y2) + " "
        cPath += svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func quadraticTo x1, y1, x, y
        cPath += "Q " + svgNum(x1) + " " + svgNum(y1) + " "
        cPath += svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func smoothQuadraticTo x, y
        cPath += "T " + svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func arcTo rx, ry, rotation, largeArc, sweep, x, y
        cPath += "A " + svgNum(rx) + " " + svgNum(ry) + " "
        cPath += svgNum(rotation) + " " + largeArc + " " + sweep + " "
        cPath += svgNum(x) + " " + svgNum(y) + " "
        return self
    
    func closePath
        cPath += "Z "
        return self
    
    func getPath
        return trim(cPath)
    
    func draw options
        oSVG.addPath(getPath(), options)
        return oSVG
