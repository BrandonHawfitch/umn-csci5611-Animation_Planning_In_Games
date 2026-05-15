//A list of circle obstacles
static int numObstacles = 50;
Circle obstacles[] = new Circle[numObstacles];

void placeRandomObstacles(){
  //Initial obstacle position
  for (int i = 0; i < numObstacles; i++){
    Circle circle;
    do {
      Point2D circlePos = new Point2D(random(50,950),random(50,700));
      float circleRad = (30+40*pow(random(1),3));
      circle = new Circle(circlePos, circleRad);
    } while(colliding(circle, agent.getBoundingCircle()) || colliding(circle, goal));
    obstacles[i] = circle;    
  }
}

void drawObstacles() {
  for (int i = 0; i < numObstacles; i++){
    //obstacles[i].draw();
    Circle obstacle = obstacles[i];
    fill(0);
    circle(obstacle.center.x, obstacle.center.y, obstacle.radius - agent.getBoundingCircle().radius);
  }
}
