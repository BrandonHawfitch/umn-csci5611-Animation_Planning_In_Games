class Physics {
  Vector2D velocity = new Vector2D(0,0);
  Vector2D acceleration = new Vector2D(0,0);
  float mass = 0;
  float cor = 1;
  
  void applyForce(Vector2D force) {
    velocity.add(force.times(1 / mass));
  }
  
  void update(float dt) {
    velocity.add(acceleration.times(dt));
  }
  
  void applyFriction(float cof, float dt) {
    velocity.mul(1 - (cof * dt));
  }
}
