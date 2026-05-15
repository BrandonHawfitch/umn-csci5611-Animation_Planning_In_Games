import java.util.*;
import java.util.stream.*;

class Arm {
  Point2D[] points;
  float[] lengths;
  float[] rootAngles;
  float[] currentAngles;
  float[] rotateSpeedLimits;
  float[] rotateLimits;
  
  Arm(Point2D root, int numSegments, float segmentLength) {
    points = new Point2D[numSegments + 1];
    rootAngles = new float[numSegments];
    currentAngles = new float[numSegments];
    lengths = new float[numSegments];
    rotateSpeedLimits = new float[numSegments];
    rotateLimits = new float[numSegments];
    for (int i = 0; i < numSegments; i++) {
      currentAngles[i] = 0.9;
      rootAngles[i] = currentAngles[i];
      if (i >= 4) currentAngles[i] *= -1;
      lengths[i] = segmentLength;
      rotateSpeedLimits[i] = 0.01;
      rotateLimits[i] = PI / 4;
    }
    
    points[0] = root;
  }
  
  Point2D[] getJoints() {
    return Arrays.copyOfRange(points, 0, points.length - 1);
  }
  
  Point2D getRoot() { return points[0]; }
  Point2D getEnd() { return points[points.length - 1]; }
  
  void solve(Point2D goal) {
    Vector2D startToGoal, startToEndEffector;
    float dotProd, angleDiff;
    Point2D[] joints = getJoints();
    
    for (int i = getJoints().length - 1; i >= 0; i--) {
      Point2D joint = joints[i];
      startToGoal = goal.minus(joint);
      startToEndEffector = getEnd().minus(joint);
      dotProd = startToGoal.toUnit().dot(startToEndEffector.toUnit());
      dotProd = Math.max(-1, Math.min(1, dotProd));
      
      angleDiff = acos(dotProd);
      angleDiff = constrain(angleDiff, -rotateSpeedLimits[i], rotateSpeedLimits[i]);
      
      float length_ = lengths[i];
      float angleSum = - PI / 2;
      for (int j = 0; j < i + 1; j++) { angleSum += currentAngles[j]; }
      
      Point2D[] currentPoints = getSegmentPoints(joint, length_, angleSum);
      if (isCollidingCircleBoxPoints(obstacle, currentPoints)) {println("CURRENTLY COLLIDING"); }
      float nextAngle = angleSum;
      if (startToGoal.cross(startToEndEffector) < 0)
        nextAngle += angleDiff;
      else
        nextAngle -= angleDiff;
      Point2D[] nextPoints = getSegmentPoints(joint, length_, nextAngle);
      
      if (isCollidingCircleBoxPoints(obstacle, nextPoints)) {
        println("ABOUT TO COLLIDE");
        if (startToGoal.cross(startToEndEffector) < 0)
          currentAngles[i] -= angleDiff;
        else
          currentAngles[i] += angleDiff;
        break;
      } else {
        if (startToGoal.cross(startToEndEffector) < 0)
          currentAngles[i] += angleDiff;
        else
          currentAngles[i] -= angleDiff;
        if (currentAngles[i] > rootAngles[i] + rotateLimits[i]) currentAngles[i] = rootAngles[i] + rotateLimits[i];
        if (currentAngles[i] < rootAngles[i] - rotateLimits[i]) currentAngles[i] = rootAngles[i] -rotateLimits[i];
        fk();
      }
      
      
      //if (startToGoal.cross(startToEndEffector) < 0)
      //  currentAngles[i] += angleDiff;
      //else
      //  currentAngles[i] -= angleDiff;
      //if (currentAngles[i] > rootAngles[i] + rotateLimits[i]) currentAngles[i] = rootAngles[i] + rotateLimits[i];
      //if (currentAngles[i] < rootAngles[i] - rotateLimits[i]) currentAngles[i] = rootAngles[i] -rotateLimits[i];
      //fk();
    }
    
    String anglesString = "";
    for (int i = 0; i < getJoints().length; i++) {
      anglesString = anglesString + "Angle " + i + ": " + currentAngles[i] + " ";
    }
    
    println(anglesString);
  }
  
  void fk() {
    for (int i = 0; i < getJoints().length; i++) {
      Point2D joint = points[i];
      float segmentLength = lengths[i];
      float angleSum = 0;
      for (int j = 0; j < i + 1; j++) { angleSum += currentAngles[j]; }
      float x = cos(angleSum) * segmentLength;
      float y = sin(angleSum) * segmentLength;
      points[i + 1] = joint.plus(new Vector2D(x,y));
    }
  }
  
  
  void update() {
    fk();
    solve(new Point2D(mouseX, mouseY));
    draw();
  }
  
  boolean intersectsWithCircle(Circle circle) {
    Point2D[] joints = getJoints();
    for (int i = 0; i < joints.length; i++) {
      Point2D joint = joints[i];
      float length_ = lengths[i];
      float angleSum = - PI / 2;
      for (int j = 0; j < i + 1; j++) { angleSum += currentAngles[j]; }
      Point2D[] currentPoints = getSegmentPoints(joint, length_, angleSum);      
      if (isCollidingCircleBoxPoints(circle, currentPoints)) { return true; }
    }
    return false;
  }
  
  Point2D[] getSegmentPoints(Point2D joint, float lengthSegment, float angle) {
    Point2D pointA = new Point2D(joint.x - armWidth/2, joint.y);
    Point2D pointB = new Point2D(joint.x + armWidth/2, joint.y);
    Point2D pointC = new Point2D(joint.x + armWidth/2, joint.y + lengthSegment);
    Point2D pointD = new Point2D(joint.x - armWidth/2, joint.y + lengthSegment);
    Point2D[] points = {pointA, pointB, pointC, pointD};
    for (int j = 0; j < 4; j++) {        
      Point2D point = points[j];
      float tX = point.x - joint.x;
      float tY = point.y - joint.y;
      
      float rotatedX = tX * cos(angle) - tY*sin(angle);
      float rotatedY = tX * sin(angle) + tY*cos(angle);
      
      point.x = rotatedX + joint.x;
      point.y = rotatedY + joint.y;
      //circle(point.x, point.y, 5);
    }
    return points;
  }
  
  void draw() {
    fill(200,0,180);
    Point2D[] joints = getJoints();
    for (int i = 0; i < joints.length; i++) {
      Point2D joint = joints[i];
      float length_ = lengths[i];
      float angleSum = 0;
      for (int j = 0; j < i + 1; j++) { angleSum += currentAngles[j]; }
      
      pushMatrix();
      translate(joint.x, joint.y);
      rotate(angleSum);
      rect(0, -10, length_, armWidth);
      popMatrix();
    }
  }
}

int armWidth = 20;
  
