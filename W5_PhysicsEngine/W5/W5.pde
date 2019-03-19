void settings() {
      size(400, 400, P3D);
    }
void setup() { }
void draw() {
background(0); translate(mouseX, mouseY); beginShape(TRIANGLES);
        vertex(0, 0);
        vertex(50, 0);
        vertex(50, 50);
      endShape();
    }
