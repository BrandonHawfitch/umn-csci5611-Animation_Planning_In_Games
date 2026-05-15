abstract class Entity {
  Geometry geometry;
  float cor = 0.7;
  
  void draw() {
    geometry.draw();
  }
  
  // Returns true if the entities are colliding, false otherwise
  CollideInfo isColliding(Entity e2) {
    return geometry.isColliding(e2.geometry);
  }
  
  // Handles removal of overlap between entities
  CollideInfo handleOverlap(Ball b, CollideInfo info) {
    return geometry.handleOverlap(b.getCircle(), info);  
  }
  
  // Handles only the physical effects of the collision
  abstract CollideInfo resolveCollision(Ball b, CollideInfo info);
  
  /**
  Handles all collision activities
  This includes detection, overlap correction, and resolution
  **/
  void detectAndHandleCollision(Ball b) {
    CollideInfo info = isColliding(b);
    if(info.isCollision) {
      info = handleOverlap(b, info);
      info = resolveCollision(b, info);
    }
  }
}

// An obstacle is a static entity that does not move on its own, but can collide with balls
class Obstacle extends Entity {
  
  Obstacle(Geometry geometry) {
    this.geometry = geometry;
  }
  
  CollideInfo resolveCollision(Ball b, CollideInfo info) {
    return resolveCollisionBallObstacle(b, this, info);
  }
}

// A body is a dynamic entity that has both shape and physics, capable of being affected by forces and moving
abstract class Body extends Entity {
  Physics physics = new Physics();
  
  public Body(Shape shape) {
    geometry = shape;
  }
  
  void applyForce(Vector2D force) {
    physics.velocity.add(force.times(1 / physics.mass));
  }
  
  void applyFriction(float cof, float dt) {
    physics.applyFriction(cof, dt);
  }
  
  void update(float dt) {
    physics.velocity.add(physics.acceleration.times(dt));
    getPosition().add(physics.velocity.times(dt));
  }
  
  Point2D getPosition() {
    return ((Shape) geometry).center;
  }
  
  void setPosition(Point2D newPosition) {
    ((Shape) geometry).center = newPosition;
  }
  
  Shape getShape() {
    return (Shape) geometry;
  }
}

class Ball extends Body {  
  public Ball(Circle circle, float mass) {
    super(circle);
    physics.mass = mass;
    cor = 1;
  }
  
  public float getRadius() {
    return getCircle().radius;
  }
  
  public Circle getCircle() {
    return (Circle) geometry;
  }
  
  CollideInfo resolveCollision(Ball b, CollideInfo info) {
    return resolveCollisionBalls(this, b, info);
  }
  
  CollideInfo resolveCollision(Obstacle o, CollideInfo info) {
    return resolveCollisionBallObstacle(this, o, info);
  }
}
