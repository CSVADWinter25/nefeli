// Main.pde
import controlP5.*;

ControlP5 cp5;
ArrayList<Agent> agents;
float[][] trailMap;
float noiseZ = 0;

// Parameters
int numTermites = 100;
float noiseScale = 0.02;
float noiseSpeed = 0.001;
float pheromoneDecay = 0.99;
float termiteSpeed = 1.0;
float senseDistance = 10;
float depositRate = 0.01;
float trailStrength = 100;
color trailColor = color(0, 150, 255);
boolean showAgents = true;

// Interactive drawing parameters
boolean isDrawing = false;
float drawingInfluenceRadius = 50;
float drawingStrength = 1.0;

void setup() {
  size(1000, 1000);
  background(0);
  colorMode(HSB, 360, 100, 100, 255);
  
  setupGUI();
  initializeSystem();
}

void initializeSystem() {
  trailMap = new float[width][height];
  
  agents = new ArrayList<Agent>();
  for (int i = 0; i < numTermites; i++) {
    agents.add(new Agent(random(width), random(height)));
  }
}

void draw() {
  // Fade the background
  fill(0, 25);
  rect(0, 0, width, height);
  
  // Update number of agents if changed
  while (agents.size() < numTermites) {
    agents.add(new Agent(random(width), random(height)));
  }
  while (agents.size() > numTermites) {
    agents.remove(agents.size() - 1);
  }
  
  // Update and display trails
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (trailMap[x][y] > 0) {
        trailMap[x][y] *= pheromoneDecay;
        pixels[y * width + x] = color(
          hue(trailColor),
          saturation(trailColor),
          brightness(trailColor),
          trailMap[x][y] * trailStrength
        );
      }
    }
  }
  updatePixels();
  
  if (!isDrawing) {
    // Update and display agents only when not drawing
    for (Agent a : agents) {
      a.update();
      if (showAgents) {
        a.display();
      }
    }
    noiseZ += noiseSpeed;
  } else {
    // When drawing, attract agents to mouse position
    for (Agent a : agents) {
      a.attractToMouse(mouseX, mouseY);
      if (showAgents) {
        a.display();
      }
    }
  }
}

void mousePressed() {
  isDrawing = true;
}

void mouseReleased() {
  isDrawing = false;
}

void resetSketch() {
  background(0);
  initializeSystem();
}

void saveVariation() {
  saveFrame("termite-variation-####.png");
}

void trailColor(int c) {
  trailColor = c;
}
