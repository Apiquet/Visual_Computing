float dx, dy, rx, rz;
float depth = 200;
float speed = 1.0;
Mover mover;


void settings() {
  size(500, 500, P3D);
}

void setup() {
  stroke(0);
  mover = new Mover();
}

void draw() {
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0); 
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  pushMatrix();
  rotateX(rx);
  rotateZ(rz);
  box(100, 5, 100);
  translate(0, -13, 0);
  mover.update(rx,rz);
  mover.checkEdges();
  mover.display();
  popMatrix();
  textSize(8); 
  text("RotationX: "+ String.format("%.2f", degrees(rx)) +"; RotationZ: "+ String.format("%.2f", degrees(rz)) +"; Speed: "+ String.format("%.2f", speed),-110,-100);
}

void mousePressed() {
  stroke(255);
}

void mouseReleased() {
  stroke(0);
}

void mouseDragged() {
  dx += mouseX - pmouseX;
  dy += mouseY - pmouseY;
  rx = map(-dy*speed, 0, height, 0, PI);
  rz = map(dx*speed, 0, width, 0, PI);
  if (rz > radians(60)) 
    rz = radians(60);
  else if (rz < radians(-60)) 
    rz = radians(-60);
  if (rx > radians(60)) 
    rx = radians(60);
  else if (rx < radians(-60)) 
    rx = radians(-60);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (speed < 2){
        speed += 0.1;
      } 
      else {
        speed = 2;
      }
    }
    else if (keyCode == DOWN) {
      if (speed > 0.2){
        speed -= 0.1;
      } 
      else {
        speed = 0.2;
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (depth + e < 150) {
    depth = 150;
  } 
  else if (depth + e > 400) {
    depth = 400;
  } 
  else {
    depth += e;
  }
}
class Mover {
  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 1;
  Mover() {
    gravityForce = new PVector(0, 0,0);
    location = new PVector(0,0,0);
    velocity = new PVector(0,0,0);
  }
  void update(float rotX, float rotZ) {
    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(gravityForce);
    location.add(velocity);
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    //ellipse(location.x, location.y, 48, 48);
    translate(location.x, 0, -location.z);
    sphere(10);

  }
  void checkEdges() {
    // Add the current speed to the location.
    if ((location.x >= 50)) {
      velocity.x = (velocity.x-1) * -1;
      location.x = 49;
    }
    if ((location.x <= -50)) {
      velocity.x = (velocity.x+1) * -1;
      location.x = -49;
    }
    if ((location.z >= 50)) {
      velocity.z = (velocity.z-1) * -1;
      location.z = 49;
    }
    if ((location.z <= -50)) {
      velocity.z = (velocity.z+1) * -1;
      location.z = -49;
    }
  }
}
