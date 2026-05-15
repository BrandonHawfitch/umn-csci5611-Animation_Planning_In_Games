// moves both circles equally
// Circle Body, Circle Body
// Determines surface normal
CollideInfo handleOverlapCircles(Circle c1, Circle c2, CollideInfo info) {
  Vector2D delta = c1.center.minus(c2.center);
  float dist = delta.magnitude();
  float overlap = 0.5f * (dist - c1.radius - c2.radius);
  Vector2D normal = delta.toUnit();
  // info
  info.surfaceNormal = normal;
  c1.center.add(normal.times(overlap * -1.1));
  c2.center.add(normal.times(overlap));
  return info;
}

// moves circle and not line
// Circle Body, LineSegment Obstacle
// Uses impact point
CollideInfo handleOverlapCircleLineSegment(Circle c, LineSegment l, CollideInfo info) {
  //Point2D l1 = l.point1;
  //Vector2D delta = c.center.minus(l1);
  //Vector2D lineVector = l.toVector();
  //float dist = delta.dot(lineVector) / lineVector.magnitude();
  //Point2D collisionPoint = l1.plus(lineVector.toUnit().times(dist));
  
  // info
  Vector2D collisionToCenter = c.center.minus(info.impactPoint);
  //Vector2D surfaceNormal = collisionToCenter.toUnit();
  //Vector2D surfaceNormal = info.surfaceNormal;
  float overlapAmount = c.radius - collisionToCenter.magnitude();
  Vector2D removeOverlap = info.surfaceNormal.times(overlapAmount * 1.1);
  Point2D newPosition = c.center.plus(removeOverlap);
  c.center = newPosition;
  return info;
}

// Moves circle and not box
// Circle Body, Box Obstacle
// Determines surface normal
CollideInfo handleOverlapCircleBox(Circle c, Box b, CollideInfo info) {
  float minX = b.getMinX();
  float maxX = b.getMaxX();
  float minY = b.getMinY();
  float maxY = b.getMaxY();
  Point2D closest = c.center.clamp(minX, maxX, minY, maxY);
  Vector2D delta = closest.minus(c.center);
  float overlap = c.radius - delta.magnitude();
  Vector2D dir = delta.toUnit();
  // info
  info.surfaceNormal = dir;
  Vector2D removeOverlap = dir.times(overlap * -1.1);
  c.center.add(removeOverlap);
  return info;
}

// Moves first circle and not the second
// Circle Body, Circle Obstacle
// Determines surface normal
CollideInfo handleOverlapCirclesObstacle(Circle cirBody, Circle cirObs, CollideInfo info) {
  Vector2D delta = cirBody.center.minus(cirObs.center);
  float dist = delta.magnitude();
  float overlap = dist - cirBody.radius - cirObs.radius;
  Vector2D normal = delta.toUnit();
  // info
  info.surfaceNormal = normal;
  cirBody.center.add(normal.times(overlap * -1.1));
  return info;
}
