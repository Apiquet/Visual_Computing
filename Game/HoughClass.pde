class HoughClass{
  float discretizationStepsPhi = 0.06f; 
  float discretizationStepsR = 2.5f; 
  int minVotes = 10; 
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi +1);
  //The max radius is the image diagonal, but it can be also negative
  int rDim = 0;
  int[] accumulator;
  int neighbours = 10;
  ArrayList<PVector> lines = new ArrayList<PVector>();
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
  
  // Pre-computing sin and cos values
  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;
  float inverseR = 1.f / discretizationStepsR;
  
  { 
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
  }

  ArrayList<PVector> hough(PImage edgeImg, int nLines) {
    
    ArrayList<PVector> lines = new ArrayList<PVector>();
    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
    
    rDim = (int) ((sqrt(edgeImg.width*edgeImg.width + edgeImg.height*edgeImg.height) * 2) / discretizationStepsR +1);
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
          for (int i = 0; i < phiDim; i++) {
              int r = Math.round(x * tabCos[i] + y * tabSin[i] + rDim / 2);
              accumulator[i * rDim + r] += 1;
            }
          }
      }
    }
    
    for (int idx = 0; idx < accumulator.length; idx++) {
      if (accumulator[idx] > minVotes) {
        int start  = Math.max(idx - neighbours, 0);
        int end = Math.min(idx + neighbours, accumulator.length);
        boolean flag = true;
        for (int it = start; it < end; ++it) {
          if (accumulator[idx] < accumulator[it]) {
            flag = false;
            break;
          }
        }
        if(flag) {
          bestCandidates.add(idx);
        }
      }
    }
    
    Collections.sort(bestCandidates, new HoughComparator(accumulator));
    if(bestCandidates.size() < nLines){
        return lines;
    }
    for (int n = 0; n < nLines; n++) {
      int idx = bestCandidates.get(n);
      int accPhi = (idx / (rDim));
      int accR = idx - (accPhi) * (rDim);
      float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r,phi));
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


class HoughComparator implements java.util.Comparator<Integer> { 
  int[] accumulator;
  
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator; 
  }
  @Override
  public int compare(Integer l1, Integer l2) { 
    if (accumulator[l1] > accumulator[l2] || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1; 
    return 1;
  } 
}
