class Mover {
PVector location;
PVector velocity;
PVector gravity;
Mover() {
location = new PVector(width/2, height/2);
velocity = new PVector(1, 1);
gravity = new PVector(0,1);
}
void update() {
velocity.add(gravity);
location.add(velocity);
}
float r = 48;
void display() {
stroke(0);
strokeWeight(2);
fill(127);
ellipse(location.x, location.y, r, r);
}
void checkEdges() {
if (location.x > width-r/2) {
  velocity.x = (velocity.x-1) * -1;
  location.x = width-r/2;
} else if(location.x < r/2) {
velocity.x = (velocity.x+1) * -1;
location.x = r/2;
} else if(location.y > height-r/2) {
  velocity.y = (velocity.y-1) * -1;
  location.y = height-r/2;
} else if(location.y < r/2) {
velocity.y = (velocity.y+1) * -1;
location.y = r/2;
}
}
}
