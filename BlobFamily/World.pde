
class Ground
{
  int h;
  
  Ground() {}
  
  // Create bounding walls
  void init() {
    h = ground_h;
  }
  
  void render() {
    fill(#C5AD87);
    rect(0, 600 - h, 800, h);
  }
}

// Simple world collision detection 
void detectCollision(Particle p)
{
  if (checkCollision(p.pos, p.mass*0.5)) {
    PVector normal = getNormal(p);    
    PVector movement = PVector.sub(p.pos, p.pos0);
    float perp = movement.dot(normal);    
    PVector parallel = PVector.sub(movement, PVector.mult(normal, perp));
    
    if (!checkCollision(PVector.add(p.pos0, parallel) , p.mass*0.5)) {
      p.pos = PVector.add(p.pos0, PVector.mult(parallel, f_friction));
    }
    else {
      // If all else fails, just move to collision point
      if (normal.x < 0.0) p.pos.x = p.mass*0.5;
      else if (normal.x > 0.0) p.pos.x = width - p.mass*0.5;
      if (normal.y < 0.0) p.pos.y = p.mass*0.5;
      else if (normal.y > 0.0) p.pos.y = height - ground.h - p.mass*0.5;
    }
  }
}

boolean checkCollision(PVector pos, float mass)
{
  // Check x component
  if (pos.x < mass) return true;
  else if (pos.x > width - mass) return true;
  // Check y component
  if (pos.y < mass) return true;
  else if (pos.y > height - ground.h  - mass) return true;
  return false;  
}

PVector getNormal(Particle p)
{
  PVector normal = new PVector(0.0, 0.0, 0.0);
  // Check x component
  if (p.pos.x < p.mass) normal.x = -1.0;
  else if (p.pos.x > width - p.mass) normal.x = 1.0;
  // Check y component
  if (p.pos.y < p.mass) normal.y = -1.0;
  else if (p.pos.y > height - ground.h  - p.mass) normal.y = 1.0;
  return normal;  
}
  
void metaBall() {
  loadPixels();
  // Render blob metaball for each blob
  for (int bb = 0; bb < blobs.size(); bb++) {
    ParticleSystem b = blobs.get(bb);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y*width;
        // If within metaball bounding box, draw blob
        if (metabox[index] == 1 && !DEBUG) {
          float sum = 0.0;
            
          int psize = b.particles.size();
          // Render particles
          for (int i = 0; i < psize; i++) {
            Particle p = b.particles.get(i);
      
            float xx = p.pos.x - x;
            float yy = p.pos.y - y;
      
            sum += p.rad*4 / sqrt(xx * xx + yy * yy);
          }
          float col = sum*sum*sum/metaball_band;
          if (sum > metaball_size) pixels[index] = color(255 - col, 255 - col, 255 - col, 255 - col);
        }
      }
    }
  }
  updatePixels();
}
