
void mousePressed () {
  // Get mouse position
  PVector m = new PVector(mouseX, mouseY);
  // Look for a particle the mouse is in
  int blobnum = blobs.size();
  for (int i = 0; i < blobnum; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);
    for (int j = 0; j < b.blob.length; j++) {
      // If the mouse is close to the particle
      if (dist2(b.blob[j].pos, m) < sq(b.blob[j].mass*1.5)) {
        if (mouseButton == LEFT) b.blob[j].drag = true;
        break; // Break out of the loop because we found our particle
      }
    }
  }
}

void mouseReleased() {
  // User is no-longer dragging
  int blobnum = blobs.size();
  for (int i = 0; i < blobnum; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);
    for (int j = 0; j < b.blob.length; j++) {
      if (b.blob[j].drag) {
        b.blob[j].drag = false;
        break;
      }
    }
  }
}

void keyPressed() {
         if (key == 'w' || (key == CODED && keyCode == UP)) keys[0] = true;
    else if (key == 'a' || (key == CODED && keyCode == LEFT)) keys[1] = true;
    else if (key == 's' || (key == CODED && keyCode == DOWN)) keys[2] = true;
    else if (key == 'd' || (key == CODED && keyCode == RIGHT)) keys[3] = true;

    if (key == ' ' && jump == 0) jump = 1;

    if (key == '1') {
      blobs = new ArrayList();
      addVerletBlob(20, width/2, height/2, 20, 50, 80, 10);
    }

    if (key == '2') {
      blobs = new ArrayList();
      addTest2P();
    }
}

void keyReleased() {
         if (key == 'w' || (key == CODED && keyCode == UP)) keys[0] = false;
    else if (key == 'a' || (key == CODED && keyCode == LEFT)) keys[1] = false;
    else if (key == 's' || (key == CODED && keyCode == DOWN)) keys[2] = false;
    else if (key == 'd' || (key == CODED && keyCode == RIGHT)) keys[3] = false;

    if (key == ' ' || jump == -1) jump = 0;
}

