
import processing.video.*;

BlobDetection blobDetect = new BlobDetection();
HoughClass hough = new HoughClass();
QuadGraph quad = new QuadGraph();

HScrollbar thresholdUpBar, thresholdBarminH,thresholdBarmaxH,thresholdBarminS,thresholdBarmaxS,thresholdBarminB,thresholdBarmaxB;
float thresholdUp, minH, maxH, minS, maxS, minB, maxB;

Capture cam;
PImage img, img_accumulator, img_lines, img_edge;
ArrayList<PVector> hough_list, quad_list;

void settings() {
size(640+10, 480/2 + 120);
}

void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else
  {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) 
    {
      println(cameras[i]);
    }
    cam = new Capture(this, 640,480,cameras[0]);
    cam.start();
  }
  
  thresholdBarmaxH = new HScrollbar(0, 480/2+10, 640, 10);
  thresholdBarminH = new HScrollbar(0, 480/2+25, 640, 10);
  thresholdBarmaxS = new HScrollbar(0, 480/2+40, 640, 10);
  thresholdBarminS = new HScrollbar(0, 480/2+55, 640, 10);
  thresholdBarmaxB = new HScrollbar(0, 480/2+70, 640, 10);
  thresholdBarminB = new HScrollbar(0, 480/2+85, 640, 10);
  thresholdUpBar = new HScrollbar(0, 480/2+110, 640, 10);

  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  
  // threshold bars
  thresholdUpBar.display();
  thresholdUpBar.update();
  thresholdUp = thresholdUpBar.getPos()*255;
  
  thresholdBarminH.display();
  thresholdBarminH.update();
  minH = thresholdBarminH.getPos()*255;
  
  thresholdBarmaxH.display();
  thresholdBarmaxH.update();
  maxH = thresholdBarmaxH.getPos()*255;
  
  
  thresholdBarminS.display();
  thresholdBarminS.update();
  minS = thresholdBarminS.getPos()*255;
  
  
  thresholdBarmaxS.display();
  thresholdBarmaxS.update();
  maxS = thresholdBarmaxS.getPos()*255;
  
  
  thresholdBarminB.display();
  thresholdBarminB.update();
  minB = thresholdBarminB.getPos()*255;
  
  
  thresholdBarmaxB.display();
  thresholdBarmaxB.update();
  maxB = thresholdBarmaxB.getPos()*255;

  // verifying cam is available
  if (cam.available() == true) {
    cam.read();
  }
  else println("Cam not available");
  
  //img = loadImage("../W9_BlobDetection/perf_test.PNG");
  
  img = cam.get();

  // Apply Gaussian Blur
  img.loadPixels();
  img.filter(BLUR, 1);
  img.updatePixels();

  // Apply Color Thresholding
  img.loadPixels();
  img = thresholdHSB(img, 39.666668, 132.76192, 0.0, 199.5476, 0.0, 247.71428);
  img.updatePixels();//update pixels
  
  
  //println(minH + ", " +maxH + ", " +minS + ", " +maxS + ", " +minB + ", " +maxB);
  
  img.loadPixels();
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.updatePixels();
  
  
  img.loadPixels();
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(DILATE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.filter(ERODE);
  img.updatePixels();
  
    
  // Apply Blob detection
  img.loadPixels();
  img = blobDetect.findConnectedComponents(img, true);
  img.updatePixels();//update pixels
    
  
  // Apply Edge detection
  img.loadPixels();
  img = scharr(img);
  img.updatePixels();
 
  // Apply Thresholding up
  img.loadPixels();
  img = threshold_up(img, thresholdUp);
  img.updatePixels();//update pixels
    
  image(img, 0,0,img.width/2,img.height/2);


  hough_list = hough.hough(img, 5);
  int max_quad_area = 100000;
  int min_quad_area = 0;
  quad_list = quad.findBestQuad(hough_list, img.width, img.height, max_quad_area, min_quad_area, true);
  for(int i = 0; i < quad_list.size(); ++i){
    pushMatrix();
    stroke(0);
    fill(random(255), random(255), random(255), random(255));
    PVector quad = quad_list.get(i);
    ellipse(quad.x, quad.y, 20, 20);
    popMatrix();
  }
   image(img, img.width/2 + 10,0,img.width/2,img.height/2);
/* 
  */

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

PImage thresholdHSB(PImage img, float minH, float maxH, float minS, float maxS, float minB, float maxB){
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

PImage convolute(PImage img) {

float[][] kernel = { { 9, 12, 9 },
{ 12, 15, 12 },
{ 9, 12, 9 }};
float normFactor = 99.f;

// create a greyscale image (type: ALPHA) for output
PImage result = createImage(img.width, img.height, ALPHA);

int N = kernel[0].length;
int pad = (N-1)/2;
// kernel size N = 3

// for each (x,y) pixel in the image:
// - multiply intensities for pixels in the range
// (x - N/2, y - N/2) to (x + N/2, y + N/2) by the
// corresponding weights in the kernel matrix
// - sum all these intensities and divide it by normFactor
// - set result.pixels[y * img.width + x] to this value

// create a new greyscale image of size img + padding.
PImage img_padded = createImage(img.width+(2*pad), img.height+(2*pad), ALPHA);

// Center the img into img_padded --> get img with a zero padding around borders.
img_padded.set(pad,pad,img);


////Convolution
for(int i=0;i< result.width;i++){
  for(int j=0;j< result.height;j++){
    color c = 0;
    for(int n=-pad;n<=pad;n++){
      for(int m=-pad;m<=pad;m++){
        result.loadPixels();
        c += brightness(img_padded.pixels[(i + pad - n) + (j + pad - m)*img_padded.width])*kernel[n + pad][m + pad];

      }
    }
        c /= normFactor;
        result.pixels[j * result.width + i] =  color(c);
        result.updatePixels();

  }
}

return result;
}

PImage scharr(PImage img) {
float normFactor = 1.f;
float[][] vKernel = {
{ 3, 0, -3 },
{ 10, 0, -10 },
{ 3, 0, -3 } };

float[][] hKernel = {
{ 3, 10, 3 },
{ 0, 0, 0 },
{ -3, -10, -3 } };

int N = hKernel[0].length;
int pad = (N-1)/2;

PImage result = createImage(img.width, img.height, ALPHA);
// clear the image
for (int i = 0; i < img.width * img.height; i++) {
result.pixels[i] = color(0);
}
float max=0;
float[] buffer = new float[img.width * img.height];
// *************************************
// Implement here the double convolution
// *************************************
// create a new greyscale image of size img + padding.
PImage img_padded = createImage(img.width+(2*pad), img.height+(2*pad), ALPHA);

// Center the img into img_padded --> get img with a zero padding around borders.
img_padded.set(pad,pad,img);

for(int i=0;i< result.width;i++){
  for(int j=0;j< result.height;j++){
    color sum_h = 0;
    color sum_v = 0;
    for(int n=-pad;n<=pad;n++){
      for(int m=-pad;m<=pad;m++){
        result.loadPixels();
        sum_h += brightness(img_padded.pixels[(i + pad - n) + (j + pad - m)*img_padded.width])*hKernel[n + pad][m + pad];
        sum_v += brightness(img_padded.pixels[(i + pad - n) + (j + pad - m)*img_padded.width])*vKernel[n + pad][m + pad];

      }
    }
        sum_h /= normFactor;
        sum_v /= normFactor;
        float sum=sqrt(pow(sum_h, 2) + pow(sum_v, 2));
        buffer[i + img.width*j] = sum;
        if(sum > max){
          max = sum;
        }

  }
}

for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
for (int x = 1; x < img.width - 1; x++) { // Skip left and right
int val=(int) ((buffer[y * img.width + x] / max)*255);
result.pixels[y * img.width + x]=color(val);
}
}
return result;
}
