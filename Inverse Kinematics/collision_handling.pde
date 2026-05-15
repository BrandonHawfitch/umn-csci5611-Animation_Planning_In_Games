boolean isCollidingCircleBoxPoints(Circle circle, Point2D[] points) {
    
  Point2D topLeft = points[0];
  Point2D topRight = points[1];
  Point2D bottomRight = points[2];
  Point2D bottomLeft = points[3];
  LineSegment top = new LineSegment(topLeft,topRight);
  LineSegment right = new LineSegment(topRight,bottomRight);
  LineSegment bottom = new LineSegment(bottomRight,bottomLeft);
  LineSegment left = new LineSegment(bottomLeft,topLeft);
  
  if (colliding(circle, top) ||
      colliding(circle, bottom) ||
      colliding(circle, left) ||
      colliding(circle, right)
  ) {
    return true;
  }
  
  return false;
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

// Same-side test for line segment intersection
// Determines if two points lay on the same side of the line segment
boolean areOnSameSide(LineSegment lineSegment, Point2D p1, Point2D p2) {
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
