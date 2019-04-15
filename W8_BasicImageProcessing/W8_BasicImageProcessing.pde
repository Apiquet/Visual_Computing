PImage img;
HScrollbar thresholdBar1;
HScrollbar thresholdBar2;
float threshold1 = 0;
float threshold2 = 255;
void settings() {
  size(1800, 820);
}

void setup() {
  img = loadImage("board1.jpg");
  thresholdBar1 = new HScrollbar(600, 0, 600, 20);
  thresholdBar2 = new HScrollbar(1200, 0, 600, 20);
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  image(img, 0, 20);//show image
  PImage img2 = img.copy();//make a deep copy
  
  img2.loadPixels();
  img2 = threshold_up(img2, threshold1);
  img2.updatePixels();//update pixels
  image(img2, img.width, 20);
  
  PImage img3 = img.copy();//make a deep copy
  img3.loadPixels();
  img3 = thresholdHSB(img3, 100, 200, 100, 255, 45, 100);
  img3.updatePixels();//update pixels
  image(img3, img.width, 20);
  
  thresholdBar1.display();
  thresholdBar1.update();
  threshold1 = thresholdBar1.getPos()*255;
  thresholdBar2.display();
  thresholdBar2.update();
  threshold2 = thresholdBar2.getPos()*255;
}

PImage threshold_up(PImage img, float threshold){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])>threshold) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = 0;
  }
  return result;
}

PImage threshold_down(PImage img, float threshold){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])<threshold) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = 0;
  }
  return result;
}

PImage thresholdHSB1(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])>minB) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
    if(brightness(img.pixels[i])<maxB) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
    if(saturation(img.pixels[i])>minS) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
    if(saturation(img.pixels[i])<maxS) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
    if(hue(img.pixels[i])>minH) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
    if(hue(img.pixels[i])<maxH) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = color(0,0,0);
  }
  return result;
}
PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])>minB | brightness(img.pixels[i])<maxB | hue(img.pixels[i])>minH | hue(img.pixels[i])<maxH | saturation(img.pixels[i])>minS | saturation(img.pixels[i])<maxS){
      result.pixels[i] = color(255,255,255);
    }
    else{
      result.pixels[i] = color(0,0,0);
      println("hey");
    }
  }
  return result;
}
