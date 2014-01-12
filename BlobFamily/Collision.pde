
void worldBoundCollision(Particle p)
{
  p.pos = vmin(vmax(p.pos, new PVector(0.0, 0.0, 0.0)), new PVector(float(width), float(height), 0.0));
}
