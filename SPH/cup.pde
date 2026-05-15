
class Cup {
  Point2D topLeft = new Point2D(300, 375);
  Point2D topRight = new Point2D(500, 375);
  Point2D bottomLeft = new Point2D(300, 450);
  Point2D bottomRight = new Point2D(500, 450);
  
  LineSegment[] walls;
  
  Cup() {
    walls = new LineSegment[3];
    
    LineSegment left = new LineSegment(topLeft, bottomLeft);
    LineSegment bottom = new LineSegment(bottomLeft, bottomRight);
    LineSegment right = new LineSegment(topRight, bottomRight);
   
    walls[0] = left;
    walls[1] = bottom;
    walls[2] = right;
  }
  
  void draw() {
    for (int i = 0; i < walls.length; i++) {
      LineSegment wall = walls[i];
      stroke(0,0,0);
      wall.draw();
    }
  }
  
  void handleCollision(Particle particle) {
    handleCollisionCupParticle(this, particle);
  }
  
  void fillCup() {
    float heightCup = topLeft.minus(bottomLeft).magnitude();
    float widthCup = topLeft.minus(topRight).magnitude();
    float particleWidth = particle_radius * 2;
    int rows = (int) Math.floor(heightCup / particleWidth) * 3;
    int columns = (int) Math.floor(widthCup / particleWidth);
    
    for (int ri = 0; ri < rows; ri++) {
      for (int ci = 0; ci < columns; ci++) {
        float x = topLeft.x + 5 + particle_radius + ci * particleWidth;
        float y = bottomLeft.y - particle_radius - ri * particleWidth;
        
        Particle particle = new Particle(new Point2D(x,y));
        particles.add(particle);
      }
    }
  }
}
