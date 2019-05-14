import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.Collections;

PImage test_img;
PImage img2;
List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();

class BlobDetection {
  PImage findConnectedComponents(PImage input, boolean onlyBiggest){
    // First pass: label the pixels and store labels' equivalences
    int [] labels= new int [input.width*input.height];
    for(int z=0; z<input.width*input.height; z++) labels[z] = -1;
    int currentLabel=1;
    for(int i = 0; i < input.width*input.height ; i++){
      //assuming that all the three channels have the same value
      if(brightness(input.pixels[i]) == 255 && i == 0){
        labels[i] = currentLabel;
        currentLabel++;
        continue;
      }
      else if(brightness(input.pixels[i]) == 255){
        // first line
        if(i < input.width){
          if(labels[i-1] < currentLabel && labels[i-1]>0){
            labels[i] = labels[i- 1];
          }
          else{
            labels[i] = currentLabel;
            currentLabel++;
          }
        }
        // first column
        else if((i+1)%input.width == 1){
          int minLabel = currentLabel;
          boolean foundLabel = false;
          for(int j=0; j<2; j++){
            if(labels[i-input.width+j] < minLabel && labels[i-input.width+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            for(int j=0; j<2; j++){
              if(labels[i-input.width+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  if(labelsEquivalences.size()<minLabel){
                    Integer size= labelsEquivalences.size();
                    for(int el = 0; el < minLabel-size; el++){
                      labelsEquivalences.add(new TreeSet());
                    }
                  }
                  labelsEquivalences.get(minLabel).add(labels[i-input.width+j]);
                  labelsEquivalences.get(labels[i-input.width+j]-1).add(minLabel);
                }
              }
            }
          }
          else{
            labels[i] = currentLabel;
            currentLabel++;
          }
        }
        // last column
        else if((i+1)%input.width == 0){
          int minLabel = currentLabel;
          boolean foundLabel = false;
          if(labels[i- 1] <= minLabel  && labels[i-1]>0){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<2; j++){
            if(labels[i-input.width-1+j] <= minLabel && labels[i-input.width-1+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width-1+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            if(labels[i- 1] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-1])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  if(labelsEquivalences.size()<labels[i-1]){
                    Integer size= labelsEquivalences.size();
                    for(int el = 0; el < labels[i-1]-size; el++){
                      labelsEquivalences.add(new TreeSet());
                    }
                  }
                  labelsEquivalences.get(minLabel-1).add(labels[i-1]);
                  labelsEquivalences.get(labels[i-1]-1).add(minLabel);
                }
            }
            for(int j=0; j<2; j++){
              if(labels[i-input.width-1+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width-1+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  if(labelsEquivalences.size()<labels[i-input.width-1+j]){
                    Integer size= labelsEquivalences.size();
                    for(int el = 0; el < labels[i-input.width-1+j]-size; el++){
                      labelsEquivalences.add(new TreeSet());
                    }
                  }
                  labelsEquivalences.get(minLabel-1).add(labels[i-input.width-1+j]);
                  labelsEquivalences.get(labels[i-input.width-1+j]-1).add(minLabel);
                }
              }
            }
          }
          else{
            labels[i] = currentLabel;
            currentLabel ++;
          }
        }
        // main pixels
        else{
          int minLabel = currentLabel;
          boolean foundLabel = false;
          if(labels[i- 1] <= minLabel && labels[i-1]>0){
            minLabel = labels[i- 1];
            foundLabel = true;
          }
          for(int j=0; j<3; j++){
            if(labels[i-input.width-1+j] < minLabel && labels[i-input.width-1+j]>0){
              foundLabel = true;
              minLabel = labels[i-input.width-1+j];
            }
          }
          if(foundLabel){
            labels[i] = minLabel;
            
            if(labels[i- 1] > minLabel){
              boolean treeContainsElmts = false;
              for(int el = 0; el < labelsEquivalences.size(); el++){
                if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-1])) treeContainsElmts = true;
              }
              if(!treeContainsElmts){
                if(labelsEquivalences.size()<labels[i-1]){
                    Integer size= labelsEquivalences.size();
                    for(int el = 0; el < labels[i-1]-size; el++){
                      labelsEquivalences.add(new TreeSet());
                    }
                  }
                  labelsEquivalences.get(minLabel-1).add(labels[i-1]);
                  labelsEquivalences.get(labels[i-1]-1).add(minLabel);
              }
            }
            for(int j=0; j<3; j++){
              if(labels[i-input.width-1+j] > minLabel){
                boolean treeContainsElmts = false;
                for(int el = 0; el < labelsEquivalences.size(); el++){
                  if(labelsEquivalences.get(el).contains(minLabel) && labelsEquivalences.get(el).contains(labels[i-input.width-1+j])) treeContainsElmts = true;
                }
                if(!treeContainsElmts){
                  if(labelsEquivalences.size()<labels[i-input.width-1+j]){
                    Integer size= labelsEquivalences.size();
                    for(int el = 0; el < labels[i-input.width-1+j]-size; el++){
                      labelsEquivalences.add(new TreeSet());
                    }
                  }
                  labelsEquivalences.get(minLabel-1).add(labels[i-input.width-1+j]);
                  labelsEquivalences.get(labels[i-input.width-1+j]-1).add(minLabel);
                }
              }
            }
          }
          else{
            labels[i] = currentLabel;
            currentLabel ++;
          }          
        }
      }
      else labels[i] = -1;
    }
    for(int el = 0; el <= currentLabel+1000-labelsEquivalences.size(); el++){
      labelsEquivalences.add(new TreeSet());
    }
    for(int el = 1; el <= labelsEquivalences.size(); el++){
      labelsEquivalences.get(el-1).add(el);
    }
    
    for(int i = 0; i < labelsEquivalences.size(); i++){
      for(int j = 0; j < labelsEquivalences.size(); j++){
        if(!Collections.disjoint(labelsEquivalences.get(i),labelsEquivalences.get(j))){
           if(!labelsEquivalences.get(i).contains(labelsEquivalences.get(j).first())) labelsEquivalences.get(i).add(labelsEquivalences.get(j).first());
           if(!labelsEquivalences.get(j).contains(labelsEquivalences.get(i).first())) labelsEquivalences.get(j).add(labelsEquivalences.get(i).first());
        }
      }
    }
    
    
    // Second pass: re-label the pixels by their equivalent class 
    for(int i=0; i< input.width*input.height; i++){ 
      if(labels[i] != -1) labels[i] = labelsEquivalences.get(labels[i]-1).first();
    }
    
    // if onlyBiggest==true, count the number of pixels for each label
    // then output an image with the biggest blob colored in white and the others in black

    PImage result = createImage(input.width, input.height, RGB);
    
    if(onlyBiggest){
      int blockToKeep = -1;
      List<Integer> sums= new ArrayList<Integer>(Collections.nCopies(currentLabel, 0));
      for(int i=0; i< input.width*input.height; i++){  
        if(labels[i] != -1) sums.set(labels[i],sums.get(labels[i])+1);
      }
      int max=sums.get(0);
      for (Integer x : sums) if (x>max) max=x;
      blockToKeep = sums.indexOf(max);
      for(int i=0; i< input.width*input.height; i++){
        if(labels[i] != blockToKeep) result.pixels[i] = color(0,0,0);
        else result.pixels[i] = color(255,255,255);
      }
      return result;
    }

    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    
    color[] colorEquivalences = new color[currentLabel];
    for(int c=0; c<currentLabel;c++){
      color randomColor = (int)((Math.random() + 10) * 0x1000000);
      colorEquivalences[c] = randomColor;
    }

    for(int i = 0; i < result.width*result.height ; i++){
      //assuming that all the three channels have the same value
      if(labels[i] != -1 ) result.pixels[i] = colorEquivalences[labels[i]];
      else result.pixels[i] = color(0,0,0);
    }
    
    return result;
  }
}
