import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

BlobDetection blobDetect = new BlobDetection();
PImage test_img;

class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    // First pass: label the pixels and store labels' equivalences
    int [] labels= new int [input.width*input.height];
    for(int z=0; z<input.width*input.height; z++) labels[z] = 1000;
    List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();
    int currentLabel=1;
    for(int i = 0; i < input.width*input.height ; i++){
      //assuming that all the three channels have the same value
      if(brightness(input.pixels[i]) == 255 && i == 0){
        labels[i] = 1;
        continue;
      }
      if(brightness(input.pixels[i]) == 255){
        if(i <= input.width){
          if(labels[i- 1] == currentLabel){
            labels[i] = currentLabel;
          }
          else{
            currentLabel ++;
            labels[i] = currentLabel;
          }
        }
        else if(i%input.width == 1){
          int minLabel = currentLabel + 1;
          boolean foundLabel = false;
          for(int j=0; j<2; j++){
            if(labels[i-input.width+j] <= currentLabel){
              foundLabel = true;
              if(labels[i-input.width+j] < minLabel) minLabel = labels[i-input.width+j];
            }
          }
          if(foundLabel) labels[i] = minLabel;
          else{
            currentLabel ++;
            labels[i] = currentLabel;
          }
        }
        else if(i%input.width == 0){
          int minLabel = currentLabel + 1;
          boolean foundLabel = false;
          if(labels[i- 1] <= currentLabel){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<2; j++){
            if(labels[i-input.width-1+j] <= currentLabel){
              foundLabel = true;
              if(labels[i-input.width+j] < minLabel) minLabel = labels[i-input.width+j];
            }
          }
          if(foundLabel) labels[i] = minLabel;
          else{
            currentLabel ++;
            labels[i] = currentLabel;
          }
        }
        else{
          int minLabel = currentLabel + 1;
          boolean foundLabel = false;
          if(labels[i- 1] <= currentLabel){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<3; j++){
            if(labels[i-input.width-1+j] <= currentLabel){
              foundLabel = true;
              if(labels[i-input.width+j] < minLabel) minLabel = labels[i-input.width+j];
            }
          }
          if(foundLabel) labels[i] = minLabel;
          else{
            currentLabel ++;
            labels[i] = currentLabel;
          }          
        }
      }
      else labels[i] = 1000;
    }
    PImage result = createImage(input.width, input.height, RGB);
    color pink = color(255, 102, 204);
    color orange = color(255, 204, 0);
    color red = color(204, 51, 0);
    color blue = color(51, 153, 255);
    color purple = color(153, 51, 255);
    color green_light = color(102, 255, 102);
    color green = color(0, 153, 153);
    for(int i = 0; i < result.width*result.height ; i++){
      //assuming that all the three channels have the same value
      if(labels[i] == 1 ) result.pixels[i] = pink;
      else if(labels[i] == 2 ) result.pixels[i] = orange;
      else if(labels[i] == 3 ) result.pixels[i] = red;
      else if(labels[i] == 4 ) result.pixels[i] = blue;
      else if(labels[i] == 5 ) result.pixels[i] = purple;
      else if(labels[i] == 6 ) result.pixels[i] = green_light;
      else if(labels[i] == 7 ) result.pixels[i] = green;
      else result.pixels[i] = color(0,0,0);
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
