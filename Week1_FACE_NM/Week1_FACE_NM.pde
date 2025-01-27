void setup() {
  size(400, 400);
}

void draw() {
  background(255, 255, 0);


  stroke(0);
  strokeWeight(6);

  //Eye 01
  line(130, 130, 170, 170);
  line(130, 170, 170, 130);

  //Another Eye
  line(230, 130, 270, 170);
  line(230, 170, 270, 130);


  strokeWeight(3);
  line(130, 300, 270, 300);
}
