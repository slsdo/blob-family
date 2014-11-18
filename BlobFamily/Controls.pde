
void mousePressed () {
  // Get mouse position
  PVector m = new PVector(mouseX, mouseY);  
  // Look for a particle the mouse is in
  int bsize = blobs.size();
  for (int i = 0; i < bsize; i++) {
    ParticleSystem ps = (ParticleSystem) blobs.get(i);    
    int psize = ps.particles.size();
    for (int j = 0; j < psize; j++) {
      Particle p = (Particle) ps.particles.get(j);      
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
  int bsize = blobs.size();
  for (int i = 0; i < bsize; i++) {
    ParticleSystem ps = (ParticleSystem) blobs.get(i);
    int psize = ps.particles.size();
    for (int j = 0; j < psize; j++) {
      Particle p = (Particle) ps.particles.get(j);
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
    if (key == 's') show_struct = !show_struct; // Structural view
    if (key == 'd') DEBUG = !DEBUG; // Debug view
    if (key == 'm') enable_metaball = !enable_metaball; // Lock first particle
    if (key == 'z') metaball_band--;
    if (key == 'x') metaball_band++;
    if (key == 'c') metaball_size--;
    if (key == 'v') metaball_size++;
    if (key == ' ') blobs = new ArrayList(); // Reset blobs

    if (key == '1') addVerletBlob(30, width/2, height/2, 80, 120, 150, 10); // Big verlet
    if (key == '2') addBracedBlob(10, width/2, height/2, 10, 15, 18, 10); // Small braced
    if (key == '3') addBracedBlob(10, width/2, height/2, 20, 30, 35, 10); // Big braced
    if (key == '4') addBracedBlob(20, width/2, height/2, 80, 120, 150, 10); // BIG braced
    if (key == '5') addSkinnedBlob(60, width/2, height/2, 100, 120, 10, 10); // Big skinned
    if (key == '6') addSkinnedBlob(40, width/2, height/2, 50, 60, 10, 100);
    if (key == '7') addSkinnedBlob(40, width/2, height/2, 50, 65, 10, 10);
    if (key == '8') addSkinnedBlob(40, width/2, height/2, 50, 65, 10, 20);
    if (key == '9') addTarBlob(40, width/2, height/2, 20, 100, 300, 10);
    if (key == '0') addTest3P();
}

void keyReleased() {
         if (key == CODED && keyCode == UP) keys[0] = false;
    else if (key == CODED && keyCode == LEFT) keys[1] = false;
    else if (key == CODED && keyCode == DOWN) keys[2] = false;
    else if (key == CODED && keyCode == RIGHT) keys[3] = false;
}

