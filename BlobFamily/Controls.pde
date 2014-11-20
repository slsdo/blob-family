
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
    if (key == 'z') metaball_size-=10;
    if (key == 'x') metaball_size+=10;
    if (key == 'c') metaball_band-=10;
    if (key == 'v') metaball_band+=10;
    if (key == ' ') blobs = new ArrayList(); // Reset blobs

    if (key == '1') addVerletBlob(10, width/2, height/2, 1, 40, 10, 15, 20, 10); // Small verlet
    if (key == '!') addVerletBlob(10, width/2, height/2, 1, 80, 20, 30, 40, 10); // Small verlet
    if (key == '2') addBracedBlob(10, width/2, height/2, 1, 40, 10, 15, 18, 10); // Small braced
    if (key == '@') addBracedBlob(10, width/2, height/2, 1, 80, 20, 30, 35, 10); // Big braced
    if (key == '3') addSkinnedBlob(20, width/2, height/2, 1, 60, 40, 50, 100, 100); // Medium skinned
    if (key == '4') addTarBlob(10, width/2, height/2, 1, 60, 5, 20, 40, 10); // Medium tar
    if (key == '5') { enable_metaball = false; addVerletBlob(30, width/2, height/2, 1, 40, 80, 120, 150, 10); } // Big verlet
    if (key == '6') { enable_metaball = false; addBracedBlob(20, width/2, height/2, 1, 40, 80, 120, 150, 10); } // BIG braced
    if (key == '7') { enable_metaball = false; addSkinnedBlob(60, width/2, height/2, 1, 40, 100, 120, 10, 10); } // Big skinned
    if (key == '8') { enable_metaball = false; addTarBlob(40, width/2, height/2, 1, 40, 20, 100, 300, 10); }
    //if (key == 'asd') addSkinnedBlob(40, width/2, height/2, 1, 40, 50, 60, 10, 100);
    //if (key == 'asd') addSkinnedBlob(40, width/2, height/2, 1, 40, 50, 65, 10, 10);
    //if (key == 'asd') addSkinnedBlob(40, width/2, height/2, 1, 40, 50, 65, 10, 20);
}

void keyReleased() {
         if (key == CODED && keyCode == UP) keys[0] = false;
    else if (key == CODED && keyCode == LEFT) keys[1] = false;
    else if (key == CODED && keyCode == DOWN) keys[2] = false;
    else if (key == CODED && keyCode == RIGHT) keys[3] = false;
}

