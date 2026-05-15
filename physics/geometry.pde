public class Point3D {
  public float x, y, z;
  
  public Point3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString() {
    return "Point - x: " + x + ", y: " + y + ", z: " + z;
  }
  
  public void subtract(Point3D p2) {
    x -= p2.x;
    y -= p2.y;
    z -= p2.z;
  }
  
  public Vector3D minus(Point3D p2) {
    return new Vector3D(x - p2.x, y - p2.y, z - p2.z);
  }
  
  public void add(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }
  
  public Point3D plus(Vector3D v) {
    return new Point3D(x + v.x, y + v.y, z + v.z);
  }
  
  public Point3D clamp(float minX, float maxX, float minY, float maxY, float minZ, float maxZ) {
    float newX = Math.max(minX, Math.min(maxX, x));
    float newY = Math.max(minY, Math.min(maxY, y));
    float newZ = Math.max(minZ, Math.min(maxZ, z));
    return new Point3D(newX, newY, newZ);
  }
  
  public Point3D clampX(float minX, float maxX) {
    float newX = Math.max(minX, Math.min(maxX, x));
    return new Point3D(newX, y, z);
  }
  
  public Point3D clampY(float minY, float maxY) {
    float newY = Math.max(minY, Math.min(maxY, Y));
    return new Point3D(x, newY, z);
  }
  
  public Point3D clampZ(float minZ, float maxZ) {
    float newZ = Math.max(minZ, Math.min(maxZ, Z));
    return new Point3D(x, y, newZ);
  }
}

public class Vector3D {
  public float x, y, z;
  
  public Vector3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString() {
    return "Vector - x: " + x + ", y: " + y + ", z: " + z;
  }
  
  public float magnitude() {
    return sqrt(x*x + y*y + z*z);
  }
  
  public float magSquared() {
    return x * x + y * y + z * z;
  }
  
  public Vector3D plus(Vector3D v2) {
    return new Vector3D(x + v2.x, y + v2.y, z + v2.z);
  }
  
  public void add(Vector3D v2) {
    x += v2.x;
    y += v2.y;
    z += v2.z;
  }
  
  public Vector3D minus(Vector3D v2) {
    return new Vector3D(x - v2.x, y - v2.y, z - v2.z);
  }
  
  public void subtract(Vector3D v2) {
    x -= v2.x;
    y -= v2.y;
    z -= v2.z;
  }
  
  public Vector3D times(float scalar){
    return new Vector3D(x*scalar, y*scalar, z*scalar);
  }
  
  public void mul(float scalar){
    x *= scalar;
    y *= scalar;
    z *= scalar;
  }
  
  public Vector3D cross(Vector3D v2) {
    float newX = y * v2.z - z * v2.y;
    float newY = z * v2.x - x * v2.z;
    float newZ = x * v2.y - y * v2.x;
    return new Vector3D(newX, newY, newZ);
  }
  
  public Vector3D toUnit() {
    float mag = magnitude();
    if (mag > 0) { return new Vector3D(x/mag, y/mag, z/mag); }
    else { return new Vector3D(0,0,0); }
  }
  
  public float dot(Vector3D v2) {
    return x * v2.x + y * v2.y + z * v2.z;
  }
}

public abstract class Geometry {
  color gColor = color(255,0,0);
  public abstract void draw();
}

public abstract class Shape extends Geometry {
  public Point3D center;
}


public class Sphere extends Shape {
  public float radius;
  
  public Sphere(float center_x, float center_y, float center_z, float radius) {
    this.center = new Point3D(center_x, center_y, center_z);
    this.radius = radius;
  }
  
  public Sphere(Point3D center, float radius) {
    this.center = center;
    this.radius = radius;
  }
  
  public String toString() {
    return "Sphere - CENTER: " + center.toString() + ", RADIUS: " + radius;
  }
    
  public void draw() { 
    pushMatrix();
    translate(center.x * scene_scale, center.y * scene_scale, center.z * scene_scale);
    fill(gColor);
    sphere(radius * scene_scale);
    popMatrix();
  }
}

public class LineSegment extends Geometry {
  public Point3D point1, point2;
  
  public LineSegment(float x1, float y1, float z1, float x2, float y2, float z2) {
    this.point1 = new Point3D(x1, y1, z1);
    this.point2 = new Point3D(x2, y2, z2);
  }
  
  public LineSegment(Point3D point1, Point3D point2) {
    this.point1 = point1;
    this.point2 = point2;
  }
  
  public Vector3D toVector() {
    return point2.minus(point1);
  }
  
  public String toString() {
    return "LineSegment - POINT1: " + point1.toString() + ", POINT2: " + point2.toString();
  }
  
  public void draw() { 
    line(point1.x, point1.y, point2.x, point2.y);
  }
}

public class Box extends Shape {
  public float b_width, b_height;
  public float angle = 0;
  
  public Box(float center_x, float center_y, float center_z, float b_width, float b_height) {
    this.center = new Point3D(center_x, center_y, center_z);
    this.b_width = b_width;
    this.b_height = b_height;
  }
  
  public Box(Point3D center, float b_width, float b_height) {
    this.center = center;
    this.b_width = b_width;
    this.b_height = b_height;
  }
  
  public float getMinX() { return center.x - b_width / 2; }
  public float getMaxX() { return center.x + b_width / 2; }
  public float getMinY() { return center.y - b_height / 2; }
  public float getMaxY() { return center.y + b_height / 2; }
  
  public String toString() {
    return "Box - CENTER: " + center.toString() + ", WIDTH: " + b_width + ", HEIGHT: " + b_height;
  }
  
  public void draw() { 
    rect(center.x, center.y, b_width, b_height);
  }
}
