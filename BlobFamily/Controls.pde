
void mousePressed () {
  // Look for a particle the mouse is in
  PVector m = new PVector(mouseX, mouseY);
  for (int i = 0; i < test.blob.length; i++) {
    // If the mouse is close to the particle
    if (dist2(test.blob[i].pos, m) < sq(test.blob[i].mass*1.5)) {
      if (mouseButton == LEFT) test.blob[i].drag = true;
      break; // Break out of the loop because we found our particle
    }
  }
}

void mouseReleased() {
  // User is no-longer dragging
  for (int i = 0; i < test.blob.length; i++) {
    if (test.blob[i].drag) {
      test.blob[i].drag = false;
      break;
    }
  }
}

void keyPressed() {
         if (key == 'w' || (key == CODED && keyCode == UP)) keys[0] = true;
    else if (key == 'a' || (key == CODED && keyCode == LEFT)) keys[1] = true;
    else if (key == 's' || (key == CODED && keyCode == DOWN)) keys[2] = true;
    else if (key == 'd' || (key == CODED && keyCode == RIGHT)) keys[3] = true;

    if (key == ' ' && jump == 0) jump = 1;

    if (key == '1') test = createVerletBlob(20, width/2, height/2, 20, 50, 80, 20);
}

void keyReleased() {
         if (key == 'w' || (key == CODED && keyCode == UP)) keys[0] = false;
    else if (key == 'a' || (key == CODED && keyCode == LEFT)) keys[1] = false;
    else if (key == 's' || (key == CODED && keyCode == DOWN)) keys[2] = false;
    else if (key == 'd' || (key == CODED && keyCode == RIGHT)) keys[3] = false;

    if (key == ' ' || jump == -1) jump = 0;
}

