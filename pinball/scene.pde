Obstacle[] parseObstacles(String fileName) {
  String[] fileContents = loadStrings(fileName);
  int numObstacles = Integer.valueOf(fileContents[0].split(" ")[1]);
  Obstacle[] obstacles = new Obstacle[numObstacles];
  int lineIndex = 1;
  int obstacleIndex = 0;
  while (lineIndex < fileContents.length) {
    String fileLine = fileContents[lineIndex];
    String entityType = fileLine.split(" ")[0];
    int numObjects = Integer.valueOf(fileLine.split(" ")[1]);
    lineIndex += 2;
    
    for(int i = 0; i < numObjects; i++) {
      fileLine = fileContents[lineIndex];
      String[] lineContents = fileLine.split(", ");
      Obstacle obstacle;
     
      if(entityType.equals("Circle")) {
        Circle c = fileLineToCircle(lineContents);
        obstacle = new Obstacle(c);
        obstacle.cor = Float.valueOf(lineContents[lineContents.length - 1]);
        obstacles[obstacleIndex] = obstacle;
      } else
      if(entityType.equals("LineSegment")) {
        LineSegment l = fileLineToLineSegment(lineContents);
        obstacle = new Obstacle(l);
        obstacle.cor = Float.valueOf(lineContents[lineContents.length - 1]);
        obstacles[obstacleIndex] = obstacle;
      } else
      if(entityType.equals("Box")) {
        Box b = fileLineToBox(lineContents);
        obstacle = new Obstacle(b);
        obstacle.cor = Float.valueOf(lineContents[lineContents.length - 1]);
        obstacles[obstacleIndex] = obstacle;
      }
      
      
      obstacleIndex++;
      lineIndex++;
    }
  }
  
  return obstacles;
}

Circle fileLineToCircle(String[] lineContents) {
  float x = Float.valueOf(lineContents[0]);
  float y = Float.valueOf(lineContents[1]);
  float r = Float.valueOf(lineContents[2]);
  return new Circle(x, y, r);
}

LineSegment fileLineToLineSegment(String[] lineContents) {
  float x1 = Float.valueOf(lineContents[0]);
  float y1 = Float.valueOf(lineContents[1]);
  float x2 = Float.valueOf(lineContents[2]);
  float y2 = Float.valueOf(lineContents[3]);
  return new LineSegment(x1, y1, x2, y2);
}

Box fileLineToBox(String[] lineContents) {
  float x = Float.valueOf(lineContents[0]);
  float y = Float.valueOf(lineContents[1]);
  float w = Float.valueOf(lineContents[2]);
  float h = Float.valueOf(lineContents[3]);
  return new Box(x, y, w, h);
}
