ParticleSystem ParticleSystem;
PVector origin;

void settings() {
  size(1000, 1000, P2D);
  origin = new PVector(0,0,0);
}

void setup () {
    ParticleSystem = new ParticleSystem(origin);
}

void draw() {
  if (frameCount % 10 == 0){
    ParticleSystem.addParticle();
    ParticleSystem.run();
  }
}
