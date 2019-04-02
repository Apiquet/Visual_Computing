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

void settings(){
  size(500, 500, P3D);
}

void setup(){
  
  stroke(0);
  mover = new Mover();
  robotnik = loadShape("robotnik.obj");

  f = createFont("Arial",32,true); 
  
  //create a shpere shape with ice texture
  PImage earth = loadImage("ice.jpg");
  globe = createShape(SPHERE, rayon); 
  globe.setTexture(earth);
  globe.setStroke(false);
  
  creating_cylinder();
}

void draw(){
  
  if (shiftIsPressed) {
    updating_scene_shiftON();
  }else{
    updating_scene_shiftOFF();
  } 
}

void updating_scene_shiftON(){
  
    setting_scene_and_background();
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(radians(90));
    rotateZ(0);
    fill(200,100,0,50);
    box(box_size, 5, box_size);
    popMatrix();
    if(clicks_shiftEnabled.size()>0) displaying_cylinder_shiftON();
    pushMatrix();
    translate(mouseX, mouseY, 0);
    shape(openCylinder);
    popMatrix();
    displaying_text();  
}

void updating_scene_shiftOFF(){
  
    setting_scene_and_background();
    translate(width/2, height/2, 0);
    pushMatrix();
    rotateX(rx);
    rotateZ(rz);
    if(clicks_shiftDisabled.size()>0) displaying_robotnik();
    if(particle_ON){
      if(frameCount % 20 == 0){
        ParticleSystem.addParticle();
      }
      ParticleSystem.run();
    }
    creating_plate();
    mover.update(rx, rz);
    mover.checkEdges(box_size/2);
    mover.ckeckCylinderCollision(clicks_shiftDisabled, rayon, cylinderBaseSize);
    mover.display(rayon);
    popMatrix();
    displaying_text(); 
}
void displaying_robotnik(){
  
  pushMatrix();
  translate(clicks_shiftDisabled.get(0).x, 0, clicks_shiftDisabled.get(0).z);
  rotateX(radians(90));
  shape(openCylinder);
  popMatrix();
  pushMatrix();
  float ang = atan2(mover.location.x-clicks_shiftDisabled.get(0).x, mover.location.z-clicks_shiftDisabled.get(0).z);
  translate(clicks_shiftDisabled.get(0).x, 0, clicks_shiftDisabled.get(0).z);
  rotateX(radians(180));
  rotateY(ang);
  shape(robotnik, 0,0, 80, 80);
  popMatrix();
}

void displaying_cylinder_shiftON(){
  
  pushMatrix();
  translate(clicks_shiftEnabled.get(0).x, clicks_shiftEnabled.get(0).y, 0);
  shape(openCylinder);
  popMatrix();  
}

void creating_plate(){
  
  fill(200,100,0,50); // semi-transparent
  box(box_size, 5, box_size);
  hint(DISABLE_DEPTH_TEST);
  noFill();
  stroke(10);
  box(box_size, 5, box_size);
}

void setting_scene_and_background(){
  
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0); 
  ambientLight(102, 102, 102);
  background(225);
}

void displaying_text(){
  
  fill(0);
  textFont(f);
  if(shiftIsPressed){
    if(user_won){
      textSize(30);
      fill(0, 204, 102);
      text("You hit Robotnik! You won!", 70, 50, 0);
      fill(0);
    }
    textSize(19);
    text_displayed = "RotationX: 90; RotationZ: 0; Speed: "+ String.format("%.2f", speed);
    text(text_displayed,-28,0,0);
    textSize(20);
    text("SHIFT_ON", 430, 430, 0);
  }else{ 
    textSize(8);
    text_displayed = "RotationX: "+ String.format("%.2f", degrees(rx)) +"; RotationZ: "+ String.format("%.2f", degrees(rz)) +"; Speed: "+ String.format("%.2f", speed);
    text(text_displayed,-110,-100,depth-200); 
  } 
}

void mousePressed(){
  stroke(255);
}

void mouseReleased(){
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

void keyPressed(){
  
  float delta = 10;
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      depth+=delta;
    }
    else if (keyCode == DOWN)
    {
      depth-=delta;
    }
  }
}

void mouseWheel(MouseEvent event){
  
  speed += float(event.getCount())*0.1;
  if(speed<0.1) speed = 0.1;
  else if(speed > 3) speed = 3;
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

void mouseClicked(){
  
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

void creating_cylinder(){
  
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
