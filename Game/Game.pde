Mover mover;
ParticleSystem ParticleSystem;
float dx, dy, rx, rz;
float depth = 500;
float speed = 1.0;
float box_size = 300;
PFont f;
PShape globe;
float rayon = 10;
boolean shiftIsPressed = false;
boolean user_won = false;
float cylinderBaseSize = 10;
float cylinderHeight = 20;
int cylinderResolution = 40;
ArrayList<PVector> clicks_shiftEnabled = new ArrayList();
ArrayList<PVector> clicks_shiftDisabled = new ArrayList();
boolean was_clicked = false;
PShape openCylinder = new PShape();
PVector particle_origin;
boolean particle_ON = false;
PShape robotnik;
String text_displayed = " ";
void settings()
{
  size(500, 500, P3D);
  //particle_origin = new PVector(0,0,0);
}

void setup() 
{
  
  stroke(0);
  mover = new Mover();
  robotnik = loadShape("robotnik.obj");


  //text parameter
  f = createFont("Arial",32,true); 
  
  //create a shpere shape with ice texture
  PImage earth = loadImage("ice.jpg");
  globe = createShape(SPHERE, rayon); 
  globe.setTexture(earth);
  globe.setStroke(false);
  
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
  
  PImage tree = loadImage("tree.jpg");
  openCylinder.setTexture(tree);
  openCylinder.setStroke(true);
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
    for( int i = 0; i < clicks_shiftEnabled.size(); i++){
      pushMatrix();
      translate(clicks_shiftEnabled.get(i).x, clicks_shiftEnabled.get(i).y, 0);
      shape(openCylinder);
      popMatrix();
    }
    pushMatrix();
    translate(mouseX, mouseY, 0);
    shape(openCylinder);
    popMatrix();
    // text parameters
    fill(0, 204, 102);
    textFont(f); 
    textSize(30);
    if(user_won) text_displayed = "You hit Robotnik! You won!";
    else text_displayed = " ";
    text(text_displayed, 70, 10, 0);
  }else{
    camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
    directionalLight(50, 100, 125, 0, -1, 0); 
    ambientLight(102, 102, 102);
    background(225);
    translate(width/2, height/2, 0);
    pushMatrix();
    rotateX(rx);
    rotateZ(rz);
    for( int i = 0; i < clicks_shiftDisabled.size(); i++){
      pushMatrix();
      translate(clicks_shiftDisabled.get(i).x, 0, clicks_shiftDisabled.get(i).z);
      rotateX(radians(90));
      shape(openCylinder);
      popMatrix();
    }
    if(clicks_shiftDisabled.size()>0){
      pushMatrix();
      float ang = atan2(mover.location.x-clicks_shiftDisabled.get(0).x, mover.location.z-clicks_shiftDisabled.get(0).z);
      translate(clicks_shiftDisabled.get(0).x, 0, clicks_shiftDisabled.get(0).z);
      rotateX(radians(180));
      //print(ang);
      rotateY(ang);
      shape(robotnik, 0,0, 80, 80);
      popMatrix();
    }
    if(particle_ON){
      if(frameCount % 20 == 0){
        ParticleSystem.addParticle();
      }
      ParticleSystem.run();
    }
    fill(220);
    box(box_size, 5, box_size);
    mover.update(rx, rz);
    mover.checkEdges(box_size/2);
    mover.ckeckCylinderCollision(clicks_shiftDisabled, rayon, cylinderBaseSize);
    mover.display(rayon);
    popMatrix();
    // text parameters
    fill(0);
    textFont(f); 
    textSize(8);
    text_displayed = "RotationX: "+ String.format("%.2f", degrees(rx)) +"; RotationZ: "+ String.format("%.2f", degrees(rz)) +"; Speed: "+ String.format("%.2f", speed);
    text(text_displayed,-110,-100,depth-200);
  }
  
}

void mousePressed() {
  stroke(255);
}

void mouseReleased()
{
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
      if(shiftIsPressed){
        shiftIsPressed = false;
        user_won = false;
      }
      else shiftIsPressed = true;
    }
  }
}

void mouseClicked() {
  if(shiftIsPressed && mouseX < box_size + (width-box_size)/2 && mouseY < box_size + (height-box_size)/2 && mouseX > (width-box_size)/2 && mouseY > (height-box_size)/2) { 
      clicks_shiftDisabled.clear();
      clicks_shiftEnabled.clear();
      if(clicks_shiftDisabled.size()==0){
        clicks_shiftEnabled.add( new PVector( mouseX, mouseY, 0 ) );
        clicks_shiftDisabled.add( new PVector( mouseX - box_size + 5*cylinderBaseSize, 0, mouseY - box_size + 5*cylinderBaseSize) );
        particle_origin = new PVector( mouseX - box_size + 5*cylinderBaseSize, 0, mouseY - box_size + 5*cylinderBaseSize );
        ParticleSystem = new ParticleSystem(particle_origin);
        particle_ON = true;
      }
  }
}
