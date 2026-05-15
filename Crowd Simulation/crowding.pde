Agent agent;
Circle goal;
ArrayList<Point2D> solutionPath;

void setup() {
  ellipseMode(RADIUS);
  size(1000,800);
  agent = new Agent(new Point2D(50, height-50));
  goal = new Circle(new Point2D(width-50, 50), 15);
  goal.gColor = color(255,0,0);
  placeRandomObstacles();  
  buildPRM();
  
  solutionPath = runBFS();
  agent.path = solutionPath;
}

void draw() {
  float dt = 1 / frameRate;
  
  background(250,250,250);
  drawObstacles();
  agent.draw();
  goal.draw();
  agent.update(dt);
  drawPath(solutionPath);
  //drawPRM();
}
