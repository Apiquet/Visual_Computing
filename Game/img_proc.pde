class ImageProcessing extends PApplet {
  PImage img, img2;
  Movie cam;
  float rx = 0;
  float rz = 0;
  void settings(){
  size(1000, 500, P3D);
}
  void setup(){
    cam = new Movie(this, "C:/Users/antho/Documents/GitHub/Visual_Computing/Game/testvideo.avi"); //You might have to put the absolute path. No worries we will change it when grading your project.
    cam.loop();
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
    img = thresholdHSB(img, 39.666668, 139.2381, 28.738096, 255.0, 58.690475, 161.5);
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
    quad_list = quad.findBestQuad(hough_list, img.width, img.height, max_quad_area, min_quad_area, true);
    //print(quad_list);
    //print(hough_list.size());
    image(img2, 0,0);
  
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
     //print(degree_angles);
    //image(img, img.width/2, 0, img.width/2,img.height/2);
    
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
