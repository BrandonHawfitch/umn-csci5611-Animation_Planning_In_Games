class Octopus {
  Arm[] arms;
  Point2D center;
  float radius;
  float approximateRange;
  
  Octopus(Point2D center, float radius, int armNumSegments, float armSegmentLength) {
    this.center = center;
    this.radius = radius;
    this.approximateRange = (armNumSegments + 1) * armSegmentLength + radius;
    
    this.arms = new Arm[8];
    for (int i = 0; i < 8; i++) {
      float degrees = PI - (i * PI) / 8 - PI/16;
      float x = cos(degrees) * radius;
      float y = sin(degrees) * radius;
      Point2D root = center.plus(new Vector2D(x, y));
      arms[i] = new Arm(root, armNumSegments, armSegmentLength);
    }
  }
  
  void update() {
    Point2D goal = new Point2D(mouseX, mouseY);
    boolean withinRange = goal.minus(center).magnitude() < approximateRange;
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
    this.draw();
  }
  
  void draw() {
    circle(center.x, center.y, radius * 2);
    for (int i = 0; i < arms.length; i++) {
      arms[i].fk();
      arms[i].draw();
    }
  }
}
