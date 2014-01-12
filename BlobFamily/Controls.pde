
void mousePressed () {
  // Get mouse position
  PVector m = new PVector(mouseX, mouseY);  
  // Look for a particle the mouse is in
  int bn = blobs.size();
  for (int i = 0; i < bn; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);    
    int n = b.blob.size();
    for (int j = 0; j < n; j++) {
      Particle p = (Particle) b.blob.get(j);      
      // If the mouse is close to the particle
      if (dist2(p.pos, m) < sq(p.mass + 10)) {
        if (mouseButton == LEFT) p.drag = true;
        break; // Break out of the loop because we found our particle
      }
    }
  }
}

void mouseReleased() {
  // User is no-longer dragging
  int bn = blobs.size();
  for (int i = 0; i < bn; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);
    int n = b.blob.size();
    for (int j = 0; j < n; j++) {
      Particle p = (Particle) b.blob.get(j);
      if (p.drag) {
        p.drag = false;
        break;
      }
    }
  }
}

void keyPressed() {
    // Movements
         if (key == CODED && keyCode == UP) keys[0] = true;
    else if (key == CODED && keyCode == LEFT) keys[1] = true;
    else if (key == CODED && keyCode == DOWN) keys[2] = true;
    else if (key == CODED && keyCode == RIGHT) keys[3] = true;

    if (key == ' ' && jump == 0) jump = 1; // Jump
    if (key == 'g') enable_gravity = !enable_gravity; // Enable gravity
    if (key == 'l') d_lock1 = !d_lock1; // Lock first particle
    if (key == 's') STRUCT = !STRUCT; // Structural view
    if (key == 'd') DEBUG = !DEBUG; // Debug view
    if (key == ENTER || key == RETURN) blobs = new ArrayList(); // Reset blobs

    if (key == '1') addTest3P();
    if (key == '2') addVerletBlob(20, width/2, height/2, 150, 200, 250, 10);
    if (key == '3') addBracedBlob(20, width/2, height/2, 50, 80, 120, 10);
    if (key == '4') addSkinnedBlob(20, width/2, height/2, 50, 65, 10, 50);
}

void keyReleased() {
         if (key == CODED && keyCode == UP) keys[0] = false;
    else if (key == CODED && keyCode == LEFT) keys[1] = false;
    else if (key == CODED && keyCode == DOWN) keys[2] = false;
    else if (key == CODED && keyCode == RIGHT) keys[3] = false;

    if (key == ' ' || jump == -1) jump = 0;
}

