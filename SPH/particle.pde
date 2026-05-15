float particle_radius = 8;
float k_smooth_radius = particle_radius * 3;
float k_stiff = 1500.0;
float k_stiffN = 1000000.0;
float k_rest_density = 0.001;
float max_pressure = 3000;
long max_pressureN = 30000000;

class Particle {
  Point2D oldPos;
  Vector2D velocity = new Vector2D(0, 0);
  float pressure, density = 0;
  float pressureN, densityN = 0;
  Circle circle;
  
  Particle(Point2D position) {
    circle = new Circle(position, particle_radius);
    this.oldPos = position;   
  }
  
  Point2D getPosition() {
    return circle.center;
  }
  
  void update(float dt) {
    velocity = circle.center.minus(oldPos).times(1 / dt);    
    velocity.add(gravity.times(dt));
    
    oldPos = circle.center;
    circle.center.add(velocity.times(dt));
    density = densityN = 0;
  }
  
  void draw() {
    fill(0,0,255);
    stroke(0,0,255);
    circle(circle.center.x, circle.center.y, circle.radius);
  }
  
  void handleCollision(Cup cup) {
    handleCollisionCupParticle(cup, this);
  }
  
  boolean isColliding(Particle particle) {
    return isCollidingCircles(circle, particle.circle);
  }
}

void handleParticles(float dt) {
  ArrayList<Pair> pairs = new ArrayList<Pair>();  
  
  // Determine nearby0 particles
  for(int i = 0; i < particles.size(); i++) {
    Particle partA = particles.get(i);
    for(int j = i + 1; j < particles.size(); j++) {
      Particle partB = particles.get(j);
      float dist = partA.circle.center.minus(partB.circle.center).magnitude();
      if (dist < k_smooth_radius) {
        Pair pair= new Pair();
        pair.p1 = partA;
        pair.p2 = partB;        
        pair.q = 1 - (dist / k_smooth_radius);
        pairs.add(pair);
        println("Density: ", pair.q);
      }
    }
  }
  
  // Accumulate density per particle
  for (int i = 0; i < pairs.size(); i++) {
    Pair pair = pairs.get(i);
    pair.p1.density += pair.q2();
    pair.p2.density += pair.q2();
    pair.p1.densityN += pair.q3();
    pair.p2.densityN += pair.q3();
  }
  
  // Pressure per particle
  for(int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    particle.pressure = k_stiff * (particle.density - k_rest_density);
    particle.pressureN = k_stiffN * particle.densityN;
    if (particle.pressure > max_pressure) { particle.pressure = max_pressure; }
    if (particle.pressureN > max_pressureN) { particle.pressureN = max_pressureN; }
  }
  
  // Calculate total pressure and displacement
  for (int i = 0; i < pairs.size(); i++) {
    Pair pair = pairs.get(i);
    Point2D p1 = pair.p1.getPosition();
    Point2D p2 = pair.p2.getPosition();
    float total_pressure = (pair.p1.pressure + pair.p2.pressure) * pair.q +
                           (pair.p1.pressureN + pair.p2.pressureN) * pair.q2();
    float displace = total_pressure * dt * dt;
    Vector2D p1Displace = p1.minus(p2).toUnit().times(displace);
    Vector2D p2Displace = p2.minus(p1).toUnit().times(displace);
    
    p1.add(p1Displace);
    p2.add(p2Displace);
  }
}
