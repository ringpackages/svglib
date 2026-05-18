/*
	This sample is shared by Azzeddine Remmal in Ring Group
*/
load "svglib.ring"

func main
    ? "Generating Diagrams..."
    generate_architecture_diagram()
    generate_flow_diagram()
    generate_classes_diagram()
    generate_routing_diagram()
    ? "Done!"

func generate_architecture_diagram
    svg = new SVGWriter(900, 550)
    svg.setBackground("#ffffff")

    # Title
    svg.addTextCentered("Ring MCP SDK Architecture", 450, 40, [:fontSize = 24, :fontWeight = "bold", :fill = "#2c3e50"])

    # Client Side
    svg.addRoundedRect(50, 80, 350, 400, 15, [:fill = "#ecf0f1", :stroke = "#bdc3c7", :strokeWidth = 2])
    svg.addTextCentered("MCP Client", 225, 110, [:fontSize = 20, :fontWeight = "bold", :fill = "#2980b9"])

    svg.addRoundedRect(80, 140, 290, 60, 8, [:fill = "#3498db", :stroke = "#2980b9", :strokeWidth = 2])
    svg.addTextCentered("Client API", 225, 175, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(80, 240, 290, 60, 8, [:fill = "#2ecc71", :stroke = "#27ae60", :strokeWidth = 2])
    svg.addTextCentered("Protocol Engine (Router)", 225, 275, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(80, 340, 290, 60, 8, [:fill = "#e67e22", :stroke = "#d35400", :strokeWidth = 2])
    svg.addTextCentered("Client Transports", 225, 365, [:fontSize = 16, :fill = "white"])
    svg.addTextCentered("(Stdio, HTTP)", 225, 385, [:fontSize = 12, :fill = "white"])

    # Server Side
    svg.addRoundedRect(500, 80, 350, 400, 15, [:fill = "#ecf0f1", :stroke = "#bdc3c7", :strokeWidth = 2])
    svg.addTextCentered("MCP Server", 675, 110, [:fontSize = 20, :fontWeight = "bold", :fill = "#8e44ad"])

    svg.addRoundedRect(530, 140, 290, 60, 8, [:fill = "#9b59b6", :stroke = "#8e44ad", :strokeWidth = 2])
    svg.addTextCentered("Server API (Tools, Resources, Prompts)", 675, 175, [:fontSize = 14, :fill = "white"])

    svg.addRoundedRect(530, 240, 290, 60, 8, [:fill = "#2ecc71", :stroke = "#27ae60", :strokeWidth = 2])
    svg.addTextCentered("Protocol Engine (Router)", 675, 275, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(530, 340, 290, 60, 8, [:fill = "#e67e22", :stroke = "#d35400", :strokeWidth = 2])
    svg.addTextCentered("Server Transports", 675, 365, [:fontSize = 16, :fill = "white"])
    svg.addTextCentered("(Stdio, HTTP, SSE, Stream)", 675, 385, [:fontSize = 12, :fill = "white"])

    # Arrows inside Client
    svg.addLine(225, 200, 225, 240, [:stroke = "#7f8c8d", :strokeWidth = 2])
    svg.addLine(225, 300, 225, 340, [:stroke = "#7f8c8d", :strokeWidth = 2])

    # Arrows inside Server
    svg.addLine(675, 200, 675, 240, [:stroke = "#7f8c8d", :strokeWidth = 2])
    svg.addLine(675, 300, 675, 340, [:stroke = "#7f8c8d", :strokeWidth = 2])

    # Communication lines
    arrow = svg.createArrowMarker(10, "#e74c3c")
    svg.addLine(370, 370, 530, 370, [:stroke = "#e74c3c", :strokeWidth = 3, :markerEnd = arrow, :strokeDash = "5,5"])
    svg.addTextCentered("JSON-RPC Messages", 450, 360, [:fontSize = 12, :fill = "#c0392b"])

    svg.save("mcp_architecture.svg")
    ? "- mcp_architecture.svg created successfully!"

func generate_flow_diagram
    svg = new SVGWriter(800, 500)
    svg.setBackground("#ffffff")

    svg.addTextCentered("Ring MCP Message Flow", 400, 40, [:fontSize = 24, :fontWeight = "bold", :fill = "#2c3e50"])

    # Entities
    colors = ["#3498db", "#9b59b6"]
    svg.addRoundedRect(100, 80, 200, 50, 8, [:fill = colors[1]])
    svg.addTextCentered("Client Transport", 200, 110, [:fontSize = 16, :fill = "white"])
    
    svg.addRoundedRect(500, 80, 200, 50, 8, [:fill = colors[2]])
    svg.addTextCentered("Server Transport", 600, 110, [:fontSize = 16, :fill = "white"])

    # Lifelines
    svg.addLine(200, 130, 200, 450, [:stroke = "#bdc3c7", :strokeWidth = 2, :strokeDash = "5,5"])
    svg.addLine(600, 130, 600, 450, [:stroke = "#bdc3c7", :strokeWidth = 2, :strokeDash = "5,5"])

    # Messages
    arrowRight = svg.createArrowMarker(8, "#2ecc71")
    arrowLeft = svg.createArrowMarker(8, "#e74c3c")

    # 1. Initialize
    y = 180
    svg.addLine(200, y, 600, y, [:stroke = "#2ecc71", :strokeWidth = 2, :markerEnd = arrowRight])
    svg.addTextCentered("Request: initialize", 400, y - 10, [:fontSize = 14, :fill = "#27ae60"])

    # 1. Initialize Response
    y += 50
    svg.addLine(600, y, 200, y, [:stroke = "#e74c3c", :strokeWidth = 2, :markerEnd = arrowLeft])
    svg.addTextCentered("Response: capabilities & info", 400, y - 10, [:fontSize = 14, :fill = "#c0392b"])

    # 2. tools/list
    y += 70
    svg.addLine(200, y, 600, y, [:stroke = "#2ecc71", :strokeWidth = 2, :markerEnd = arrowRight])
    svg.addTextCentered("Request: tools/list", 400, y - 10, [:fontSize = 14, :fill = "#27ae60"])

    # 2. tools/list Response
    y += 50
    svg.addLine(600, y, 200, y, [:stroke = "#e74c3c", :strokeWidth = 2, :markerEnd = arrowLeft])
    svg.addTextCentered("Response: [Tool1, Tool2]", 400, y - 10, [:fontSize = 14, :fill = "#c0392b"])
    
    # 3. tools/call
    y += 70
    svg.addLine(200, y, 600, y, [:stroke = "#2ecc71", :strokeWidth = 2, :markerEnd = arrowRight])
    svg.addTextCentered("Request: tools/call (Tool1)", 400, y - 10, [:fontSize = 14, :fill = "#27ae60"])

    # 3. tools/call Response
    y += 50
    svg.addLine(600, y, 200, y, [:stroke = "#e74c3c", :strokeWidth = 2, :markerEnd = arrowLeft])
    svg.addTextCentered("Response: Result Content", 400, y - 10, [:fontSize = 14, :fill = "#c0392b"])

    svg.save("mcp_flow.svg")
    ? "- mcp_flow.svg created successfully!"

func generate_classes_diagram
    svg = new SVGWriter(800, 600)
    svg.setBackground("#ffffff")

    svg.addTextCentered("Ring MCP SDK Class Diagram", 400, 40, [:fontSize = 24, :fontWeight = "bold", :fill = "#2c3e50"])

    # Core
    svg.addRoundedRect(300, 100, 200, 80, 8, [:fill = "#34495e"])
    svg.addTextCentered("MCPServer", 400, 145, [:fontSize = 18, :fontWeight = "bold", :fill = "white"])

    # Engine
    svg.addRoundedRect(100, 250, 180, 60, 8, [:fill = "#27ae60"])
    svg.addTextCentered("MessageRouter", 190, 285, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(310, 250, 180, 60, 8, [:fill = "#16a085"])
    svg.addTextCentered("SessionManager", 400, 285, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(520, 250, 180, 60, 8, [:fill = "#d35400"])
    svg.addTextCentered("Transport", 610, 285, [:fontSize = 16, :fill = "white"])

    # Server Components
    svg.addRoundedRect(150, 450, 140, 60, 8, [:fill = "#8e44ad"])
    svg.addTextCentered("MCPTool", 220, 485, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(330, 450, 140, 60, 8, [:fill = "#9b59b6"])
    svg.addTextCentered("MCPResource", 400, 485, [:fontSize = 16, :fill = "white"])

    svg.addRoundedRect(510, 450, 140, 60, 8, [:fill = "#2980b9"])
    svg.addTextCentered("MCPPrompt", 580, 485, [:fontSize = 16, :fill = "white"])

    # Connections
    arrow = svg.createArrowMarker(8, "#7f8c8d")
    
    # Core to Engine/Transport
    svg.addLine(400, 180, 190, 250, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow])
    svg.addLine(400, 180, 400, 250, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow])
    svg.addLine(400, 180, 610, 250, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow])

    # Core to Components
    svg.addLine(400, 180, 220, 450, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow, :strokeDash = "4,4"])
    svg.addLine(400, 180, 400, 450, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow, :strokeDash = "4,4"])
    svg.addLine(400, 180, 580, 450, [:stroke = "#7f8c8d", :strokeWidth = 2, :markerEnd = arrow, :strokeDash = "4,4"])

    svg.save("mcp_classes.svg")
    ? "- mcp_classes.svg created successfully!"

func generate_routing_diagram
    svg = new SVGWriter(800, 600)
    svg.setBackground("#ffffff")

    svg.addTextCentered("MCP Request Routing Flow", 400, 40, [:fontSize = 24, :fontWeight = "bold", :fill = "#2c3e50"])

    # Nodes
    svg.addFlowchartBox("Incoming JSON", 320, 80, 160, 50, [:type = "rounded", :fill = "#3498db", :textColor = "white"])
    svg.addFlowchartBox("Parse JSON", 320, 180, 160, 50, [:type = "rect", :fill = "#2ecc71", :textColor = "white"])
    svg.addFlowchartBox("Method Type?", 320, 280, 160, 80, [:type = "diamond", :fill = "#f1c40f", :textColor = "#333"])
    
    svg.addFlowchartBox("Tool Handler", 100, 420, 160, 50, [:type = "rect", :fill = "#9b59b6", :textColor = "white"])
    svg.addFlowchartBox("Resource Handler", 320, 420, 160, 50, [:type = "rect", :fill = "#e67e22", :textColor = "white"])
    svg.addFlowchartBox("Prompt Handler", 540, 420, 160, 50, [:type = "rect", :fill = "#e74c3c", :textColor = "white"])

    svg.addFlowchartBox("Send Response", 320, 520, 160, 50, [:type = "rounded", :fill = "#34495e", :textColor = "white"])

    # Connectors
    svg.addConnector(400, 130, 400, 180, [:arrow = true])
    svg.addConnector(400, 230, 400, 280, [:arrow = true])

    # From Diamond to Handlers
    svg.addConnector(320, 320, 180, 420, [:type = "elbow", :arrow = true])
    svg.addConnector(400, 360, 400, 420, [:arrow = true])
    svg.addConnector(480, 320, 620, 420, [:type = "elbow", :arrow = true])

    # Text for branches
    svg.addTextCentered("tools/*", 220, 350, [:fontSize = 12])
    svg.addTextCentered("resources/*", 440, 380, [:fontSize = 12])
    svg.addTextCentered("prompts/*", 580, 350, [:fontSize = 12])

    # From Handlers to End
    svg.addConnector(180, 470, 400, 520, [:type = "elbow", :arrow = true])
    svg.addConnector(400, 470, 400, 520, [:arrow = true])
    svg.addConnector(620, 470, 400, 520, [:type = "elbow", :arrow = true])

    svg.save("mcp_routing_flow.svg")
    ? "- mcp_routing_flow.svg created successfully!"
