Ball ball;
Vector2D gravity = new Vector2D(0, 5.0);
int numBalls = 1;
Ball[] balls = new Ball[numBalls];

Point2D topLeft;
Point2D topRight;
Point2D bottomLeft;
Point2D bottomRight;
LineSegment topWall;
LineSegment rightWall;
LineSegment bottomWall;
LineSegment leftWall;
Obstacle topBorder;
Obstacle rightBorder;
Obstacle bottomBorder;
Obstacle leftBorder;
int numBorders = 4;

Obstacle plungerWall = new Obstacle(new LineSegment(600, 800, 600, 150));
Obstacle cornerStop = new Obstacle(new LineSegment(550, 0, 650, 100));
int numDefaultObstacles = 2;

Obstacle[] obstacles;
//Obstacle[] borders = {new Obstacle(topWall), new Obstacle(rightWall), new Obstacle(bottomWall), new Obstacle(leftWall)};

Box plungerBox = new Box(625, 600, 50, 30);
Plunger plunger = new Plunger(plungerBox);

Flipper leftFlipper = new Flipper(Side.LEFT, new Point2D(200, 750));
Flipper rightFlipper = new Flipper(Side.RIGHT, new Point2D(400, 750));
