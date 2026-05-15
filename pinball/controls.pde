boolean leftPressed, rightPressed, downPressed;
void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == DOWN) plunger.pull();
}

void keyReleased(){
  // reset if 'r' if pressed
  if (key == 'r') resetScene(); 
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == DOWN) plunger.release();
}

void handleKeyPress() {
  leftFlipper.isFlipping = leftPressed;
  rightFlipper.isFlipping = rightPressed;
}
