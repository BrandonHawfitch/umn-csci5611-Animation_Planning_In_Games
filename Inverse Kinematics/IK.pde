void setup(){
  size(1000,800);
  surface.setTitle("Inverse Kinematics");
  ellipseMode(RADIUS);
  camera = new Camera();  
  spider = new Spider(new Point2D(width/2, height/2), 50);
  obstacle = new Circle(new Point2D(width/2 - 135, height/2), 10);
}

Camera camera;
Spider spider;
Circle obstacle;

void draw(){
  background(250,250,250);
  camera.Update(1 / frameRate);
  
  //arm.update();
  spider.update();
  obstacle.draw();
}

void keyPressed() {
  camera.HandleKeyPressed();
}

void keyReleased() {
  camera.HandleKeyReleased();
}
