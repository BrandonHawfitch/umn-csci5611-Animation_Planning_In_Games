public class Point2D {
  public float x, y;
  
  public Point2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public String toString() {
    return "Point - x: " + x + ", y: " + y;
  }
  
  public void subtract(Point2D p2) {
    x -= p2.x;
    y -= p2.y;
  }
  
  public Vector2D minus(Point2D p2) {
    return new Vector2D(x - p2.x, y - p2.y);
  }
  
  public void add(Vector2D v) {
    x += v.x;
    y += v.y;
  }
  
  public Point2D plus(Vector2D v) {
    return new Point2D(x + v.x, y + v.y);
  }
  
  public Point2D clamp(float minX, float maxX, float minY, float maxY) {
    float newX = Math.max(minX, Math.min(maxX, x));
    float newY = Math.max(minY, Math.min(maxY, y));
    return new Point2D(newX, newY);
  }
  
  public Point2D clampX(float minX, float maxX) {
    float newX = Math.max(minX, Math.min(maxX, x));
    return new Point2D(newX, y);
  }
  
  public Point2D clampY(float minY, float maxY) {
    float newY = Math.max(minY, Math.min(maxY, Y));
    return new Point2D(x, newY);
  }
}

public class Vector2D {
  public float x, y;
  
  public Vector2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public String toString() {
    return "Vector - x: " + x + ", y: " + y;
  }
  
  public float magnitude() {
    return sqrt(x*x + y*y);
  }
  
  public float magSquared() {
    return x * x + y * y;
  }
  
  public Vector2D plus(Vector2D v2) {
    return new Vector2D(x + v2.x, y + v2.y);
  }
  
  public void add(Vector2D v2) {
    x += v2.x;
    y += v2.y;
  }
  
  public Vector2D minus(Vector2D v2) {
    return new Vector2D(x - v2.x, y - v2.y);
  }
  
  public void subtract(Vector2D v2) {
    x -= v2.x;
    y -= v2.y;
  }
  
  public Vector2D times(float scalar){
    return new Vector2D(x*scalar, y*scalar);
  }
  
  public void mul(float scalar){
    x *= scalar;
    y *= scalar;
  }
  
  public float cross(Vector2D v2) {
    return (x * v2.y) - (y * v2.x);
  }
  
  public Vector2D toUnit() {
    float mag = magnitude();
    if (mag > 0) { return new Vector2D(x/mag, y/mag); }
    else { return new Vector2D(0,0); }
  }
  
  public float dot(Vector2D v2) {
    return x * v2.x + y * v2.y;
  }
}

public abstract class Geometry {
  color gColor = color(0,0,0);
  public abstract void draw();
}

public abstract class Shape extends Geometry {
  public Point2D center;
}


public class Circle extends Shape {
  public float radius;
  
  public Circle(float center_x, float center_y, float radius) {
    this.center = new Point2D(center_x, center_y);
    this.radius = radius;
  }
  
  public Circle(Point2D center, float radius) {
    this.center = center;
    this.radius = radius;
  }
  
  public String toString() {
    return "Circle - CENTER: " + center.toString() + ", RADIUS: " + radius;
  }
  
  public boolean isColliding(Circle c) { return isCollidingCircles(this, c); }
  public boolean isColliding(LineSegment l) { return isCollidingCircleLine(this, l); }
  public void handleOverlap(Circle c) { handleOverlapCircles(this, c); }
  
  public void draw() { 
    fill(gColor);
    circle(center.x, center.y, radius);
  }
}

public class LineSegment extends Geometry {
  public Point2D point1, point2;
  
  public LineSegment(float x1, float y1, float x2, float y2) {
    this.point1 = new Point2D(x1, y1);
    this.point2 = new Point2D(x2, y2);
  }
  
  public LineSegment(Point2D point1, Point2D point2) {
    this.point1 = point1;
    this.point2 = point2;
  }
  
  public Vector2D toVector() {
    return point2.minus(point1);
  }
  
  public String toString() {
    return "LineSegment - POINT1: " + point1.toString() + ", POINT2: " + point2.toString();
  }
  
  public boolean isColliding(Circle c) { return isCollidingCircleLine(c, this); }
  public void handleOverlap(Circle c) { handleOverlapCircleLineSegment(c, this); }
 
  public void draw() { 
    line(point1.x, point1.y, point2.x, point2.y);
  }
}

public class Box extends Shape {
  public float b_width, b_height;
  public float angle = 0;
  
  public Box(float center_x, float center_y, float b_width, float b_height) {
    this.center = new Point2D(center_x, center_y);
    this.b_width = b_width;
    this.b_height = b_height;
  }
  
  public Box(Point2D center, float b_width, float b_height) {
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
