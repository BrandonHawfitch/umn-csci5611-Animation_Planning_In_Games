Camera camera;
Ball ball = new Ball(new Sphere(new Point3D(6, 6, 1.5), 0.5));

void setup() {
  size(500, 500, P3D);
  surface.setTitle("Project 2 Physics");
  scene_scale = width / 10.0f;
  camera = new Camera();
}

// Springiness
float ks = 30;
// Dampening
float kd = 10;
Mesh mesh = new Mesh(new Point3D(5,5,0), 5, 5, 0.5, ks, kd);

// Scaling factor for the scene
float scene_scale = width / 10.0f;
Vector3D gravity = new Vector3D(0, 1, 0);

boolean paused = true;

void keyPressed() {
  camera.HandleKeyPressed();
  if (key == ' ') {
    paused = !paused;
  }
  if (key == 'g') {
    gravity.mul(1.5);
  }
  if (key == 'u') {
    gravity.mul(2/3);
  }
  if (key == 'r') {
    mesh = new Mesh(new Point3D(5,5,0), 5, 5, 0.5, ks, kd);
  }
}

void keyReleased() {
  camera.HandleKeyReleased();
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
  
  camera.Update(1 / frameRate);
  
  if (!paused) {
    mesh.handleCollision(ball);
    mesh.update(dt);
    
  }

  background(255);
  stroke(0);
  strokeWeight(2);   
  
  mesh.draw();
    
  ball.draw();
}
