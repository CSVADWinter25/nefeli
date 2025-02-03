import controlP5.*;

ControlP5 cp5;


int resolution = 60;
float vaseHeight = 500;
float baseRadius = 100;


float topScale = 0.2;    
float bottomScale = 1.0;

// Superformula 
float a = 1;
float b = 1;
float y = 1;
float z = 4;
float n1 = -2;
float n2 = 4;
float n3 = 4;


float heightVariation = 0.7;
float twistAmount = 0.0;
float waveAmount = 0.3;

void setup() {
  size(1024, 1024, P3D);
  sliders();  
}

void draw() {
  background(0);
  lights();

  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.01);

  fill(255);
  noStroke();

  int rowNum = 100;
  float quadHeight = vaseHeight/rowNum;
  Point3D[][] vertices = calculateVertices(rowNum, quadHeight);

  for (int i = 1; i < vertices.length; i++) {
    beginShape(QUAD_STRIP);
    Point3D[] pointListTop = vertices[i-1];
    Point3D[] pointListBottom = vertices[i];

    for (int j = 0; j <= pointListTop.length; j++) {
      int t = j % pointListTop.length;
      Point3D top = pointListTop[t];
      Point3D bottom = pointListBottom[t];

      vertex(top.x, top.y, top.z);
      vertex(bottom.x, bottom.y, bottom.z);
    }
    endShape(CLOSE);
  }

  popMatrix();
}

Point3D[][] calculateVertices(int rowNum, float quadHeight) {
  Point3D[][] vertices = new Point3D[rowNum][resolution];

  for (int i = 0; i < rowNum; i++) {
    float heightRatio = (float)i/(rowNum-1);
    float y_pos = quadHeight * i - vaseHeight/2;
    
    float currentScale = lerp(topScale, bottomScale, heightRatio);

    // wave effect
    float baseWave = sin(heightRatio * TWO_PI * 2) * waveAmount;
    float heightFactor = 1.0 + sin(heightRatio * PI) * heightVariation;
    float twist = twistAmount * heightRatio;

    vertices[i] = calculateSuperformulaPoints(
      baseRadius * heightFactor * currentScale,
      y_pos,
      resolution,
      twist,
      baseWave,
      heightRatio
      );
  }
  return vertices;
}

Point3D[] calculateSuperformulaPoints(float radius, float y_pos, int res, float twist, float baseWave, float heightRatio) {
  Point3D[] pointList = new Point3D[res];

  for (int i = 0; i < res; i++) {
    float theta = TWO_PI * i / res;

    // Get superformula radius with both horizontal and vertical components
    float r_horizontal = superformula(theta);
    float r_vertical = superformula(heightRatio * TWO_PI);
    float combinedRadius = (r_horizontal + r_vertical) * 0.5;

    // wave distortion applied to radius
    float waveR = radius * (1 + baseWave) * combinedRadius;

    // final position w/ wave effect
    float x = cos(theta + twist) * waveR;
    float z = sin(theta + twist) * waveR;
    float yOffset = baseWave * 30 * r_vertical;  

    pointList[i] = new Point3D(x, y_pos + yOffset, z);
  }
  return pointList;
}

float superformula(float theta) {
  
  float t1 = abs(cos(y * theta / 4.0) / a);
  float t2 = abs(sin(z * theta / 4.0) / b);

  // Safety for negative numbs
  float p2 = (n2 >= 0) ? pow(t1, n2) : pow(t1, -n2);
  float p3 = (n3 >= 0) ? pow(t2, n3) : pow(t2, -n3);
  float t3 = p2 + p3;

  // if negative n1
  float r;
  if (n1 != 0) {
    if (n1 > 0) {
      r = pow(t3, -1.0/n1);
    } else {
      r = pow(t3, -1.0/abs(n1));
    }
  } else {
    r = 1;  
  }

  return r;
}
