class Mover {
  
  PVector location;
  PVector velocity;
  PVector gravityForce;
  PVector friction;
  float gravityConstant;
  float normalForce;
  float mu;
  float frictionMagnitude;
  float elasticityFactor;
  
  Mover() {
    gravityForce = new PVector(0, 0,0);
    location = new PVector(0,0,0);
    velocity = new PVector(0,0,0);
    friction = new PVector(0,0,0);
    gravityConstant = 1;
    normalForce = 1;
    mu = 0.05;
    frictionMagnitude = normalForce * mu;
    elasticityFactor = 0.9;
  }
  
  void update(float rotX, float rotZ) {
    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);
    velocity.add(gravityForce);
    location.add(velocity);
  }
  
  void display() {
    //stroke(0);
    //strokeWeight(2);
    fill(127);
    translate(location.x, 0, -location.z);
    sphere(4);
  }
  
  void checkEdges() {
    // Add the current speed to the location.
    if ((location.x > 50)) {
      location.x = 50;
      velocity.x = (velocity.x) * -elasticityFactor;
    }
    if ((location.x < -50)) {
      location.x = -50;
      velocity.x = (velocity.x) * -elasticityFactor;
    }
    if ((location.z > 50)) {
      location.z = 50;
      velocity.z = (velocity.z) * -elasticityFactor;
    }
    if ((location.z < -50)) {
      location.z = -50;
      velocity.z = (velocity.z) * -elasticityFactor;
    }
  }
}
