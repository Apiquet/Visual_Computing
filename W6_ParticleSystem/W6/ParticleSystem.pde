// A class to describe a group of Particles
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float particleRadius = 10;
  
  ParticleSystem(PVector origin) {
    this.origin = origin.copy();
    particles = new ArrayList<Particle>();
    particles.add(new Particle(origin, particleRadius));
  }

  void addParticle() {
    PVector center;
    int numAttempts = 100;
    for(int i=0; i<numAttempts; i++) {
      // Pick a cylinder and its center.
      int index = int(random(particles.size())); 
      center = particles.get(index).center.copy();
      // Try to add an adjacent cylinder.
      float angle = random(TWO_PI);
      center.x += sin(angle) * 2*particleRadius;
      center.y += cos(angle) * 2*particleRadius;
      if(checkPosition(center)) {
        particles.add(new Particle(center, particleRadius));
        break; 
      }
    } 
  }
  
  // Check if a position is available, i.e.
  // - would not overlap with particles that are already created 
  // (for each particle, call checkOverlap())
  // - is inside the board boundaries
  boolean checkPosition(PVector center) {
    // ...
  }

  // Check if a particle with center c1
  // and another particle with center c2 overlap. 
  boolean checkOverlap(PVector c1, PVector c2) {
    // ...
  }

  // Iteratively update and display every particle,
  // and remove them from the list if their lifetime is over. 
  void run() {
    for(int i=0; i < particles.size(); i++) {
      particles.get(i).update();
      particles.get(i).display();
      if (particles.get(i).isDead()) {
        particles.remove(i);
      }
    }
  } 
}
