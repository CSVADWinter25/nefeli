// GUI.pde
void setupGUI() {
  cp5 = new ControlP5(this);
  
  // Create a group for controls
  Group g1 = cp5.addGroup("parameters")
                .setBackgroundColor(color(0, 127))
                .setBackgroundHeight(300);

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

  // Pattern Parameters     
  cp5.addSlider("noiseScale")
     .setPosition(10, 70)
     .setSize(180, 15)
     .setRange(0.001, 0.1)
     .setValue(0.02)
     .setLabel("Pattern Scale")
     .setGroup(g1);
     
  cp5.addSlider("noiseSpeed")
     .setPosition(10, 90)
     .setSize(180, 15)
     .setRange(0, 0.01)
     .setValue(0.001)
     .setLabel("Pattern Evolution Speed")
     .setGroup(g1);

  // Trail Parameters     
  cp5.addSlider("pheromoneDecay")
     .setPosition(10, 120)
     .setSize(180, 15)
     .setRange(0.9, 0.999)
     .setValue(0.99)
     .setLabel("Trail Persistence")
     .setGroup(g1);
     
  cp5.addSlider("trailStrength")
     .setPosition(10, 140)
     .setSize(180, 15)
     .setRange(20, 255)
     .setValue(100)
     .setLabel("Trail Intensity")
     .setGroup(g1);
     
  cp5.addSlider("senseDistance")
     .setPosition(10, 160)
     .setSize(180, 15)
     .setRange(5, 50)
     .setValue(10)
     .setLabel("Interaction Range")
     .setGroup(g1);
     
  cp5.addSlider("depositRate")
     .setPosition(10, 180)
     .setSize(180, 15)
     .setRange(0.001, 0.1)
     .setValue(0.01)
     .setLabel("Trail Frequency")
     .setGroup(g1);

  // Visual Parameters
  cp5.addColorWheel("trailColor", 10, 210, 100)
     .setLabel("Trail Color")
     .setGroup(g1);
     
  cp5.addToggle("showAgents")
     .setPosition(120, 210)
     .setSize(50, 20)
     .setValue(true)
     .setLabel("Show Agents")
     .setGroup(g1);

  // Control buttons     
  cp5.addButton("resetSketch")
     .setPosition(10, 340)
     .setSize(90, 20)
     .setLabel("Reset")
     .setGroup(g1);
     
  cp5.addButton("saveVariation")
     .setPosition(110, 340)
     .setSize(90, 20)
     .setLabel("Save")
     .setGroup(g1);
}
