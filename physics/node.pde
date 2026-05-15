class Node {
  Point3D pos;
  Vector3D vel = new Vector3D(0, 0, 0);
  float mass = 1;

  Node(Point3D pos) {
    this.pos = pos;
  }
  
  void applyForce(Vector3D force, float dt) {
    this.vel = vel.plus(force.times(dt));
  }
  
  void update(float dt) {
    this.pos = pos.plus(vel.times(dt));
  }
  
  void draw() {
    pushMatrix();
    translate(pos.x * scene_scale, pos.y * scene_scale, pos.z * scene_scale);
    sphere(0.05 * scene_scale);
    popMatrix();
  }
}

class Link {
  Node node1;
  Node node2;
  float restLength;
  float ks;
  float kd;
  float tearFactor = 1.6;
  
  Link(Node node1, Node node2, float restLength, float ks, float kd) {
    this.node1 = node1;
    this.node2 = node2;
    this.restLength = restLength;
    this.ks = ks;
    this.kd = kd;
  }
  
  void draw() {
    line(node1.pos.x * scene_scale, node1.pos.y * scene_scale, node1.pos.z * scene_scale,
         node2.pos.x * scene_scale, node2.pos.y * scene_scale, node2.pos.z * scene_scale);
  }
  
  void update(float dt) {
    // represents vector from node1 to node2 
    Vector3D estar = node2.pos.minus(node1.pos);
    // represents direction from node1 to node2
    Vector3D e = estar.toUnit();
    // represents distance between node1 and node2
    float l = estar.magnitude();
    
    float v1 = e.dot(node1.vel);
    float v2 = e.dot(node2.vel);
    float f = -ks * (restLength - l) - kd * (v1 - v2);
    
    node1.vel.add(e.times(f * dt));
    node2.vel.subtract(e.times(f * dt));
  }
  
  boolean shouldTear() {
    return node1.pos.minus(node2.pos).magnitude() > (tearFactor * restLength);
  }
}
