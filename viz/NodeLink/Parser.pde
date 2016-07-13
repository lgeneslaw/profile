/* reads the data file and constructs a sparsely
   populated array of nodes with their edges added.
   each node is at the index of its unique id. */
class Parser {
  private Node nodes[]; // sparsely populated array of all Nodes
  
  public Parser(String filename) {
    String lines[] = loadStrings(filename);
    int length = lines.length;
    int highest = highestID(lines);
    nodes = new Node[highest + 1];
    Node node1, node2;
    int num;
    String temp[];
    Edge theEdge;
    for(int i = 0; i < length; i++) {
      temp = split(lines[i], ',');
      num = int(temp[0]);
      if(nodes[num] == null)
        nodes[num] = new Node(num);
      node1 = nodes[num];
      num = int(temp[1]);
      if(nodes[num] == null)
        nodes[num] = new Node(num);
      node2 = nodes[num];
      if(!node1.hasEdge(num)) { // make sure to not add duplicates
        node1.addEdge(new Edge(node2, float(temp[2])));
        node2.addEdge(new Edge(node1, float(temp[2])));
      }
    }
    for(int i = 0; i <= highest; i++) {
      if(nodes[i] != null)
        nodes[i].giveNodes(nodes, highest + 1);
    }
  }
  
  public Node[] getNodes() {
    return nodes;
  }
  
  //finds the highest ID in the data set
  private int highestID(String lines[]) {
    String temp[];
    temp = split(lines[0], ',');
    int highest = 0;
    if(int(temp[0]) > int(temp[1]))
      highest = int(temp[0]);
    else
      highest = int(temp[1]);
    int num = 0;
    int length = lines.length;
    for(int i = 0; i < length; i++) {
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
  
}
