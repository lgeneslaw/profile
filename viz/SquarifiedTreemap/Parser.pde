class Parser {
  private Rectangle root;
  
  // creates a tree structure and sets "root" to the root of the tree
  public Parser(String filename) {
    String lines[] = loadStrings(filename);
    int numLeaves = int(lines[0]);
    int numPairs = int(lines[numLeaves + 1]);
    int numRects = highestID(lines, numLeaves, numPairs) + 1;
    Rectangle rects[] = new Rectangle[numRects];
    String temp[];
    int id;
    for(int i = 1; i <= numLeaves; i++) {
      temp = split(lines[i], ',');
      id = int(temp[0]);
      rects[id] = new Rectangle(id, int(temp[1]));
    }
    int startLine = numLeaves + 2;
    int endLine = startLine + numPairs;
    for(int i = startLine; i < endLine; i++) {
      temp = split(lines[i], ',');
      id = int(temp[1]);
      if(rects[id] == null)
        rects[id] = new Rectangle(id);
      id = int(temp[0]);
      if(rects[id] == null)
        rects[id] = new Rectangle(id);
      rects[id].giveBirth(rects[int(temp[1])]);
    }
    root = findRoot(lines, numLeaves, numPairs, rects);
  }
  
  /*after the tree has been made, this finds which Rectangle is the root */
  private Rectangle findRoot(String lines[], int numLeaves, int numPairs, Rectangle rects[]) {
    boolean potentialRoots[] = new boolean[rects.length];
    int length = rects.length;
    for(int i = 0; i < length; i++)
      potentialRoots[i] = true;
    int startLine = numLeaves + 2;
    int endLine = startLine + numPairs;
    String temp[];
    for(int i = startLine; i < endLine; i++) {
      temp = split(lines[i], ',');
      if(rects[int(temp[1])] != null)
        potentialRoots[int(temp[1])] = false;
    }
    int root_index = 0;
    for(int i = 0; i < length; i++) {
      if((rects[i] != null) && potentialRoots[i]) {
        root_index = i;
        break;
      }
    }
    return rects[root_index];
  }
  
  //finds the highest ID in the data set
  private int highestID(String lines[], int numLeaves, int numPairs) {
    int startLine = numLeaves + 2;
    int endLine = startLine + numPairs;
    String temp[];
    temp = split(lines[startLine], ',');
    int highest = 0;
    if(int(temp[0]) > int(temp[1]))
      highest = int(temp[0]);
    else
      highest = int(temp[1]);
    int num = 0;
    for(int i = startLine; i < endLine; i++) {
      temp = split(lines[i], ',');
      num = int(temp[0]);
      if(num > highest)
        highest = num;
      num = int(temp[1]);
      if(num > highest)
        highest = num;
    }
    return highest;
  }
  
  public Rectangle getRoot() {
    return root;
  }
}
