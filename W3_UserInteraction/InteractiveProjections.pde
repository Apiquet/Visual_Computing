void settings() {
  size(1000, 1000, P2D);
}

void setup () {
}

void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000); 
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //rotated around x
  float[][] transform1 = rotateXMatrix(-PI/8); 
  input3DBox = transformBox(input3DBox, transform1); 
  projectBox(eye, input3DBox).render();
  
  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0); 
  input3DBox = transformBox(input3DBox, transform2); 
  projectBox(eye, input3DBox).render();
  
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2); 
  input3DBox = transformBox(input3DBox, transform3); 
  projectBox(eye, input3DBox).render();
}

class My2DPoint { 
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y; 
  }
}

class My3DPoint { 
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x; 
    this.y = y; 
    this.z = z;
  } 
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float factor = eye.z/(eye.z-p.z);
  My2DPoint a = new My2DPoint((p.x - eye.x)*factor, (p.y - eye.y)*factor);
  return a;
}

class My2DBox { 
  My2DPoint[] s; 
  My2DBox(My2DPoint[] s) {
    this.s = s; 
  }
  
  void render(){
  stroke(255, 0, 0);
  line (this.s[0].x, this.s[0].y, this.s[1].x, this.s[1].y);
  line (this.s[0].x, this.s[0].y, this.s[3].x, this.s[3].y);
  line (this.s[1].x, this.s[1].y, this.s[2].x, this.s[2].y);
  line (this.s[2].x, this.s[2].y, this.s[3].x, this.s[3].y);
  stroke(0, 0, 255);
  line (this.s[0].x, this.s[0].y, this.s[4].x, this.s[4].y);
  line (this.s[1].x, this.s[1].y, this.s[5].x, this.s[5].y);
  line (this.s[2].x, this.s[2].y, this.s[6].x, this.s[6].y);
  line (this.s[3].x, this.s[3].y, this.s[7].x, this.s[7].y);
  stroke(0, 255, 0);
  line (this.s[4].x, this.s[4].y, this.s[5].x, this.s[5].y);
  line (this.s[4].x, this.s[4].y, this.s[7].x, this.s[7].y);
  line (this.s[5].x, this.s[5].y, this.s[6].x, this.s[6].y);
  line (this.s[6].x, this.s[6].y, this.s[7].x, this.s[7].y);
  } 
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{ new My3DPoint(x,y+dimY,z+dimZ),
                              new My3DPoint(x,y,z+dimZ),
                              new My3DPoint(x+dimX,y,z+dimZ),
                              new My3DPoint(x+dimX,y+dimY,z+dimZ), 
                              new My3DPoint(x,y+dimY,z),
                              origin,
                              new My3DPoint(x+dimX,y,z),
                              new My3DPoint(x+dimX,y+dimY,z)
                             };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p; 
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[8];
  for (int i = 0; i < 8; i++) {
    s[i] = projectPoint(eye, box.p[i]);
  }
  My2DBox a = new My2DBox(s);
  return a;
}

float[] homogeneous3DPoint (My3DPoint p) { 
  float[] result = {p.x, p.y, p.z , 1};
  return result; 
}

float[][] rotateXMatrix(float angle) { 
  return(new float[][] { {1 , 0 , 0 , 0},
                         {0 , cos(angle) , -sin(angle) , 0},
                         {0 , sin(angle) , cos(angle) , 0},
                         {0 , 0 , 0 , 1}});
}

float[][] rotateYMatrix(float angle) {
   return(new float[][] { {cos(angle) , 0 , sin(angle) , 0},
                          {0 , 1, 0 , 0},
                          {-sin(angle) , 0 , cos(angle) , 0},
                          {0 , 0 , 0 , 1}});
}

float[][] rotateZMatrix(float angle) {
   return(new float[][] { {cos(angle), -sin(angle), 0 , 0},
                          {sin(angle), cos(angle), 0 , 0},
                          {0 , 0 , 1 , 0},
                          {0 , 0 , 0 , 1}});
}

float[][] scaleMatrix(float x, float y, float z) {
   return(new float[][] { {x , 0 , 0 , 0},
                          {0 , y , 0 , 0},
                          {0 , 0 , z , 0},
                          {0 , 0 , 0 , 1}});
}

float[][] translationMatrix(float x, float y, float z) {
   return(new float[][] { {1 , 0 , 0 , x},
                          {0 , 1 , 0 , y},
                          {0 , 0 , 1 , z},
                          {0 , 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] p = new float[4];
  for(int i = 0; i < 4; i++) {
    for(int j = 0; j < 4; j++) {
      p[i] += a[i][j]*b[j];
    }
  }
  return p;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  float[] h, p;
  My3DBox box2 = box;
  for(int i = 0; i < 8; i++) {
    h = homogeneous3DPoint(box.p[i]);
    p = matrixProduct(transformMatrix, h);
    box2.p[i] = euclidian3DPoint(p);
  }
  return box2;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
return result; 
}
