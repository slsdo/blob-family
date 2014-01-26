
class Collision
{
  ArrayList<Particle> vertices; // Collision vertices
  ArrayList<Constraint> edges; // Collision edges
  PVector p1; // Colliding particle 1
  PVector p2; // Colliding particle 2
  PVector pt; // Point of collisions
  PVector normal; // Collision normal
  float depth; // Depth of collision
  
  Collision() {
    vertices = new ArrayList<Particle>();
    edges = new ArrayList<Constraint>();
    p1 = new PVector(0, 0, 0);
    p2 = new PVector(0, 0, 0);
    pt = new PVector(0, 0, 0);
    normal = new PVector(0, 0, 0);
    depth = 0.0;
  }
}

void worldBoundCollision(Particle p)
{
  p.pos = vmin(vmax(p.pos, new PVector(0.0, 0.0, 0.0)), new PVector(float(width), float(height), 0.0));
}

boolean detectCollisionSAT(Collision b1, Collision b2)
{
  // Iterate through edges of both bodies
  int b1size = b1.edges.size();
  int b2size = b2.edges.size();
  for (int i = 0; i < b1size + b2size; i++) {
    Constraint edge;
    if (i <  b1size) edge = b1.edges.get(i);
    else edge = b2.edges.get(i - b1size);
    
    // Calculate the axis perpendicular to this edge and normalize it
    PVector axis = new PVector(edge.p1.pos.y - edge.p2.pos.y, edge.p2.pos.x - edge.p1.pos.x);
    axis.normalize();
    
    // Project both bodies onto the perpendicular axis
    float minA = 0; float maxA = 0;
    float minB = 0; float maxB = 0;
    projectToAxis(axis, minA, maxA, b1);
    projectToAxis(axis, minB, maxB, b2);
    
    // Determine is there is overlap between the two intervals
    boolean isOverlap = intervalOverlap(minA, maxA, minB, maxB);
    // If no overlap, there is no collision
    if (!isOverlap) return false;
  }  
  return true;
}

boolean intervalOverlap(float minA, float maxA, float minB, float maxB)
{
  // Calculate the distance between the two intervals
  float dist = (minA < minB) ? (minB - maxA) : (minA - maxB);
  if (dist > 0.0) return false; // There is no overlap

  return true; // Overlapping
}

void projectToAxis(PVector axis, float min, float max, Collision b)
{
  int psize = b.vertices.size();
  float dotp = axis.dot(b.vertices.get(0).pos);
  
  // Set minimum and maximum values to the projection of the first vertex
  min = dotp;
  max = dotp;
  
  for (int i = 1; i < psize; i++) {
    // Project rest of the points to the axis and extend min/max interval
    dotp = axis.dot(b.vertices.get(i).pos);
    
    min = min(dotp, min);
    max = max(dotp, max);
  }  
}

