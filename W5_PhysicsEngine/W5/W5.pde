float cylinderBaseSize = 50; 
float cylinderHeight = 50; 
int cylinderResolution = 40;

PShape openCylinder = new PShape();

void settings() {
  size(400, 400, P3D);
}

void setup() {
  
  float angle;
  float[] x = new float[cylinderResolution+1];
  float[] y = new float[cylinderResolution+1];
 
  //get the x and z position on a circle for all the cylinderResolution
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  
  openCylinder = createShape();
  
  //draw the cylinderBaseSize of the cylinder
  openCylinder.beginShape(TRIANGLE_FAN);
    openCylinder.vertex(0, 0, 0);
    for(int i=0; i < x.length; i++){
      openCylinder.vertex(x[i], y[i], 0);
    }
  openCylinder.endShape();
 
  //draw the center of the cylinder
  openCylinder.beginShape(QUAD_STRIP); 
    for(int i=0; i < x.length; i++){
      openCylinder.vertex(x[i], y[i], 0);
      openCylinder.vertex(x[i], y[i], cylinderHeight);
    }
  openCylinder.endShape();
 
  //draw the cylinderBaseSize of the cylinder
  openCylinder.beginShape(TRIANGLE_FAN); 
    openCylinder.vertex(0, 0, 0);
    for(int i=0; i < x.length; i++){
      openCylinder.vertex(x[i], y[i], cylinderHeight);
    }
  openCylinder.endShape();
  
  PImage earth = loadImage("tree.jpg");
  openCylinder.setTexture(earth);
  openCylinder.setStroke(true);
}

void draw() { 
  background(255);
  translate(mouseX, mouseY, 0);
  shape(openCylinder);
}
