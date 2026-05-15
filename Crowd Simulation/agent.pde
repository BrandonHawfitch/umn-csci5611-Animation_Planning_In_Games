class Agent {
  Point2D center;
  Vector2D velocity = new Vector2D(0,0);
  
  float widthA = 25;
  float heightA = 45;
  float rotation = 0;
  float rotationSpeed = 2;
  float speed = 40;
  
  ArrayList<Point2D> path;
  
  Agent(Point2D center) {
    this.center = center;
  }
  
  Circle getBoundingCircle() {
    return new Circle(center, heightA/2);
  }
  
  void draw() {
    fill(0,255,0);
    Point2D pointA = new Point2D(- widthA / 2,+ heightA/2);
    Point2D pointB = new Point2D(0,- heightA/2);
    Point2D pointC = new Point2D(widthA / 2,heightA/2);
    pushMatrix();
    translate(center.x, center.y);
    rotate(rotation);
    triangle(pointA.x, pointA.y, pointB.x, pointB.y, pointC.x, pointC.y);
    popMatrix();
  }
  
  void update(float dt) {
    if (path.size() > 0) {      
      Vector2D toNextNode = path.get(0).minus(center);
      if (toNextNode.magnitude() < 1) { // close enough to next node to pop it
        path.remove(0);
      } else {
        Vector2D direction = toNextNode.toUnit();
        velocity = direction.times(speed);
        
        float radians = atan2(direction.y, direction.x) + PI/2;
        float dif = rotation - radians;
        
        if (abs(dif) > 0.01) {
          rotation -= dif * rotationSpeed * dt;
        }
        pathSkip();
      }
      center.add(velocity.times(dt));
    }
  }
  
  void pathSkip() {
    int indexFarthestSeen = 0;
    for (int i = 1; i < path.size(); i++) {
      Point2D point = path.get(i);
      LineSegment agentToPoint = new LineSegment(center, point);
      if (! collidingAny(obstacles, agentToPoint)) {
        indexFarthestSeen = i;
      }
    }
    while(indexFarthestSeen>0) {
      path.remove(0);
      indexFarthestSeen--;
    }
  }
}
