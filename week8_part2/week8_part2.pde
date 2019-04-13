PImage img,img_conv;
void settings() {
size(1600, 600);
}
void setup() {
img = loadImage("board1.jpg");

img_conv = scharr(img);

noLoop(); // no interactive behaviour: draw() will be called only once.
}
void draw() {
image(img, 0, 0);
image(img_conv,800,0);
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
