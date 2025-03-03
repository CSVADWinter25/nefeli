// Main.pde - 3D Version
import controlP5.*;
import peasy.*; // Add PeasyCam for 3D navigation

ControlP5 cp5;
PeasyCam cam;
ArrayList<Agent3D> agents;
float[][][] trailMap; // Now a 3D array
float noiseZ = 0;
int gridSize = 100; // Define the 3D grid resolution (smaller than window for performance)
float cellSize;

// Parameters
int numTermites = 100;
float noiseScale = 0.02;
float noiseSpeed = 0.001;
float pheromoneDecay = 0.99;
float termiteSpeed = 1.0;
float senseDistance = 10;
float depositRate = 0.03;  // Increased from 0.01 for more frequent trail deposits
float trailStrength = 150;
color trailColor = color(0, 150, 255);
boolean showAgents = true;
boolean showTrails = true;

void setup() {
  size(1000, 1000, P3D);
  background(0);
  colorMode(HSB, 360, 100, 100, 255);
  
  // Setup 3D camera
  cam = new PeasyCam(this, 500, 500, 500, 800);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1500);
  
  // Calculate cell size for the 3D grid
  cellSize = 1000.0 / gridSize;
  
  setupGUI();
  initializeSystem();
}

void initializeSystem() {
  // Initialize 3D trail map
  trailMap = new float[gridSize][gridSize][gridSize];
  
  // Create agents
  agents = new ArrayList<Agent3D>();
  for (int i = 0; i < numTermites; i++) {
    agents.add(new Agent3D(
      random(1000),
      random(1000),
      random(1000)
    ));
  }
}

void draw() {
  // Clear the background
  background(0);
  
  // Disable the camera temporarily to draw GUI in 2D
  cam.beginHUD();
  drawGUI();
  cam.endHUD();
  
  // Lighting for 3D
  ambientLight(50, 0, 20);
  directionalLight(0, 0, 100, 1, 1, -1);
  
  // Update number of agents if changed
  while (agents.size() < numTermites) {
    agents.add(new Agent3D(random(1000), random(1000), random(1000)));
  }
  while (agents.size() > numTermites) {
    agents.remove(agents.size() - 1);
  }
  
  // Update trail map (decay)
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      for (int z = 0; z < gridSize; z++) {
        if (trailMap[x][y][z] > 0.01) { // Only process cells with significant trails
          trailMap[x][y][z] *= pheromoneDecay;
        }
      }
    }
  }
  
  // Display trails
  if (showTrails) {
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        for (int z = 0; z < gridSize; z++) {
          if (trailMap[x][y][z] > 0.01) { // Lower threshold to show more trails
            float intensity = trailMap[x][y][z] * trailStrength;
            strokeWeight(map(intensity, 0, 255, 1.0, 3.5)); // Increased stroke weight range
            stroke(
              hue(trailColor),
              saturation(trailColor),
              brightness(trailColor),
              intensity
            );
            point(
              x * cellSize,
              y * cellSize,
              z * cellSize
            );
          }
        }
      }
    }
  }
  
  // Update and display agents
  for (Agent3D a : agents) {
    a.update();
    if (showAgents) {
      a.display();
    }
  }
  
  noiseZ += noiseSpeed;
}

void resetSketch() {
  initializeSystem();
}

void saveVariation() {
  saveFrame("termite3d-variation-####.png");
}

// Event handler for color wheel
void trailColor(int c) {
  trailColor = c;
}
