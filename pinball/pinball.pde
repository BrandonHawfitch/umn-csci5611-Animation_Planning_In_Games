void setup() {
  size(650, 800);
  stroke(0,0,0);
  background(255);
  fill(0, 0, 0);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  
  resetScene();
}

void draw() {
  background(255);
  float dt = 1 / frameRate;
  handleCollisions();
  updateScene(dt);
  handleKeyPress();
  drawScene();
}

void drawScene() {
  for (int i = 0; i < numBalls; i++) {
    Ball ball_d = balls[i];
    ball_d.draw();
  }
  for (int i = 0; i < obstacles.length; i++) {
    Obstacle obstacle = obstacles[i];
    obstacle.draw();
  }
  leftFlipper.draw();
  rightFlipper.draw();
  plunger.draw();
}

void updateScene(float dt) {
  for (int i = 0; i < numBalls; i++) {
    Ball ball = balls[i];
    ball.update(dt);
    ball.applyForce(gravity);
  }
  leftFlipper.update(dt);
  rightFlipper.update(dt);
  plunger.update(dt);
}

void handleCollisions() {
  for (int i = 0; i < balls.length; i++) {
    Ball ballA = balls[i];
    
    // Obstacles
    for (int j = 0; j < obstacles.length; j++) {
      Obstacle obstacle = obstacles[j];
      obstacle.detectAndHandleCollision(ballA);
    }
    
    // Balls
    for (int j = 0; j < balls.length; j++) {
      Ball ballB = balls[j];
      ballB.detectAndHandleCollision(ballA);
    }
    
    // Flipper
    leftFlipper.detectAndHandleCollision(ballA);
    rightFlipper.detectAndHandleCollision(ballA);
    
    // Plunger
    plunger.detectAndHandleCollision(ballA);
  }
}

void resetScene() {
  topLeft = new Point2D(0, 0);
  topRight = new Point2D(width, 0);
  bottomLeft = new Point2D(0, height);
  bottomRight = new Point2D(width, height);
  topWall = new LineSegment(topLeft, topRight);
  rightWall = new LineSegment(topRight, bottomRight);
  bottomWall = new LineSegment(bottomRight, bottomLeft);
  leftWall = new LineSegment(bottomLeft, topLeft);
  topBorder = new Obstacle(topWall);
  rightBorder = new Obstacle(rightWall);
  bottomBorder = new Obstacle(bottomWall);
  leftBorder = new Obstacle(leftWall);
  Obstacle[] sceneObstacles = parseObstacles("pinball1.txt");
  //int numObstacles = numBorders + numDefaultObstacles;
  int numObstacles = numBorders + numDefaultObstacles + sceneObstacles.length;
  obstacles = new Obstacle[numObstacles];
  
  for (int i = 0; i < sceneObstacles.length; i++) {
    obstacles[i] = sceneObstacles[i];
  }
  
  obstacles[obstacles.length - 6] = topBorder;
  obstacles[obstacles.length - 5] = rightBorder;
  obstacles[obstacles.length - 4] = bottomBorder;
  obstacles[obstacles.length - 3] = leftBorder;
  obstacles[obstacles.length - 2] = plungerWall;
  obstacles[obstacles.length - 1] = cornerStop;
    
  ball = new Ball(new Circle(350, 650, 10), 5);
  balls[0] = ball;
  ball.geometry.gColor = color(255,0,0);
  
  for(int i = 1; i < numBalls; i++) {
    float randomX = random(0, width);
    float randomY = random(0, height);
    float randomR = random(10, 40);
    float randomM = random(1, 5);
    balls[i] = new Ball(new Circle(randomX, randomY, randomR), randomM);
  }
}
