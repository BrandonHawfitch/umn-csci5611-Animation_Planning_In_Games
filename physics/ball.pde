class Ball {
  Sphere sphere;
  Vector3D velocity = new Vector3D(0,0,0);
  float cor = 1;
  
  public Ball(Sphere sphere) {
    this.sphere = sphere;
  }
  
  void draw() {
    sphere.draw();
  }
}
