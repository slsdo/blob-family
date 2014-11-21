/* Blob Family - v1.0.0 - 2014/11/21
   - by Future Data Lab | www.futuredatalab.com */

final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint

float t_size = 0.03; // Time step
float f_friction = 0.5; // Friction force
float f_max = 5000.0; // Max force
float f_jump = -60.0; // Jumping force

int relax_iter = 4; // Relaxation iteration
int[] metabox; // Metaball bounding box
int screen_size; // Cache screen size
int ground_h; // Ground height

boolean DEBUG = false; // Enable debug view
boolean show_fps = false; // Toggle FPS
boolean enable_metaball = true; // Toggle metaballs
boolean enable_gravity = true; // Toggle gravity
boolean enable_ai = false; // Toggle blob AI
boolean follow_m = false; // Blob will follow mouse pointer
boolean[] keys = new boolean[4]; // Check key press
boolean d_lock1 = false; // DEBUG: lock first particle

PVector gravity = new PVector(0, 80.0, 0); // Gravity vector
ArrayList<ParticleSystem> blobs;

void setup()
{
  size(800, 600);
  background(255, 255, 255);
  screen_size = width*height;
  ground_h = floor(height*0.2);
  metabox = new int[screen_size];
  blobs = new ArrayList<ParticleSystem>();
  
  initBlobs();
}

void draw()
{
  background(255, 255, 255);
  stroke(#555555);
  fill(#c4bd96);
  rect(0, height - ground_h, width, ground_h);

  // Reset metaball bounding box
  for (int i = 0; i < screen_size; i++) {
    metabox[i] = 0;
  }
  
  int bsize = blobs.size();
  for (int i = 0; i < bsize; i++) {
    ParticleSystem ps = blobs.get(i);
    ps.update();
    ps.render();
  }
  
  // Render metaball
  if (enable_metaball) metaBall();
  
  // Display framerate
  if (DEBUG || show_fps) {
    fill(0, 102, 153);
    text(frameRate, 10, 25);
    fill(0, 0, 0);
  }
}

// Render blob using metaball 
void metaBall() {
  loadPixels();
  // Render blob metaball for each blob
  int bsize = blobs.size();
  for (int i = 0; i < bsize; i++) {
    ParticleSystem ps = blobs.get(i);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y*width;
        // If within metaball bounding box, draw blob
        if (metabox[index] == 1 && !DEBUG) {
          float sum = 0.0;
                      
          int psize = ps.particles.size();
          // Render particles
          for (int j = 0; j < psize; j++) {
            Particle p = ps.particles.get(j);
      
            float xx = p.pos.x - x;
            float yy = p.pos.y - y;
      
            //sum += p.rad / sqrt(xx * xx + yy * yy); // Optimization: Get rid of the sqrt()
            sum += p.rad*ps.mb_size / (xx * xx + yy * yy);
          }
          
          //float col = 255 - sum*sum*sum/metaball_band;
          float col = 255 - sum;
          color argb = pixels[index];
          int a = (argb >> 24) & 0xFF;
          int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
          int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
          int b = argb & 0xFF;          // Faster way of getting blue(argb)
          if (sum > ps.mb_thresh) pixels[index] = color(0.8*r + col, 0.8*g + col, 0.8*b + col);
          else if (sum < ps.mb_thresh && sum > ps.mb_thresh - 30) pixels[index] = color(150, 150, 150); // Grey border
        }
      }
    }
  }
  updatePixels();
}

// Initialize some blobs
void initBlobs()
{
  enable_ai = true;
  addVerletBlob(10, 10, 15, 20, 10, width/2, height/2, 1, 40, 300, 300); // Small verlet
  addVerletBlob(10, 20, 30, 40, 10, width/2, height/2, 1, 140, 300, 300); // Big verlet
  addBracedBlob(10, 10, 15, 18, 10, width/2, height/2, 1, 40, 300, 300); // Small braced
  addBracedBlob(10, 10, 15, 18, 10, width/2, height/2, 1, 40, 300, 300); // Small braced
}

// Some math functions
PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }

