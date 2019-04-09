// A simple Particle class
class Particle {
  PVector center;
  float radius;
  float lifespan;
  
  Particle(PVector center, float radius) {
    this.center = center.copy();
    this.lifespan = 255;
    this.radius = radius;
  }

  void run() {
    update();
    display();
  }
  
  // Method to update the particle's remaining lifetime (does nothing)
  void update() {
    //lifespan -= 1;
  }
  
  // Method to display
  void display() {
    gameSurface.pushMatrix();
    gameSurface.stroke(255, lifespan);
    gameSurface.fill(255, lifespan);
    gameSurface.translate(center.x, center.y, center.z);
    gameSurface.rotateX(radians(90));
    gameSurface.shape(openCylinder);
    gameSurface.popMatrix();
  }
}
