//class Spider {
//  Mesh mesh;
//  float radius;
  
//  Spider(Point2D center, float radius) {
//    List<Node> nodes = new ArrayList<Node>();
//    Node body = new Node(center);
//    nodes.add(body);
//    this.radius = radius;
    
//    // Creates legs
//    for (int i = 0; i < 8; i++) {
//      float degrees = i * (PI / 4);
//      float x = cos(degrees) * radius;
//      float y = sin(degrees) * radius;
//      Node legRootNode = new Node(new Point2D(x,y));
//      Link legLink = new Link(body, legRootNode);
//      body.addLink(legLink);
//      legRootNode.addLink(legLink);
      
//      nodes.add(legRootNode);
//    }
//  }
//}

class Spider {
  Arm[] arms;
  Point2D center;
  float radius;
  float approximateRange;
  
  Spider(Point2D center, float radius) {
    int armNumSegments = 3;
    float armSegmentLength = 50.0;
    this.center = center;
    this.radius = radius;
    
    this.arms = new Arm[8];
    for (int i = 0; i < 8; i++) {
      float degrees = i * (PI / 4);
      float x = cos(degrees) * radius;
      float y = sin(degrees) * radius;
      Point2D root = center.plus(new Vector2D(x, y));
      arms[i] = new Arm(root, armNumSegments, armSegmentLength);
      arms[i].currentAngles[0] +=degrees;
      arms[i].rootAngles[0] += degrees;
      for (int j = 0; j < arms[i].lengths.length; j++) {
        arms[i].lengths[j] *= j + 1;
      }
    }
  }
  
  float getApproximateRange() {
    float armLength = 0;
    for (int i = 0; i < arms[0].lengths.length; i++) {
      armLength += arms[0].lengths[i];
    }
    return armLength + radius;
  }
  
  void update() {
    this.draw();
    Point2D goal = new Point2D(mouseX, mouseY);
    boolean withinRange = goal.minus(center).magnitude() < getApproximateRange();
    if (withinRange) {
      Arm closestArm = arms[0];
      float closestDistance = Integer.MAX_VALUE;
      for (int i = 0; i < arms.length; i++) { 
        arms[i].fk();
        float distance = arms[i].getEnd().minus(goal).magnitude();
        if (distance < closestDistance) {
          closestArm = arms[i];
          closestDistance = distance;
        }
      }
      closestArm.solve(goal);
    }    
    
  }
  
  void fk() {
    for (int i = 0; i < arms.length; i++) {
      float degrees = i * (PI / 4);
      float x = cos(degrees) * radius;
      float y = sin(degrees) * radius;
      Point2D root = center.plus(new Vector2D(x, y));
      arms[i].points[0] = root;
      arms[i].fk();
    }
  }
  
  void draw() {
    circle(center.x, center.y, radius);
    for (int i = 0; i < arms.length; i++) {
      arms[i].fk();
      arms[i].draw();
    }
  }
}
