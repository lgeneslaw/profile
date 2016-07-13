class Node {
  private float x, y;
  private float radius;
  private ArrayList edges;
  private Node nodes[];
  private int numNodes;
  private int numEdges;
  private int id;
  private float xvel, yvel;
  private final float k = .2;  // spring constant
  private final float dampening = .5; 
  private final float c = 25000; // repulsion constant
  private boolean selected; // whether or not the mouse is over this node
  
  public Node(int _id) {
    radius = .01 * (width + height);
    x = random(radius, width - radius);
    y = random(radius, height - radius);
    edges = new ArrayList();
    numEdges = 0;
    id = _id;
    xvel = 0;
    yvel = 0;
  }
  
  //makes this node aware of all other nodes
  public void giveNodes(Node[] _nodes, int _numNodes) {
    nodes = _nodes;
    numNodes = _numNodes;
  }
  
  //connects this node to another node
  public void addEdge(Edge theEdge) {
    edges.add(theEdge);
    numEdges++;
  }
  
  public float getRadius() {
    return radius;
  }
  
  public int getID() {
    return id;
  }
  
  public void setX(float _x) {
    x = _x;
  }
  
  public void setY(float _y) {
    y = _y;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  //draws a line for each edge
  public void drawLines() {
    Node other;
    for(int i = 0; i < numEdges; i++) {
      other = ((Edge)edges.get(i)).getOther();
      stroke(120);
      line(x, y, other.getX(), other.getY());
    }
  }
  
  public void select() {
    selected = true;
  }
  
  public void deselect() {
    selected = false;
  }
  
  public boolean isSelected() {
    return selected;
  }
  
  /*draws this node as a circle. if this node is selected,
    it will be drawn with a highlighted fill color */
  public void drawNode() {
    noStroke();
    if(selected) {
      fill(0, 250, 50);
      ellipse(x, y, radius * 2, radius * 2);
      textAlign(CENTER, CENTER);
      fill(0);
      text(id, x, y);
    }
    else {
      fill(0, 120, 255);
      ellipse(x, y, radius * 2, radius * 2);
    }
  }
  
  //draws only the nodes in the back buffer
  public void renderBackBuffer(PGraphics pg) {
    pg.noStroke();
    pg.fill((int)red(id), (int)green(id) , (int)blue(id));
    pg.ellipse(x, y, radius * 2, radius * 2);
  }

  /* returns true if this node has an edge with the node with
    id = otherID */
  public boolean hasEdge(int otherID) {
    Edge theEdge;
    for(int i = 0; i < numEdges; i++) {
      theEdge = (Edge)edges.get(i);
      if(theEdge.getOther().getID() == otherID)
        return true;
    }
    return false;
  }
  
  private float getDistance(float otherX, float otherY) {
    return sqrt((otherX-x) * (otherX-x) + (otherY-y) * (otherY-y));
  }
  
  /* returns true if this node has an edge with the node other */
  private boolean isNeighbor(Node other) {
    Edge theEdge;
    for(int i = 0; i < numEdges; i++) {
      theEdge = (Edge)edges.get(i);
      if(other == theEdge.getOther())
        return true;
    }
    return false;
  }
  
  /*calculates the net spring force on this node and updates
    its velocity according to the force */
  public void applySpring() {
    float forceX = 0;
    float forceY = 0;
    float otherX, otherY, distance;
    Edge theEdge;
    Node other;
    for(int i = 0; i < numEdges; i++) {
      theEdge = (Edge)edges.get(i);
      other = theEdge.getOther();
      otherX = other.getX();
      otherY = other.getY();
      distance = getDistance(otherX, otherY);
      forceX += k * (distance - theEdge.getStrength()) * ((otherX - x) / distance);
      forceY += k * (distance - theEdge.getStrength()) * ((otherY - y) / distance);
    }
    xvel += forceX;
    yvel += forceY;
  }
  
  /* calculates the net repulsive force on this node and updates its
     velocity according to that force */
  public void applyRepulsion() {
    float forceX = 0;
    float forceY = 0;
    float otherX, otherY, distance;
    Edge theEdge;
    Node other;
    for(int i = 0; i < numNodes; i++) {
      if((nodes[i] != null) && (nodes[i] != this)) {
        other = nodes[i];
        otherX = other.getX();
        otherY = other.getY();
        distance = getDistance(otherX, otherY);
        if(!isNeighbor(other)) { // only consider the repulsion due to non-neighbors
          forceX += (c / (distance * distance)) * ((otherX - x) / distance);
          forceY += (c / (distance * distance)) * ((otherY - y) / distance);
        }
      }
    }
    xvel -= forceX;
    yvel -= forceY;
  }
  
  //dampens the velocity, ensuring the nodes will be able to stop
  public void dampen() {
    xvel *= dampening;
    yvel *= dampening;
  }
  
  /* moves the x and y position of this node and makes sure that
    it is still within the bounds of the window */
  public void move() {
    x += xvel;
    y += yvel;
    checkBorders();
  }
  
  // if forces the node to remain within the bounds of the window
  private void checkBorders() {
    if((x - radius) < 0) {
      xvel = -1 * xvel;
      x += xvel * 2;
    }
    else if((x + radius) > width) {
      xvel = -1 * xvel;
      x += xvel * 2;
    }
    if((y - radius) < 0) {
      yvel = -1 * yvel;
      y += yvel * 2;
    }
    else if((y + radius) > height) {
      yvel = -1 * yvel;
      y += yvel * 2;
    }
  }
  
  public void stopVel() {
    xvel = 0;
    yvel = 0;
  }
  
  /* returns the total energy of this node by calculating
    the overall velocity squared */
  public float getEnergy() {
    float velocity = sqrt((xvel*xvel) + (yvel*yvel));
    return velocity * velocity;
  }
    
  //for debugging purposes  
  public String toString() {
    String theString = "Node " + id + " has connections to:\n";
    Edge theEdge;
    for(int i = 0; i < numEdges; i++) {
      theEdge = (Edge)edges.get(i);
      theString  += "\t" + theEdge.getOther().getID() + " with strength " + theEdge.getStrength() + "\n"; 
    }
    return theString;
  }
    
}
