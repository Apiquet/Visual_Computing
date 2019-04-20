PImage nao;
PImage board;
PImage board1Thresholded;
HScrollbar thresholdBar1;
HScrollbar thresholdBar2;
float threshold1 = 0;
float threshold2 = 255;
void settings() {
  size(1800, 1400);
}

void setup() {
  nao = loadImage("nao.jpg");
  board = loadImage("board1.jpg");
  board1Thresholded = loadImage("board1Thresholded.bmp");
  
  thresholdBar1 = new HScrollbar(600, board.height, 600, 20);
  thresholdBar2 = new HScrollbar(1200, board.height, 600, 20);
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  image(nao, 0, 20 + board.height);//show image
  PImage img2 = nao.copy();//make a deep copy
  
  img2.loadPixels();
  img2 = threshold_up(img2, threshold1);
  img2.updatePixels();//update pixels
  image(img2, nao.width, 20 + board.height);
  
  PImage img3 = nao.copy();//make a deep copy
  img3.loadPixels();
  img3 = threshold_down(img3, threshold2);
  img3.updatePixels();//update pixels
  image(img3, nao.width*2, 20 + board.height);
  
  PImage board_threshold = board.copy();//make a deep copy
  board_threshold.loadPixels();
  board_threshold = thresholdHSB(board_threshold, 100, 200, 100, 255, 45, 100);
  board_threshold.updatePixels();//update pixels
  image(board_threshold, 0, 0);

  thresholdBar1.display();
  thresholdBar1.update();
  threshold1 = thresholdBar1.getPos()*255;
  thresholdBar2.display();
  thresholdBar2.update();
  threshold2 = thresholdBar2.getPos()*255;
  
  print(imagesEqual(board1Thresholded, board_threshold));
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

PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB){
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])>=minB & brightness(img.pixels[i])<=maxB & hue(img.pixels[i])>=minH & hue(img.pixels[i])<=maxH & saturation(img.pixels[i])>=minS & saturation(img.pixels[i])<=maxS){
      result.pixels[i] = color(255,255,255);
    }
    else{
      result.pixels[i] = color(0,0,0);
    }
  }
  return result;
}
boolean imagesEqual(PImage img1, PImage img2){
  if(img1.width != img2.width || img1.height != img2.height) return false;
  for(int i = 0; i < img1.width*img1.height ; i++)
    //assuming that all the three channels have the same value
    if(red(img1.pixels[i]) != red(img2.pixels[i])) return false;
    return true;
}
