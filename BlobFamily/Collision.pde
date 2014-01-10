
void worldBoundCollision(Particle p)
{
  p.pos = vmin(vmax(p.pos, new PVector(0.0, 0.0, 0.0)), new PVector(float(width), float(height), 0.0));
}

/*
void worldPointCollision(Particle p)
{
  if (c.checkCollision(p.pos, neighbor.pos)) {
    // Collision point
    PVector collision = c.getPoint();
    // The attempted movment of the point
    PVector movement = PVector(p.pos, p.pos0);
    // Normal of the surface that collided with
    PVector normal = c.getNormal();
    // Magnitude of the component of motion perpendicular to the surface
    float perp = PVector.dot(movement, normal);
    // Project vector onto the surface
    PVector parallel = PVector.sub(movement, PVector.mult(normal, perp));
    
    if (DEBUG) {
      stroke(#000000);
      line(p.pos0.x, p.pos0.y, p.pos0.x + parallel.x*20, p.pos0.y + parallel.y*20);
    }
    
    if (!c.checkCollision(p.pos0, PVector.add(p.pos0, parallel)) {
      // No longer in collision
      p.setPos((p.pos0.x + parallel.x * friction), (p.pos0.y + parallel.y * friction));
    }
    else {
      // Worse case move to the collision point and raise slightly off the surface
      p.setPos((collision.x + 0.01 * normal.x), (collision.y + 0.01 * normal.y));  
    }
  }
}

void worldLineCollision(Particle p)
{
  // Both verlets points have independ motion
  // which together has caused this line/world collision
  // since point collisions have already been resolved
  // it is unlikely that the individual point penetrate the world
  // so attemptin to move the original line segment parallel to itself
  // will likely be safe
  // and will allow the segments to slide over corners
    
  if (c.checkCollision(p.pos, neighbor.pos) {
    PVector a = p.pos0.get();
    PVector b = neighbor.pos0.get();
    PVector av = PVector.sub(p.pos.get(), a);
    PVector bv = PVector.sub(neighbor.pos.get(), b);
    PVector p = PVector.sub(a, b);
    p.normalize(); // normal vector from a to b
    // Project a and b onto p
    PVector ap = PVector.mult(p, PVector.dot(av, p));
    PVector bp = PVector.mult(p, PVector.dot(bv, p));
    PVector a2 = PVector.add(a, ap);
    PVector ab = PVector.add(b, bp);
    // Might also need to check a to a2 and b to b2
    if (!c.checkCollision(a2, b2) && !c.checkCollision(a, a2) && !c.checkCollision(b, b2)) {
      p.setPos(a2.x, a2.y);
      neighbor.setPos(b2.x, b2.y);
    }
    else {
      p.setPos(p.pos0.x, p.pos0.y);
      neighbor.setPos(neighbor.pos0.x, neighbor.pos0.y);
    }
    
    
  }
}
*/
