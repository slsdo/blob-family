
// Factory of things

void addTest1P()
{
  ParticleSystem test = new ParticleSystem(t_size, 30, 30);
  
  Particle t1 = test.addParticle(200, 300, 100, 40);
  
  // Create constraints for surrounding particles
  test.addConstraint(t1, t1, 100, 150, 200, 10);
  
  test.setSize(100);
  
  blobs.add(test);
}

void addTest2P()
{
  ParticleSystem test = new ParticleSystem(t_size, 30, 30);
  
  Particle t1 = test.addParticle(200, 300, 100, 40);
  Particle t2 = test.addParticle(400, 300, 100, 40);
  
  // Create constraints for surrounding particles
  test.addConstraint(t1, t2, 100, 150, 200, 10);
  
  test.setSize(100);
  
  blobs.add(test);
}

void addTest3P()
{
  ParticleSystem test = new ParticleSystem(t_size, 30, 30);
  
  Particle t1 = test.addParticle(300, 300, 20, 40);
  Particle t2 = test.addParticle(340, 300, 20, 40);
  Particle t3 = test.addParticle(320, 330, 20, 40);
  
  // Create constraints for surrounding particles
  test.addConstraint(t1, t2, 40, 80, 100, 10);
  test.addConstraint(t1, t3, 40, 80, 100, 10);
  test.addConstraint(t3, t2, 40, 80, 100, 10);
  
  test.setSize(100);
  
  blobs.add(test);
}

// Simple spherical blob with a center particle and a circle of particles around it
void addVerletBlob(int segments, float min, float mid, float max, float kspring, float x, float y, float mass, float rad, int mb_size, int mb_thresh)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  ParticleSystem verlet = new ParticleSystem(t_size, mb_size, mb_thresh);
  
  // Center particle
  Particle center = verlet.addParticle(x, y, mass, rad);
  
  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = verlet.addParticle(bx, by, mass, rad);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    // To next point
    verlet.addConstraint(pa[i], pa[next], seg_length*0.9, seg_length, seg_length*1.1, kspring);
    // To center point
    verlet.addConstraint(pa[i], center, min, mid, max, kspring);
  }
  
  verlet.setSize(0.5*min + max);
  
  blobs.add(verlet);
}

// Same as simple blob with extra braces on every other point
void addBracedBlob(int segments, float min, float mid, float max, float kspring, float x, float y, float mass, float rad, int mb_size, int mb_thresh)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  float seg_length2 = 2.0 * mid * sin(angle_step*2.0/2.0);
  float seg_length3 = 2.0 * mid * sin(angle_step*3.0/2.0);
  ParticleSystem braced = new ParticleSystem(t_size, mb_size, mb_thresh);
  
  // Center particle
  Particle center = braced.addParticle(x, y, mass, rad);
  
  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = braced.addParticle(bx, by, mass, rad);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    int next2 = (i + 3) % segments;
    // To next point
    braced.addConstraint(pa[i], pa[next], seg_length*0.1, seg_length, seg_length*2.1, kspring);
    // To next next point
    braced.addConstraint(pa[i], pa[next2], seg_length*0.1, seg_length3, seg_length3*2.1, kspring);
    // To center point
    braced.addConstraint(pa[i], center, min, mid, max, kspring);
  }
  
  braced.setSize(0.5*min + max);
  
  blobs.add(braced);
}

// A blob with thick structural skin
void addSkinnedBlob(int segments, float inner, float outer, float outer_spring, float inner_spring, float x, float y, float mass, float rad, int mb_size, int mb_thresh)
{
  float angle_step = 2.0 * PI / float(segments);
  float outer_length = 2.0 * outer * sin(angle_step/2.0);
  float inner_length = 2.0 * inner * sin(angle_step/2.0);
  float ring_gap = outer - inner;
  ParticleSystem skinned = new ParticleSystem(t_size, mb_size, mb_thresh);
  
  // Center particle
  Particle center = skinned.addParticle(x, y, mass, rad);

  Particle[] pa = new Particle[segments*2];
  // Create outer circle particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + inner * cos(angle);
    float by = y + inner * sin(angle);
    float cx = x + outer * cos(angle);
    float cy = y + outer * sin(angle);
    // i*2 is outer
    pa[i*2] = skinned.addParticle(cx, cy, mass, rad);
     // i*2+1 is inner
    pa[i*2 + 1] = skinned.addParticle(bx, by, mass, rad);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    // Outer ring
    skinned.addConstraint(pa[i*2], pa[next*2], outer_length*0.9, outer_length, outer_length*1.1, outer_spring);
    // Inner ring
    skinned.addConstraint(pa[i*2 + 1], pa[next*2 + 1], inner_length*0.9, inner_length, inner_length*1.1, outer_spring);
    // Join rings with structural springs
    skinned.addConstraint(pa[i*2], pa[i*2 + 1], ring_gap*0.9, ring_gap, ring_gap*1.1, outer_spring);
    // Cross brace
    skinned.addConstraint(pa[i*2], pa[next*2 + 1], ring_gap*0.9, ring_gap, ring_gap*1.1, outer_spring);
    // Inner ring to center point, with mid point of the spring to be greater than radius for internal pressure
    skinned.addConstraint(pa[i*2 + 1], center, inner*0.2, inner*1.5, inner*2.1, inner_spring);
  }
  
  skinned.setSize(0.2*segments*outer_length);
  
  blobs.add(skinned);
}

// Similar construction as Gish, same as Braced but also connected to opposite particle
void addTarBlob(int segments, float min, float mid, float max, float kspring, float x, float y, float mass, float rad, int mb_size, int mb_thresh)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  float seg_length2 = 2.0 * mid * sin(angle_step*2.0/2.0);
  ParticleSystem tar = new ParticleSystem(t_size, mb_size, mb_thresh);

  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = tar.addParticle(bx, by, mass, rad);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    int next1 = (i + 2) % segments;
    // To next point
    tar.addConstraint(pa[i], pa[next], seg_length*0.8, seg_length, seg_length*1.2, kspring);
    // To next next point
    tar.addConstraint(pa[i], pa[next1], seg_length*0.1, seg_length2, seg_length2*2.1, kspring);
    // To opposite point
    if (i < segments/2) { 
      tar.addConstraint(pa[i], pa[i + segments/2], min, mid*2.0, max, kspring);
    }
  }
  
  tar.setSize(seg_length*8);
  
  blobs.add(tar);
}

