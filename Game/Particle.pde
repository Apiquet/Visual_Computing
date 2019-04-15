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
  }
}
