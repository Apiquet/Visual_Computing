HScrollbar hs;

void settings() {
  size(400, 200, P2D);
}

void setup() {
  hs = new HScrollbar(50, 90, 300, 20);
}

void draw() { 
  background(255); 
  hs.update(); 
  hs.display(); 
  println(hs.getPos());
}
