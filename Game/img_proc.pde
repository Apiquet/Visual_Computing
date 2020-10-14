class ImageProcessing extends PApplet {
  PImage img, img2;
  Capture cam;
  float rx = 0;
  float rz = 0;
  void settings(){
    size(950, 500);
  }
  void setup(){
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
  }
  void draw(){
    
    // verifying cam is available
    if (cam.available() == true) {
      cam.read();
    }
    else println("Cam not available");
    
    img = cam.get();
    img2 = cam.get();
    // Apply Gaussian Blur
    img.loadPixels();
    img.filter(BLUR, 1);
    img.updatePixels();
  
    // Apply Color Thresholding
    img.loadPixels();
    img = thresholdHSB(img, 0.0, 255.0, 0.0, 60.309525, 142.4762, 255.0);
    img.updatePixels();//update pixels
    
    
    //println(minH + ", " +maxH + ", " +minS + ", " +maxS + ", " +minB + ", " +maxB);
    
    img.loadPixels();
    img.filter(ERODE);
    img.filter(ERODE);
    img.filter(ERODE);
    img.filter(ERODE);
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
    
    hough_list = hough.hough(img, 6);
    int max_quad_area = img.width*img.height;
    int min_quad_area = 0;
    quad_list = quad.findBestQuad(hough_list, img.width, img.height, max_quad_area, min_quad_area, false);
    image(img2, 0,0);
    
    for (int idx = 0; idx < hough_list.size(); idx++) {
      PVector line=hough_list.get(idx);
      float r = line.x;
      float phi = line.y;
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = img.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = img.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      // Finally, plot the lines
      stroke(204,102,0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      }
      else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        }
        else
          line(x2, y2, x3, y3);
      }
    }
  
    for(int i = 0; i < quad_list.size(); ++i){
      pushMatrix();
      stroke(0);
      fill(random(255), random(255), random(255), random(255));
      PVector quad = quad_list.get(i);
      ellipse(quad.x, quad.y, 20, 20);
      popMatrix();
    }
    //transfer quad corners to homogeneous coordinates
    homo_quads = to_homo(quad_list);
    angles = two_d.get3DRotations(quad_list);
    degree_angles = angles.mult(180/PI);
    if (degree_angles.x < 0){
      degree_angles.x += 180.0;}
    else if (degree_angles.x > 0){
      degree_angles.x -= 180.0;}
    
    rx = radians(degree_angles.x);
    rz = radians(degree_angles.z);
    if (rz > radians(60)) 
        rz = radians(60);
    else if (rz < radians(-60)) 
      rz = radians(-60);
    if (rx > radians(60)) 
      rx = radians(60);
    else if (rx < radians(-60)) 
      rx = radians(-60);
  }
  //...
}
