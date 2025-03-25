import controlP5.*;
import peasy.*; 

ControlP5 cp5;
PeasyCam cam;
ArrayList<Agent3D> agents;
float[][][] trailMap; 
int gridSize = 100; 
float cellSize;

// Parameters
int numTermites = 100;

float pheromoneDecay = 0.99;
float termiteSpeed = 1.0;
float senseDistance = 10;
float depositRate = 0.03;
float trailStrength = 150;
color trailColor = color(0, 150, 255);
boolean showAgents = true;
boolean showTrails = true;

void setup() {
  size(1920, 1080, P3D);
  background(0);
  colorMode(HSB, 360, 100, 100, 255);


  cam = new PeasyCam(this, 500, 500, 500, 800);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1500);


  cellSize = 1000.0 / gridSize;

  setupGUI();
  initializeSystem();
}

void initializeSystem() {

  trailMap = new float[gridSize][gridSize][gridSize];

  float startX = 500; 
  float startY = 500; 
  float startZ = 500; 

  agents = new ArrayList<Agent3D>();
  for (int i = 0; i < numTermites; i++) {
    agents.add(new Agent3D(startX, startY, startZ));
  }

  while (agents.size() < numTermites) {
    agents.add(new Agent3D(random(1000), random(1000), random(1000)));
  }

  
  while (agents.size() < numTermites) {
    agents.add(new Agent3D(500, 500, 500)); 
  }
}

void draw() {

  background(0);

  // to draw GUI in 2D
  cam.beginHUD();
  drawGUI();
  cam.endHUD();


  ambientLight(50, 0, 20);
  directionalLight(0, 0, 100, 1, 1, -1);

  // Update for number of agents
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
            strokeWeight(map(intensity, 0, 255, 1.0, 3.5));
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
}

void resetSketch() {
  initializeSystem();
}


void trailColor(int c) {
  trailColor = c;
}
