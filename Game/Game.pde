float dx, dy, rx, rz;
float depth = 200;
float speed = 1.0;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  stroke(0);
}

void draw() {
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0); 
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  rotateX(rx);
  rotateZ(rz);
  box(100, 5, 100);
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
  rx = map(-dy*speed, 0, height, 0, PI/3);
  rz = map(dx*speed, 0, width, 0, PI/3);
  if(rz>radians(60)) rz=radians(60);
  else if(rz<radians(-60)) rz=radians(-60);
  if(rx>radians(60)) rx=radians(60);
  else if(rx<radians(-60)) rx=radians(-60);
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
