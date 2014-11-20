
class Ground
{
  int h;
  
  Ground() {}
  
  // Create bounding walls
  void init() {
    h = ground_h;
  }
  
  void render() {
    fill(#c5ad87);
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
  for (int n = 0; n < blobs.size(); n++) {
    ParticleSystem ps = blobs.get(n);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y*width;
        // If within metaball bounding box, draw blob
        if (metabox[index] == 1 && !DEBUG) {
          float sum = 0.0;
                      
          int psize = ps.particles.size();
          // Render particles
          for (int i = 0; i < psize; i++) {
            Particle p = ps.particles.get(i);
      
            float xx = p.pos.x - x;
            float yy = p.pos.y - y;
      
            //sum += p.rad / sqrt(xx * xx + yy * yy); // Optimization: Get rid of the sqrt()
            sum += p.rad*metaball_size / (xx * xx + yy * yy);
          }
          
          //float col = 255 - sum*sum*sum/metaball_band;
          float col = 255 - sum;
          color argb = pixels[index];
          int a = (argb >> 24) & 0xFF;
          int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
          int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
          int b = argb & 0xFF;          // Faster way of getting blue(argb)
          if (sum > metaball_band) pixels[index] = color(0.8*r + col, 0.8*g + col, 0.8*b + col, col);
        }
      }
    }
  }
  updatePixels();
}
