// The general coefficient of restitution for the environment
float cor = 0.8;

// requires surface normal
CollideInfo resolveCollisionBallObstacle(Ball b, Obstacle o, CollideInfo info) {
  Vector2D velocity = b.physics.velocity;
  Vector2D surfaceNormal = info.surfaceNormal;
  
  Vector2D bv = surfaceNormal.times(velocity.dot(surfaceNormal));
  Vector2D bounceVector = velocity.minus(bv.times(2 * o.cor));
  b.physics.velocity = bounceVector;
  return info;
}

// Requires surface normal
//CollideInfo resolveCollisionBallLineSegment(Body e, LineSegment l, CollideInfo info) {
//  //Circle c = (Circle) e.geometry;
//  //Point2D l1 = l.point1;
//  //Vector2D delta = c.center.minus(l1);
//  //Vector2D lineVector = l.toVector();
//  //float dist = delta.dot(lineVector) / lineVector.magnitude();
//  //Point2D collisionPoint = l1.plus(lineVector.toUnit().times(dist));
  
//  //Point2D collisionPoint = info.impactPoint;
//  //info.impactPoint = collisionPoint;
//  //Vector2D collisionToCenter = c.center.minus(collisionPoint);
//  //Vector2D surfaceNormal = collisionToCenter.toUnit();
//  Vector2D surfaceNormal = info.surfaceNormal;
//  //info.surfaceNormal = surfaceNormal;
  
//  Vector2D velocity = e.physics.velocity;
//  Vector2D b = surfaceNormal.times(velocity.dot(surfaceNormal));
//  Vector2D bounceVector = velocity.minus(b.times(2 * cor));
//  e.physics.velocity = bounceVector;
  
//  return info;
//}

//CollideInfo resolveCollisionBallCircle(Ball b, Circle c, CollideInfo info) {
//  //Vector2D delta = b.getPosition().minus(c.center);
//  //Vector2D dir = delta.toUnit();
//  Vector2D dir = info.surfaceNormal;
//  float v = b.physics.velocity.dot(dir);
//  float new_v = b.cor * v * -1.0;
//  Vector2D new_vec = dir.times(new_v - v);
//  b.physics.velocity.add(new_vec);
//  return info;
//}

//CollideInfo resolveCollisionBallBox(Ball b, Box box, CollideInfo info) {
//  Point2D topLeft = new Point2D(box.getMinX(), box.getMinY());
//  Point2D topRight = new Point2D(box.getMaxX(), box.getMinY());
//  Point2D bottomLeft = new Point2D(box.getMinX(), box.getMaxY());
//  Point2D bottomRight = new Point2D(box.getMaxX(), box.getMaxY());
//  LineSegment top = new LineSegment(topLeft,topRight);
//  LineSegment bottom = new LineSegment(bottomLeft,bottomRight);
//  LineSegment left = new LineSegment(topLeft,bottomLeft);
//  LineSegment right = new LineSegment(bottomRight,topRight);
  
//  LineSegment[] sides = {top, bottom, left, right};
//  for (int i = 0; i < sides.length; i++) {
//    LineSegment side = sides[i];
//    if (b.geometry.isColliding(side).isCollision) {
//      resolveCollisionBallLineSegment(b, side, info);
//      return info;
//    }
//  }
//  return info;
//}

CollideInfo resolveCollisionBalls(Ball b1, Ball b2, CollideInfo info) {
  Vector2D delta = b1.getPosition().minus(b2.getPosition());
  Vector2D dir = delta.toUnit();
  float v1 = b1.physics.velocity.dot(dir);
  float v2 = b2.physics.velocity.dot(dir);
  float m1 = b1.physics.mass;
  float m2 = b2.physics.mass;
  
  float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * b1.physics.cor) / (m1 + m2);
  float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * b2.physics.cor) / (m1 + m2);
  
  Vector2D vec_1 = dir.times(new_v1 - v1);
  Vector2D vec_2 = dir.times(new_v2 - v2);
  
  b1.physics.velocity.add(vec_1);
  b2.physics.velocity.add(vec_2);
  
  return info;
}

CollideInfo resolveCollisionBallFlipper(Ball b, Flipper f, CollideInfo info) {
  Point2D bodyPos = b.getPosition();
  Point2D base = f.getBase();
  Point2D tip = f.getTip();
  Vector2D dir = tip.minus(base);
  Vector2D dirNorm = dir.toUnit();
  Point2D closest;
  Circle ball = (Circle) b.geometry;
  float proj = bodyPos.minus(base).dot(dirNorm);
  
  if(proj < 0) { closest = base; }
  else if (proj > dir.magnitude()) { closest = tip; }
  else { closest = base.plus(dirNorm.times(proj)); }
    
  Vector2D dirClosestToBody = bodyPos.minus(closest);
  //float dist = dirClosestToBody.magnitude();
  //if (dist > ball.radius) { return info; }
  dirClosestToBody = dirClosestToBody.toUnit();
  ball.center = closest.plus(dirClosestToBody.times(ball.radius));
  
  Vector2D radius = closest.minus(base);
  Vector2D surfaceVel = (new Vector2D(-1.0 * radius.y, radius.x)).times(f.angularVelocity);
  
  float v_ball = b.physics.velocity.dot(dirClosestToBody);
  float v_flip = surfaceVel.dot(dirClosestToBody);
  float new_v = v_flip + f.cor * (v_flip - v_ball);
  
  float vel = new_v - v_ball;
  Vector2D newVel = dirClosestToBody.times(vel * 0.1);
  
  //println(newVel);
  
  b.physics.velocity.add(newVel);
  //b.applyForce(newVel);
  println(newVel);
  return info;
}

CollideInfo resolveCollisionBallPlunger(Ball b, Plunger plunger, CollideInfo info) {
  Vector2D delta = b.getPosition().minus(plunger.getPosition());
  Vector2D dir = delta.toUnit();
  float v1 = b.physics.velocity.dot(dir);
  float v2 = plunger.physics.velocity.dot(dir);
  float m1 = b.physics.mass;
  float m2 = plunger.physics.mass;
  
  float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * plunger.physics.cor) / (m1 + m2);
  
  Vector2D vec_1 = dir.times(new_v1 - v1);
  
  b.physics.velocity.add(vec_1);
  
  return info;
}
