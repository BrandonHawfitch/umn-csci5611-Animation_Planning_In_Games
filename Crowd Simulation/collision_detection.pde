// Collision between lines
boolean colliding(LineSegment l1, LineSegment l2) {
  if (sameSide(l1, l2.point1, l2.point2)) return false;
  if (sameSide(l2, l1.point1, l1.point2)) return false;
  return true;
}

// Collision between circles
boolean colliding(Circle c1, Circle c2) {
  Vector2D delta = c2.center.minus(c1.center);
  float dist = delta.magnitude();
  return dist <= c1.radius + c2.radius;
}

// Collision between boxes
boolean colliding(Box b1, Box b2) {
  if (Math.abs(b1.center.x - b2.center.x) > (b1.b_width + b2.b_width) / 2) return false;
  if (Math.abs(b1.center.y - b2.center.y) > (b1.b_height + b2.b_height) / 2) return false;
  return true;
}

// Collision between circle and line
boolean colliding(Circle circle, LineSegment lineSegment) {
  Vector2D toCircle = circle.center.minus(lineSegment.point1);
  float max_t = lineSegment.toVector().magnitude();
  Vector2D l_dir = lineSegment.toVector().toUnit();
  
  float a = 1;  //Lenght of l_dir (we noramlized it)
  float b = -2 * l_dir.dot(toCircle); //-2*dot(l_dir,toCircle)
  float c = toCircle.magSquared() - (circle.radius * circle.radius); //different of squared distances
  
  float d = b*b - 4*a*c; //discriminant 
  
  if (d >=0 ){ 
    //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
    //  ... this means t will be between 0 and the lenth of the line segment
    float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only take the first collision [is this safe?]
    float t2 = (-b + sqrt(d))/(2*a);
    //println("t1: " + t1);
    if (t1 > 0 && t1 < max_t){
      return true;
    } 
  }
  
  if (isInside(lineSegment.point1, circle) ||
      isInside(lineSegment.point2, circle)) return true;
  return false;
}

boolean collidingAny(Circle[] circles, LineSegment lineSegment) {
  for (int i = 0; i < circles.length; i++) {
    if (colliding(circles[i], lineSegment)) { return true; }
  }
  return false;
}

// Collision between circle and box
boolean colliding(Circle circle, Box box) {
  float minX = box.getMinX();
  float maxX = box.getMaxX();
  float minY = box.getMinY();
  float maxY = box.getMaxY();
  Point2D closest = circle.center.clamp(minX, maxX, minY, maxY);
  return isInside(closest, circle);
}

// Collision between line and box
boolean colliding(LineSegment lineSegment, Box box) {
  if(isInside(lineSegment.point1, box) || isInside(lineSegment.point2, box)) return true;
    
  Point2D topLeft = new Point2D(box.getMinX(), box.getMinY());
  Point2D topRight = new Point2D(box.getMaxX(), box.getMinY());
  Point2D bottomLeft = new Point2D(box.getMinX(), box.getMaxY());
  Point2D bottomRight = new Point2D(box.getMaxX(), box.getMaxY());
  LineSegment top = new LineSegment(topLeft,topRight);
  LineSegment bottom = new LineSegment(bottomLeft,bottomRight);
  LineSegment left = new LineSegment(topLeft,bottomLeft);
  LineSegment right = new LineSegment(bottomRight,topRight);
  
  if (colliding(lineSegment, top) ||
      colliding(lineSegment, bottom) ||
      colliding(lineSegment, left) ||
      colliding(lineSegment, right)
  ) {
    return true;
  }
  
  return false;
}

// Same-side test for line segment intersection
// Determines if two points lay on the same side of the line segment
boolean sameSide(LineSegment lineSegment, Point2D p1, Point2D p2) {
  Point2D lp1 = lineSegment.point1;
  Vector2D a = lineSegment.toVector();
  Vector2D b = lp1.minus(p1);
  Vector2D c = lp1.minus(p2);
  float cp1 = a.cross(b);
  float cp2 = a.cross(c);
  return cp1 * cp2 >= 0;
}

// Is point inside of circle?
boolean isInside(Point2D point, Circle circle) {
  return circle.center.minus(point).magnitude() < circle.radius;
}

boolean isInsideAny(Point2D point, Circle[] circles) {
  for (int i = 0; i < circles.length; i++) {
    if (isInside(point, circles[i])) { return true; }
  }
  return false;
}

// Is point inside of box?
boolean isInside(Point2D point, Box box) {
  float minX = box.getMinX();
  float maxX = box.getMaxX();
  float minY = box.getMinY();
  float maxY = box.getMaxY();
  if (point.x < minX || point.x > maxX) return false;
  if (point.y < minY || point.y > maxY) return false;
  return true;
}
