
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

void worldBoundCollision(Particle p)
{
  p.pos = vmin(vmax(p.pos, new PVector(0.0, ground.h, 0.0)), new PVector(float(width), float(height), 0.0));
}

