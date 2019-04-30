import java.util.ArrayList;
import java.util.List;
PImage img;
PImage img2;

HoughClass hough = new HoughClass();

class HoughClass{
  float discretizationStepsPhi = 0.06f; 
  float discretizationStepsR = 2.5f; 
  int minVotes=50; 
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi +1);
  //The max radius is the image diagonal, but it can be also negative
  int rDim = 0;
  int[] accumulator;
  List<PVector> hough(PImage edgeImg){
    rDim = (int) ((sqrt(edgeImg.width*edgeImg.width +
    edgeImg.height*edgeImg.height) * 2) / discretizationStepsR +1);
    // our accumulator
    accumulator = new int[phiDim * rDim];
    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator: r += rDim / 2
          float phi = 0;
          for (float i = 0; i < phiDim; i++) {
              phi += discretizationStepsPhi;
              float r = (x * cos(phi) + y * sin(phi))/discretizationStepsR + rDim / 2;
              accumulator[(int) i * rDim + (int) r] += 1;
            }
          }
      }
    }
    ArrayList<PVector> lines=new ArrayList<PVector>();
    for (int idx = 0; idx < accumulator.length; idx++) {
      if (accumulator[idx] > minVotes) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim));
      int accR = idx - (accPhi) * (rDim);
      float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r,phi));
      }
    }

    return lines;
  }
  
  PImage draw_img(){
    PImage houghImg = createImage(rDim, phiDim, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    // You may want to resize the accumulator to make it easier to see:
    houghImg.resize(400, 400);
    houghImg.updatePixels();
    return houghImg;
  }
}
void settings() {
  size(800, 600);
}
void setup() {  
  img = loadImage("hough_test.bmp");
  List<PVector> hough_list = hough.hough(img);
  img2 = hough.draw_img();  
}

void draw() {  
  image(img2, 0,0);
}
