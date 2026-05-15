class Flipper extends Body {
  Side side;
  float angularVelocity = 10; // Radians
  float maxRotate = HALF_PI;
  float minRotate = 0;
  boolean isFlipping = false;
  
  Flipper(Side side, Point2D base) {
    super(baseToFlipperBox(side, base));
    this.side = side;
    physics.mass = 1;
    cor = 1;
  }
  
  Box getBox() {
    return (Box) geometry;
  }
  
  void setAngle(float angle) {
    ((Box) geometry).angle = angle;
  }
  
  Point2D getBase() {
    return (side == Side.LEFT) ? 
      getPosition().plus(new Vector2D(-1 * getBox().b_width / 2, -1 * getBox().b_height / 2)) :
      getPosition().plus(new Vector2D(getBox().b_width / 2, -1 * getBox().b_height / 2));
  }
  
  Point2D getTip() {
    float xRotate = (float) Math.cos(getBox().angle) * getBox().b_width;
    float yRotate = (float) Math.sin(getBox().angle) * getBox().b_width;
    float newX = (side == Side.LEFT) ? getBase().x + xRotate : getBase().x - xRotate;
    float newY = (side == Side.LEFT) ? getBase().y + yRotate : getBase().y - yRotate;
    
    return new Point2D(newX, newY);
  }
  
  void draw() {
    pushMatrix();
    translate(getBase().x, getBase().y);
    rotate(getBox().angle);
    float drawX = (side == Side.LEFT) ? getBox().b_width / 2 : getBox().b_width / 2 * -1.0; 
    rect(drawX, getBox().b_height / 2, getBox().b_width, getBox().b_height);
    popMatrix();
  }
  
  void detectAndHandleCollision(Ball b) {
    CollideInfo info = isColliding(b);
    if(info.isCollision) {
      info = handleOverlap(b, info);
      info = resolveCollision(b, info);
    }
  }
  
  CollideInfo isColliding(Ball b) {
    CollideInfo info = new CollideInfo();
    LineSegment top = new LineSegment(getBase(), getTip());
    info = top.isColliding(b.geometry);
    return info;
  }
    
  CollideInfo resolveCollision(Ball b, CollideInfo info) {
    return resolveCollisionBallFlipper(b, this, info);
  }
  
  void update(float dt) {
    // Transform velocity to be appropriate to side
    float toRotate = (side == Side.LEFT) ? -1.0 * angularVelocity * dt : angularVelocity * dt;
    
    // Update angle of flipper
    float angleDelta = (isFlipping) ? toRotate : toRotate * -1.0;
    getBox().angle += angleDelta;
    
    // Reset if it's out of bounds
    if (side == Side.LEFT) {
      if(getBox().angle < -1.0 * maxRotate) {
        setAngle(-1.0 * maxRotate);
      } else
      if(getBox().angle >= minRotate) {
        setAngle(0);
      }
    } else {
      if(getBox().angle > maxRotate) {
        setAngle(maxRotate);
      } else
      if(getBox().angle <= minRotate) {
        setAngle(0);
      }
    }
  }
}

Box baseToFlipperBox(Side side, Point2D base) {
  float b_width = 75;
  float b_height = 10;
  float newX = (side == Side.LEFT) ? base.x + b_width / 2 : base.x - b_width / 2;
  float newY = (side == Side.LEFT) ? base.y + b_height / 2 : base.y + b_height / 2;
  
  Box flipperBox = new Box(newX, newY, b_width, b_height);
  return flipperBox;
}

public enum Side {
  LEFT, RIGHT
}
