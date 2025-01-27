void setup() {
  size(1600, 800);          //2:1 ratio
  textAlign(CENTER, CENTER);
  textSize(25);
}

void draw() {
  background(0);         

  // Number of rows & columns
  int rows = 15;
  int cols = 25;
  
  // Calculate cell sizes
  float cellW = width / (float)cols;
  float cellH = height / (float)rows;

  // Morse code for "Hello World!"
  String morseOnly = 
    ".... . .-.. .-.. ---\n" +
    ".-- --- .-. .-.. -.. -.-.--";

  // Grid
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      // Compute cell's center
      float centerX = x * cellW + cellW / 2;
      float centerY = y * cellH + cellH / 2;

      pushMatrix();
      translate(centerX, centerY);
      // Rotate for better results
      if (x % 2 == 1) {
        rotate(PI*2);
      }
      fill(255);
      noStroke();
      text(morseOnly, 0, 0);
      popMatrix();
    }
  }
}
