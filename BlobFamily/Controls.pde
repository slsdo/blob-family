
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
      if (dist2(p.pos, m) < sq(p.mass + 20)) {
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

    if (key == 'g') enable_gravity = !enable_gravity; // Enable gravity
    if (key == 'l') d_lock1 = !d_lock1; // Lock first particle
    if (key == 's') STRUCT = !STRUCT; // Structural view
    if (key == 'd') DEBUG = !DEBUG; // Debug view
    if (key == ' ') blobs = new ArrayList(); // Reset blobs

    if (key == '1') addTest2P();
    //if (key == '1') addTest3P();
    if (key == '2') addVerletBlob(30, width/2, height/2, 80, 120, 150, 10); // Big verlet
    //if (key == '2') addVerletBlob(40, width/2, height/2, 20, 50, 80, 20); // Small verlet
    if (key == '3') addBracedBlob(10, width/2, height/2, 80, 120, 150, 10); // Big braced
    //if (key == '3') addBracedBlob(40, width/2, height/2, 20, 30, 35, 20); // Small braced
    if (key == '4') addSkinnedBlob(30, width/2, height/2, 100, 120, 10, 10);
    //if (key == '4') addSkinnedBlob(40, width/2, height/2, 50, 60, 10, 100);
    //if (key == '5') addSkinnedBlob(40, width/2, height/2, 50, 65, 10, 10);
    //if (key == '6') addSkinnedBlob(40, width/2, height/2, 50, 65, 10, 20);
    //if (key == '7') addSkinnedBlob(80, width/2, height/2, 50, 60, 10, 20);
    if (key == '5') addDenseBlob(10, width/2, height/2, 10, 100, 500, 10);
    if (key == '6') addTarBlob(40, width/2, height/2, 20, 100, 300, 10);
}

void keyReleased() {
         if (key == CODED && keyCode == UP) keys[0] = false;
    else if (key == CODED && keyCode == LEFT) keys[1] = false;
    else if (key == CODED && keyCode == DOWN) keys[2] = false;
    else if (key == CODED && keyCode == RIGHT) keys[3] = false;
}

