PImage img;
HScrollbar thresholdBar;
void settings() {
size(1600, 1600);
}
void setup() {
img = loadImage("board1.jpg");
thresholdBar = new HScrollbar(0, 580, 800, 20);
noLoop(); // no interactive behaviour: draw() will be called only once.
}
void draw() {
image(img, 0, 0);//show image
PImage img2 = img.copy();//make a deep copy
img2.loadPixels();
img2 = threshold_up(img2, 128);
img2.updatePixels();//update pixels
image(img2, img.width, 0);

PImage img3 = img.copy();//make a deep copy
img3.loadPixels();
img3 = threshold_down(img3, 128);
img3.updatePixels();//update pixels
image(img3, 0, img.height);
}

PImage threshold_up(PImage img, int threshold){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])>threshold) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = 0;
  }
  return result;
}
PImage threshold_down(PImage img, int threshold){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])<threshold) result.pixels[i] = img.pixels[i];
    else result.pixels[i] = 0;
  }
  return result;
}
