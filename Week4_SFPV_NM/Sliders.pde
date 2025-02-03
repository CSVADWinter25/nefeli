void sliders() {
  cp5 = new ControlP5(this);
  int sliderWidth = 180;
  int sliderHeight = 20;
  int startX = 25;
  int startY = 25;
  int ySpacing = 25;
  int sectionSpacing = 40;
  int currentY = startY;
  
  // Basic Controls Section
  cp5.addTextlabel("basicLabel")
    .setText("Basic Controls")
    .setPosition(startX, currentY)
    .setColor(color(255));
  currentY += ySpacing;
  
  cp5.addSlider("resolution")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(20, 100)
    .setValue(60);
  currentY += ySpacing;
    
  cp5.addSlider("baseRadius")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(50, 200);
  currentY += ySpacing;
    
  cp5.addSlider("vaseHeight")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(500, height-10);
  currentY += sectionSpacing;
  
  // Opening Controls Section
  cp5.addTextlabel("openingLabel")
    .setText("Opening Controls")
    .setPosition(startX, currentY)
    .setColor(color(255));
  currentY += ySpacing;
  
  cp5.addSlider("topScale")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1);
  currentY += ySpacing;
    
  cp5.addSlider("bottomScale")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1);
  currentY += sectionSpacing;
  
  // Superformula Controls Section
  cp5.addTextlabel("superformulaLabel")
    .setText("Superformula Parameters")
    .setPosition(startX, currentY)
    .setColor(color(255));
  currentY += ySpacing;
  
  cp5.addSlider("y")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-12, 12)
    .setLabel("y (cos term)");
  currentY += ySpacing;
    
  cp5.addSlider("z")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-12, 12)
    .setLabel("z (sin term)");
  currentY += ySpacing;
    
  cp5.addSlider("n1")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-5, 5);
  currentY += ySpacing;
    
  cp5.addSlider("n2")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-5, 5);
  currentY += ySpacing;
    
  cp5.addSlider("n3")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-5, 5);
  currentY += sectionSpacing;
  
  // Shape Variation Controls Section
  cp5.addTextlabel("variationLabel")
    .setText("Shape Variations")
    .setPosition(startX, currentY)
    .setColor(color(255));
  currentY += ySpacing;
  
  cp5.addSlider("heightVariation")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1);
  currentY += ySpacing;
    
  cp5.addSlider("twistAmount")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, TWO_PI);
  currentY += ySpacing;
    
  cp5.addSlider("waveAmount")
    .setPosition(startX, currentY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1);
}
