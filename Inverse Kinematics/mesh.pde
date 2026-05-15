// A mesh should at any given time have a single root that represents its connection to the ground
// A mesh at any given time may have multiple end effectors, but only one is the "reacher"
// A path is made from the reacher to the root, and this is the path upon which IK and FK are conducted for CCD
// All arms/paths that exist as sibling paths to this path also experience FK all the way from the root node to their respective end effectors

//class Link {
//  Node nodeA;
//  Node nodeB;
//  float lengthL = 10;
//  float rootAngle = 0;
//  float currentAngle = 0;
//  float rotateSpeedLimit = 0.01;
//  float rotateLimit = PI / 4;
  
//  Link(Node nodeA, Node nodeB) {
//    this.nodeA = nodeA;
//    this.nodeB = nodeB;
//  }
  
//  void fk(Node rootNode) {
//    //Point2D joint = points[i];
//    Point2D joint = rootNode.point;
//    float angleSum = 0;
//    for (int j = 0; j < i + 1; j++) { angleSum += currentAngles[j]; }
//    float x = cos(angleSum) * lengthL;
//    float y = sin(angleSum) * lengthL;
//    points[i + 1] = joint.plus(new Vector2D(x,y));
//  }
//}

//class Node {
//  Point2D point;
//  List<Link> links = new ArrayList<Link>();
  
//  Node(Point2D point) {
//    this.point = point;
//  }
  
//  void addLink(Link link) { this.links.add(link); }
//}

//class Mesh {
//  Node[] nodes; // First index is root
  
//  Mesh(Node[] nodes) {
//    this.nodes = nodes;
//  }
//}

class Node {
  int id;
  boolean isEndEffector = false;
  boolean isRoot= false;
  Point2D point;
  
  Node() {}
  Node(Point2D point) { this.point = point; }
  
}

class Link {
  Node nodeA;
  Node nodeB;
  float lengthL = 10;
  float rootAngle = 0;
  float currentAngle = 0;
  float rotateSpeedLimit = 0.01;
  float rotateLimit = PI / 4;
}

int currentNodeId = 0;

class Mesh {
  ArrayList<Node> nodes;
  Link[][] links;
  Node currentRoot;
  
  Mesh(Point2D rootNode, int numNodes) {
    this.nodes = new ArrayList<Node>();
    this.links = new Link[numNodes][numNodes];
    this.currentRoot = new Node(rootNode);
  }
    
  ArrayList<Node> getNeighbors(Node node) {
    ArrayList<Node> neighbors = new ArrayList<Node>();
    Link[] edges = links[node.id];
    for (int i = 0; i < edges.length; i++) {
      if (edges[i] != null) {
        Link edge = edges[i];
        Node otherNode = edge.nodeA;
        if (otherNode.id == node.id) { otherNode = edge.nodeB; }
        neighbors.add(otherNode);
      }
    }
    
    return neighbors;
    //Node[] neighborsArray = new Node[neighbors.size()];
    //return neighbors.toArray(neighborsArray);
  }
  
  void addNode(Node node) {
    node.id = currentNodeId;
    currentNodeId++;
    this.nodes.add(node);
  }
  
  void addLink(Link link) {
    int nodeIdA = link.nodeA.id;
    int nodeIdB = link.nodeB.id;
    this.links[nodeIdA][nodeIdB] = link;
    this.links[nodeIdB][nodeIdA] = link;
  }
  
  //Node findClosestNode(Point2D point) {
  //  Set<Node> visited = new LinkedHashSet<Node>();
  //  Stack<Node> stack = new Stack<Node>();
  //  stack.push(currentRoot);
  //  while(!stack.isEmpty()) {
      
  //  }
  //}
  
  //void draw() {
  //  //for (int i = 0; i < nodes.size(); i++) {
  //  //  Node node = nodes.get(i);
      
  //  //}
  //  Set<Link> visited = new LinkedHashSet<Link>();
  //  for (int i = 0; i < links.length; i++) {
  //    for (int j = 0; j < links[i].length; j++) {                
  //      if (links[i][j] != null) {
  //        Link link = links[i][j];
  //        Node nodeA = link.nodeA;
  //        Node nodeB = link.nodeB;
          
  //      }
  //    }      
  //  }
  //}
  
  //Node depthFirstSearch() {
  //  Set<Node> visited = new LinkedHashSet<Node>();
  //  Stack<Node> stack = new Stack<Node>();
  //  stack.push(currentRoot);
  //  while(!stack.isEmpty()) {
      
  //  }
  //}
}
