// Collision between circles
boolean isCollidingCircles(Circle c1, Circle c2) {
  Vector2D delta = c2.center.minus(c1.center);
  float dist = delta.magnitude();
  return dist <= c1.radius + c2.radius;
}

// Collision between circle and line
boolean isCollidingCircleLine(Circle circle, LineSegment lineSegment) {
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

// Is point inside of circle?
boolean isInside(Point2D point, Circle circle) {
  return circle.center.minus(point).magnitude() < circle.radius;
}

// moves both circles equally
void handleOverlapCircles(Circle c1, Circle c2) {
  if(c1.isColliding(c2)) {
    Vector2D delta = c1.center.minus(c2.center);
    float dist = delta.magnitude();    
    float overlap = 0.5f * (dist - c1.radius - c2.radius);
    Vector2D normal = delta.toUnit();
    c1.center.add(normal.times(overlap * -1.1));
    c2.center.add(normal.times(overlap));
  }
}

// moves circle and not line
void handleOverlapCircleLineSegment(Circle c, LineSegment l) {
  if(c.isColliding(l)) {
    Point2D l1 = l.point1;
    Vector2D delta = c.center.minus(l1);
    Vector2D lineVector = l.toVector();
    float dist = delta.dot(lineVector) / lineVector.magnitude();
    Point2D collisionPoint = l1.plus(lineVector.toUnit().times(dist));
    Vector2D collisionToCenter = c.center.minus(collisionPoint);
    Vector2D surfaceNormal = collisionToCenter.toUnit();
    float overlapAmount = c.radius - collisionToCenter.magnitude();
    Vector2D removeOverlap = surfaceNormal.times(overlapAmount * 1.1);
    Point2D newPosition = c.center.plus(removeOverlap);
    c.center = newPosition;
  }
}

class Pair {
  Particle p1, p2;
  float q;
  float q2() { return q * q; }
  float q3() { return q * q * q; }
}

boolean handleCollisionCupParticle(Cup cup, Particle particle) {
  Circle circle = particle.circle;
  LineSegment[] walls = cup.walls;
  
  for (int i = 0; i < walls.length; i++) {
    LineSegment wall = walls[i];
    
    if (wall.isColliding(circle)) {
      handleOverlapCircleLineSegment(circle, wall);
      return true;
    }
  }
  
  return false;
}
