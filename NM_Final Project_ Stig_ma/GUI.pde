void setupGUI() {
  cp5 = new ControlP5(this);

  Group g1 = cp5.addGroup("parameters")
    .setBackgroundColor(color(0, 127))
    .setBackgroundHeight(380)
    .setPosition(10, 20);

  // Movement Parameters
  cp5.addSlider("numTermites")
    .setPosition(10, 20)
    .setSize(180, 15)
    .setRange(10, 500)
    .setValue(100)
    .setLabel("Number of Agents")
    .setGroup(g1);

  cp5.addSlider("termiteSpeed")
    .setPosition(10, 40)
    .setSize(180, 15)
    .setRange(0.1, 8.0)
    .setValue(1.0)
    .setLabel("Agent Speed")
    .setGroup(g1);

  cp5.addSlider("pheromoneDecay")
    .setPosition(10, 70)
    .setSize(180, 15)
    .setRange(0.9, 0.999)
    .setValue(0.99)
    .setLabel("Trail Persistence")
    .setGroup(g1);

  cp5.addSlider("trailStrength")
    .setPosition(10, 90)
    .setSize(180, 15)
    .setRange(20, 255)
    .setValue(150)
    .setLabel("Trail Intensity")
    .setGroup(g1);

  cp5.addSlider("senseDistance")
    .setPosition(10, 110)
    .setSize(180, 15)
    .setRange(5, 50)
    .setValue(10)
    .setLabel("Interaction Range")
    .setGroup(g1);

  cp5.addSlider("depositRate")
    .setPosition(10, 130)
    .setSize(180, 15)
    .setRange(0.001, 0.1)
    .setValue(0.03)
    .setLabel("Trail Frequency")
    .setGroup(g1);

  // Visual Parameters
  cp5.addColorWheel("trailColor", 10, 160, 100)
    .setLabel("Trail Color")
    .setGroup(g1);

  cp5.addToggle("showAgents")
    .setPosition(120, 160)
    .setSize(50, 20)
    .setValue(true)
    .setLabel("Show Agents")
    .setGroup(g1);

  // 3D-specific control
  cp5.addToggle("showTrails")
    .setPosition(120, 200)
    .setSize(50, 20)
    .setValue(true)
    .setLabel("Show Trails")
    .setGroup(g1);

  // Grid size control
  cp5.addSlider("gridSize")
    .setPosition(10, 280)
    .setSize(180, 15)
    .setRange(50, 200)
    .setValue(100)
    .setLabel("Grid Resolution")
    .setGroup(g1)
    .onChange(event -> {

    cellSize = 1000.0 / gridSize;
    resetSketch();
  }
  );

  // Control buttons
  cp5.addButton("resetSketch")
    .setPosition(10, 300)
    .setSize(180, 20)
    .setLabel("Reset Simulation")
    .setGroup(g1);

  // Export buttons
  cp5.addButton("saveVariation")
    .setPosition(10, 325)
    .setSize(180, 20)
    .setLabel("Save Screenshot (PNG)")
    .setGroup(g1);

  cp5.addButton("exportPoints")
    .setPosition(10, 350)
    .setSize(90, 20)
    .setLabel("Export CSV")
    .setGroup(g1);

  cp5.addButton("exportOBJ")
    .setPosition(105, 350)
    .setSize(85, 20)
    .setLabel("Export OBJ")
    .setGroup(g1);


  cp5.setAutoDraw(false);
}

// This must be called from draw() when the camera's HUD mode is active
void drawGUI() {
  hint(DISABLE_DEPTH_TEST); // Ensure GUI renders properly in 2D
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}
