Node nodes[];
int numNodes;
float energy;
boolean firstRun;
Parser p;
PGraphics pickbuffer;

void setup() {
  size(1000, 600);
  p = new Parser("data.csv");
  nodes = p.getNodes();
  numNodes = nodes.length;
  pickbuffer = createGraphics(width, height);
  firstRun = true;
}

void draw() {
  background(0, 0, 40);
  if(mousePressed)
    mouseDragged();
  if(!inEquilibrium()) {
    updateVelocities();
    moveNodes();
  }
  drawBackBuffer();
  drawNodes();
}

void mouseDragged() {
  Node theNode;
  float r;
  for (int i = 0; i < numNodes; i++) {
    theNode = nodes[i];
    
    /*moves the Node upon dragging. Also ensures that the
      Node remains within the window */
    if((theNode != null) && (theNode.isSelected())) {
      r = theNode.getRadius();
      theNode.setX(mouseX);
      if((theNode.getX() - r) < 0)
        theNode.setX(r);
      else if((theNode.getX() + r) > width)
        theNode.setX(width - r);
      theNode.setY(mouseY);
      if((theNode.getY() - r) < 0)
        theNode.setY(r);
      else if((theNode.getY() + r) > height)
        theNode.setY(height - r);
      theNode.applySpring();
      theNode.applyRepulsion();
      theNode.dampen();
    }
  }
}

void mouseMoved() {
  Node theNode;
  int id = getHighlightedNode();
  for (int i = 0; i < numNodes; i++) { 
    theNode = nodes[i];
    if(theNode != null) {
      if (id == theNode.getID())
        theNode.select();
      else
        theNode.deselect();
    }
  }
}

void drawBackBuffer() {
  pickbuffer.beginDraw();
  pickbuffer.background(255);
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null)
      nodes[i].renderBackBuffer(pickbuffer);
  }
  pickbuffer.endDraw();
}

//returns the id of the Node under the mouse
int getHighlightedNode() {
  int id = pickbuffer.get(mouseX, mouseY);
  id = id & 0xFFFFFF;
  return id;
}

void updateVelocities() {
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null) {
      nodes[i].applySpring();
      nodes[i].applyRepulsion();
      nodes[i].dampen();
    }
  }
}

//draws all of the Nodes, with Node "id" highlighted
void drawNodes() {
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null)
      nodes[i].drawLines();
  }
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null)
      nodes[i].drawNode();
  }
}

void moveNodes() {
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null)
      nodes[i].move();
  }
}

//returns true if the Nodes are structured in a neutral orientation
boolean inEquilibrium() {
  if(firstRun) {
    firstRun = false;
    return false;
  }
  energy = 0;
  for(int i = 0; i < numNodes; i++) {
    if(nodes[i] != null)
      energy += nodes[i].getEnergy();
  }
  textAlign(LEFT, TOP);
  fill(0, 120, 255);
  text("Energy: " + energy, 0, 0);
  return energy < .1;
}
