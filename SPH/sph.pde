Vector2D gravity = new Vector2D(0, 20000);
float particleSpawnRate = 500; // ms
float lastSpawnTime;

int substeps = 10;
ArrayList<Particle> particles;
Cup cup = new Cup();
boolean paused = true;

void setup() {
  size(800, 800);
  surface.setTitle("Project 2 SPH");
  lastSpawnTime = millis();
  
  particles = new ArrayList<Particle>();
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  if (key == 'f') {
    cup.fillCup();
  }
  if (key == 'r') {
    particles = new ArrayList<Particle>();
  }
  if (keyCode == UP) {
    particleSpawnRate /= 2;
  }
  if (keyCode == DOWN) {
    particleSpawnRate *= 2;
  }
}

void draw() {
  background(255);
  stroke(0);
  strokeWeight(2);
  ellipseMode(RADIUS);
  
  float dt = 1.0 / frameRate;
  
   //Generate Particles
  int time = millis();
  if (!paused && time > lastSpawnTime + particleSpawnRate) {
    Point2D position = new Point2D(random(width), 0);
    Particle particle = new Particle(position);
    particles.add(particle);
    lastSpawnTime = time;
  }
   
  for (int i =0; i < substeps; i++) {
    float simdt = dt / substeps;
    if (simdt > 0.003) { simdt = 0.003; }
    for(int j = 0; j < particles.size(); j++) {
      Particle particle = particles.get(j);
      if (particle.circle.center.y > height + particle.circle.radius) {
        particles.remove(j);
        continue;
      }
      particle.update(simdt);
      particle.handleCollision(cup);      
      particle.draw();
    }
    
    handleParticles(simdt);
  }
  
  cup.draw();
  
}
