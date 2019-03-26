ParticleSystem ParticleSystem;
PVector origin;

void settings() {
  size(500, 500, P3D);
  origin = new PVector(width/2,height/2,0);
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
