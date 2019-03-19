Mover mover;
float dx, dy, rx, rz;
float depth = 500;
float speed = 1.0;
float box_size = 300;
PFont f;
PShape globe;
float rayon = 10;
boolean shiftIsPressed = false;
float cylinderBaseSize = 20;
float cylinderHeight = 20;
int cylinderResolution = 40;
ArrayList<PVector> clicks = new ArrayList();
boolean was_clicked = false;
PShape openCylinder = new PShape();

void settings()
{
  size(500, 500, P3D);
}

void setup() 
{
  stroke(0);
  mover = new Mover();

  //text parameter
  f = createFont("Arial",32,true); 
  
  //create a shpere shape with ice texture
  PImage earth = loadImage("ice.jpg");
  globe = createShape(SPHERE, rayon); 
  globe.setTexture(earth);
  globe.setStroke(false);
  
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for(int i = 0; i < x.length; i++) {
  angle = (TWO_PI / cylinderResolution) * i;
  x[i] = sin(angle) * cylinderBaseSize;
  y[i] = cos(angle) * cylinderBaseSize;
  }
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) {
  openCylinder.vertex(x[i], y[i] , 0);
  openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();

}

void draw() 
{
  if (shiftIsPressed) {
    camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
    directionalLight(50, 100, 125, 0, -1, 0); 
    ambientLight(102, 102, 102);
    background(225);
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(radians(90));
    rotateZ(0);
    fill(220);
    box(box_size, 5, box_size);
    popMatrix();
    for( int i = 0; i < clicks.size(); i++){
      pushMatrix();
      translate(clicks.get(i).x, clicks.get(i).y, 0);
      shape(openCylinder);
      popMatrix();
    }
    pushMatrix();
    translate(mouseX, mouseY, 0);
    shape(openCylinder);
    popMatrix();
  }else{
    
    camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
    directionalLight(50, 100, 125, 0, -1, 0); 
    ambientLight(102, 102, 102);
    background(225);
    translate(width/2, height/2, 0);
    pushMatrix();
    rotateX(rx);
    rotateZ(rz);
    fill(220);
    box(box_size, 5, box_size);
    mover.update(rx, rz);
    mover.checkEdges(box_size/2);
    mover.display(rayon);
    popMatrix();
    // text parameters
    fill(0);
    textFont(f); 
    textSize(8);
    text("RotationX: "+ String.format("%.2f", degrees(rx)) +"; RotationZ: "+ String.format("%.2f", degrees(rz)) +"; Speed: "+ String.format("%.2f", speed),-110,-100,depth-200);
  }
  
}

void mousePressed() {
  stroke(255);
}

void mouseReleased()
{
  stroke(0);
}

void mouseDragged()
{
  dx += mouseX - pmouseX;
  dy += mouseY - pmouseY;
  rx = map(-dy*speed, 0, height, 0, PI/3);
  rz = map(dx*speed, 0, width, 0, PI/3);
}

void keyPressed()
{
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      if (speed < 2)
      {
        speed += 0.1;
      } 
      else 
      {
        speed = 2;
      }
    }
    else if (keyCode == DOWN)
    {
      if (speed > 0.2)
      {
        speed -= 0.1;
      } 
      else 
      {
        speed = 0.2;
      }
    }
  }
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  if(depth + e < 150)
  {
    depth = 150;
  } 
  else if(depth + e > 400)
  {
    depth = 400;
  } 
  else
  {
    depth += e;
  }
}

void keyReleased(){
  if (key==CODED){
    if (keyCode == SHIFT){
      if(shiftIsPressed) shiftIsPressed = false;
      else shiftIsPressed = true;
    }
  }
}

void mouseClicked() {
  clicks.add( new PVector( mouseX, mouseY, millis() ) );
}
