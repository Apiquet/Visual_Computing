PImage img;
PImage img_accumulator;
PImage img_lines;
ArrayList<PVector> hough_list;
ArrayList<PVector> quad_list;

HoughClass hough = new HoughClass();
QuadGraph quad = new QuadGraph();

void settings() {
  size(700, 500);
}

void setup() {  
  img = loadImage("hough_test.bmp");
  image(img, 0,0,img.width,img.height);
  hough_list = hough.hough(img, 7);
  
  int max_quad_area = 100;
  int min_quad_area = 0;
  quad_list = quad.findBestQuad(hough_list, img.width, img.height, max_quad_area, min_quad_area, true);
  //img_accumulator = hough.draw_img();    
}

void draw() {  
  //image(img_accumulator, img_accumulator.width*1.8,0);
}
