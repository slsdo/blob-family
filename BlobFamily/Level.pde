
class Level
{
  Wall[] walls;
  
  Level() {}
  
  void initWallSimple() {
    walls = new Wall[4];
    walls[0] = new Wall(0.0, 0.0, width, 20.0); // Ceiling
    walls[1] = new Wall(0.0, height - 20.0, width, height); // Floor
    walls[2] = new Wall(0.0, 20.0, 20.0, height - 20.0); // Left wall
    walls[3] = new Wall(width - 20.0, 20.0, width, height - 20.0); // right wall
  }
  
  void render() {
    fill(#C5AD87);
    for (int i = 0; i < walls.length; i++) {
      rect(walls[i].x1, walls[i].y1, walls[i].x2 - walls[i].x1, walls[i].y2 - walls[i].y1);
    }
  }
}

class Wall
{
  float x1, x2, y1, y2;
  
  Wall(float posx1, float posy1, float posx2, float posy2) {
    x1 = posx1;
    x2 = posx2;
    y1 = posy1;
    y2 = posy2;
  }
}
