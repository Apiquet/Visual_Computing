PImage nao;
PImage board;
PImage board1Thresholded;
HScrollbar thresholdBar1;
HScrollbar thresholdBar2;
float threshold1 = 0;
float threshold2 = 255;
void settings() {
  size(1200, 300);
}

void setup() {
  nao = loadImage("nao.jpg");
  board = loadImage("board1.jpg");
  board1Thresholded = loadImage("board1Thresholded.bmp");
  
  thresholdBar1 = new HScrollbar(0, board.height/2-45, board.width/2, 20);
  thresholdBar2 = new HScrollbar(0, board.height/2-20, board.width/2, 20);
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  image(board, 0, 0, board.width/2, board.height/2);//show image
  
  // Apply Color Thresholding
  PImage board_threshold = board.copy();//make a deep copy
  board_threshold.loadPixels();
  board_threshold = thresholdHSB(board_threshold, 100, 200, 100, 255, 45, threshold1);
  board_threshold.updatePixels();//update pixels
  image(board_threshold, board.width/2, 0, board.width/2, board.height/2);
  
  // Apply Gaussian Blur
  PImage board_gaussian = board_threshold.copy();
  board_gaussian.loadPixels();
  board_gaussian = convolute(board_gaussian);
  board_gaussian.updatePixels();
  
  // Apply Edge detection
  PImage board_edge = board_gaussian.copy();
  board_edge.loadPixels();
  board_edge = scharr(board_edge);
  board_edge.updatePixels();
 
  // Apply Thresholding up
  PImage board_edge_th = board_edge.copy();//make a deep copy
  board_edge_th.loadPixels();
  board_edge_th = threshold_up(board_edge_th, threshold2);
  board_edge_th.updatePixels();//update pixels
  image(board_edge_th, board.width, 0, board.width/2, board.height/2);
   
   
  //PImage img3 = nao.copy();//make a deep copy
  //img3.loadPixels();
  //img3 = threshold_down(img3, threshold2);
  //img3.updatePixels();//update pixels
  //image(img3, nao.width*2, 20 + board.height);
  


  thresholdBar1.display();
  thresholdBar1.update();
  threshold1 = thresholdBar1.getPos()*255;
  thresholdBar2.display();
  thresholdBar2.update();
  threshold2 = thresholdBar2.getPos()*255;
  
  //print(imagesEqual(board1Thresholded, board_threshold));
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

PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, float maxB){
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
