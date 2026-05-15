// Used to pass relevant data between stages of the collision handling process
class CollideInfo {
  boolean isCollision = false;
  Point2D impactPoint;
  Vector2D surfaceNormal;
}

// Collision between line segments
// Determines collision presence
CollideInfo isCollidingLineSegments(LineSegment l1, LineSegment l2) {
  CollideInfo info = new CollideInfo();
  if (areOnSameSide(l1, l2.point1, l2.point2)) return info;
  if (areOnSameSide(l2, l1.point1, l1.point2)) return info;
  info.isCollision = true;
  return info;
}

// Collision between circles
// Determines collision presence
CollideInfo isCollidingCircles(Circle c1, Circle c2) {
  CollideInfo info = new CollideInfo();
  Vector2D delta = c2.center.minus(c1.center);
  float dist = delta.magnitude();
  info.isCollision = dist <= c1.radius + c2.radius;
  return info;
}

// Collision between boxes
CollideInfo isCollidingBoxes(Box b1, Box b2) {
  CollideInfo info = new CollideInfo();
  if (Math.abs(b1.center.x - b2.center.x) > (b1.b_width + b2.b_width) / 2) return info;
  if (Math.abs(b1.center.y - b2.center.y) > (b1.b_height + b2.b_height) / 2) return info;
  info.isCollision = true;
  return info;
}

// Collision between circle and line segment
// Determines collision presence, surface normal, and impact point (unless point is inside circle)
CollideInfo isCollidingCircleLineSegment(Circle circle, LineSegment lineSegment) {
  CollideInfo info = new CollideInfo();
  Vector2D toCircle = circle.center.minus(lineSegment.point1);
  Vector2D lineVector = lineSegment.toVector();
  float max_t = lineSegment.toVector().magnitude();
  Vector2D l_dir = lineVector.toUnit();
  
  float a = 1;  //Lenght of l_dir (we noramlized it)
  float b = -2 * l_dir.dot(toCircle); //-2*dot(l_dir,toCircle)
  float c = toCircle.magSquared() - (circle.radius * circle.radius); //different of squared distances
  
  float d = b*b - 4*a*c; //discriminant 
  
  if (d >=0 ){ 
    float t1 = (-b - sqrt(d))/(2*a);
    if (t1 > 0 && t1 < max_t){
      // info
      info.isCollision = true;

      float dist = toCircle.dot(lineVector) / lineVector.magnitude();
      Point2D impactPoint = lineSegment.point1.plus(l_dir.times(dist));
      info.impactPoint = impactPoint;
      Vector2D dir = circle.center.minus(info.impactPoint);
      info.surfaceNormal = dir.toUnit();
    } 
  }
  
  if (isInside(lineSegment.point1, circle)) {
    // info
    info.surfaceNormal = circle.center.minus(lineSegment.point1);
    info.isCollision = true;
  }
  if (isInside(lineSegment.point2, circle)) {
    // info
    info.surfaceNormal = circle.center.minus(lineSegment.point2);
    info.isCollision = true;
  }

  return info;
}

// Collision between circle and box
// Determines collision presence
CollideInfo isCollidingCircleBox(Circle circle, Box box) {
  CollideInfo result = new CollideInfo();
  float minX = box.getMinX();
  float maxX = box.getMaxX();
  float minY = box.getMinY();
  float maxY = box.getMaxY();
  Point2D closest = circle.center.clamp(minX, maxX, minY, maxY);
  result.isCollision = isInside(closest, circle);
  return result;
}

// Collision between line and box
// Determines only presence of collision
CollideInfo isCollidingLineSegmentBox(LineSegment lineSegment, Box box) {
  CollideInfo info = new CollideInfo();
  if(isInside(lineSegment.point1, box) || isInside(lineSegment.point2, box)) info.isCollision = true;
    
  Point2D topLeft = new Point2D(box.getMinX(), box.getMinY());
  Point2D topRight = new Point2D(box.getMaxX(), box.getMinY());
  Point2D bottomLeft = new Point2D(box.getMinX(), box.getMaxY());
  Point2D bottomRight = new Point2D(box.getMaxX(), box.getMaxY());
  LineSegment top = new LineSegment(topLeft,topRight);
  LineSegment bottom = new LineSegment(bottomLeft,bottomRight);
  LineSegment left = new LineSegment(topLeft,bottomLeft);
  LineSegment right = new LineSegment(bottomRight,topRight);
  LineSegment[] borders = {top, bottom, left, right}; 
  
  for(int i = 0; i < borders.length; i ++) {
    LineSegment border = borders[i];
    info = isCollidingLineSegments(lineSegment, border);
  }
  
  return info;
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
