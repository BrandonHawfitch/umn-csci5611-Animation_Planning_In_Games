class Plunger extends Body {
  Box geometry;
  Vector2D direction;
  
  float ceiling = 600;
  float floor = 750;
  float pullSpeed = 2000;
  float releaseSpeed = pullSpeed * 10;
  
  boolean pulling = false;
  
  public Plunger(Box box) {
    super(box);
    physics.mass = 30;
    physics.cor = 0.1;
    release();
  }
  
  void pull() {
    pulling = true;
    direction = new Vector2D(0, 1);
  }
  
  void release() {
    pulling = false;
    direction = new Vector2D(0, -1);
  }
  
  void update(float dt) {
    super.update(dt);
    float speed = (pulling) ? pullSpeed : releaseSpeed;
    applyForce(direction.times(speed * dt));
    //println(physics.velocity);
    
    if(getPosition().y < ceiling) {
      setPosition(new Point2D(getPosition().x, ceiling));
      physics.velocity = new Vector2D(0,0);
    }
    if(getPosition().y > floor) {
      setPosition(new Point2D(getPosition().x, floor));
      physics.velocity = new Vector2D(0,0);
    }
  }
  
  CollideInfo resolveCollision(Ball b, CollideInfo info) {
    return resolveCollisionBallPlunger(b, this, info);
  }
}
