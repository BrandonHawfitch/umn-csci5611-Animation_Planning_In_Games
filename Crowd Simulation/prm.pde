/////////////////////////////////
// A Probabilistic Roadmap (PRM)
////////////////////////////////

static int numNodes = 100;

//The optimal path found along the PRM
ArrayList<Integer> path = new ArrayList();
int startNode, goalNode; //The actual node the PRM tries to connect do

//Represent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node

//The PRM uses the above graph, along with a list of node positions
Point2D[] nodePos = new Point2D[numNodes];


void drawPRM() {
  fill(0,0,255);
  for (int i = 0; i < numNodes; i++){
    circle(nodePos[i].x,nodePos[i].y,5);
  }
  
  stroke(100,100,100);
  strokeWeight(1);
  for (int i = 0; i < numNodes; i++){
    for (int j : neighbors[i]){
      line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
    }
  }
}

void drawPath(ArrayList<Point2D> path) {
  //stroke(20,255,40);
  //strokeWeight(5);
  for (int i = 0; i < path.size() - 1; i++) {
    Point2D pointA = path.get(i);
    Point2D pointB = path.get(i + 1);
    LineSegment line = new LineSegment(pointA, pointB);
    line.draw();
  }
}

//Generate non-colliding PRM nodes
void generateRandomNodes(Circle[] circles){
  nodePos[0] = agent.center;
  nodePos[1] = goal.center;
  for (int i = 2; i < numNodes; i++){
    Point2D randPos = new Point2D(random(width),random(height));
    boolean insideAnyCircle = isInsideAny(randPos, circles);
    while (insideAnyCircle){
      randPos = new Point2D(random(width),random(height));
      insideAnyCircle = isInsideAny(randPos, circles);
    }
        
    //boolean insideTheBox = isInside(randPos, box);
    //while (insideTheBox) {
    //  randPos = new Point2D(random(width),random(height));
    //  insideTheBox = isInside(randPos, box);
    //}
    
    nodePos[i] = randPos;
  }
}


//Set which nodes are connected to which neighbors based on PRM rules
void connectNeighbors(){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      LineSegment line = new LineSegment(nodePos[i], nodePos[j]);
      float distBetween = line.toVector().magnitude();
      //Vector2D dir = nodePos[j].minus(nodePos[i]).toUnit();
      //float distBetween = nodePos[i].minus(nodePos[j]).magnitude();
      if (distBetween < 200) {        
        hitInfo circleListCheck = rayCircleListIntersect(obstacles, line);
        if (!circleListCheck.hit){
          neighbors[i].add(j);
        }
      }      
    }
  }
}

//Build the PRM
// 1. Generate collision-free nodes
// 2. Connect mutually visible nodes as graph neighbors
void buildPRM(){
  generateRandomNodes(obstacles);
  connectNeighbors();
}

//BFS
ArrayList<Point2D> runBFS(){
  int startID = 0;
  int goalID = 1;
  startNode = startID;
  goalNode = goalID;
  ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
  path = new ArrayList(); //Reset path
  for (int i = 0; i < numNodes; i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }

  //println("\nBeginning Search");
  
  visited[startID] = true;
  fringe.add(startID);
  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fring: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goalID){
      //println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
      }
    } 
  }
  
  //print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(0,goalID);
  //print(goalID, " ");
  while (prevNode >= 0){
    //print(prevNode," ");
    path.add(0,prevNode);
    prevNode = parent[prevNode];
  }
  //print("\n");
  
  //println(path);
  ArrayList<Point2D> pathPoints = new ArrayList();
  for (int i = 0; i < path.size(); i++) {    
    pathPoints.add(nodePos[path.get(i)]);
  }
  //println(pathPoints);
  return pathPoints;
}
