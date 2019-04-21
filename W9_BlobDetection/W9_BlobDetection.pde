import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

BlobDetection blobDetect = new BlobDetection();
PImage test_img;

class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    // First pass: label the pixels and store labels' equivalences
    int [] labels= new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();
    int currentLabel=1;
    for(int i = 0; i < input.width*input.height ; i++){
      //assuming that all the three channels have the same value
      if(brightness(input.pixels[i]) == 255){
        labels[i] = 1;
      }
      else labels[i] = 0;
    }
    PImage result = createImage(input.width, input.height, RGB);
    for(int i = 0; i < result.width*result.height ; i++){
      //assuming that all the three channels have the same value
      if(labels[i] == 1) result.pixels[i] = color(0,0,0);
      else result.pixels[i] = color(255,255,255);
    }
    // TODO!
    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label
    // TODO!
    // Finally,
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob colored in white and the others in black
    // TODO!
    return result;
  }
}
void settings() {
  size(1000, 600);
}
void setup() {
  test_img = loadImage("BlobDetection_Test.png");
}

void draw() {
  image(test_img, 0, 0);//show image
  PImage img2 = test_img.copy();//make a deep copy
  
  
  img2.loadPixels();
  img2 = blobDetect.findConnectedComponents(test_img, false);
  img2.updatePixels();//update pixels
  image(img2, img2.width + 50, 0);
}
