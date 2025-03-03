// Agent_Class.pde - 3D Version
class Agent3D {
  PVector pos;
  PVector vel;
  PVector orientation; // 3D orientation
  boolean hasResource;
  
  Agent3D(float x, float y, float z) {
    pos = new PVector(x, y, z);
    vel = PVector.random3D(); // Random 3D direction
    vel.mult(termiteSpeed);
    orientation = vel.copy().normalize();
    hasResource = false;
  }
  
  void update() {
    // Get environmental influence from 3D noise
    float noiseVal = noise(
      pos.x * noiseScale, 
      pos.y * noiseScale, 
      pos.z * noiseScale + noiseZ
    );
    
    // Create a target orientation based on noise and trails
    PVector targetOrientation = new PVector();
    
    // Check surrounding trail levels
    float centerTrail = senseDirection(new PVector(0, 0, 0));
    float leftTrail = senseDirection(new PVector(-1, 0, 0));
    float rightTrail = senseDirection(new PVector(1, 0, 0));
    float upTrail = senseDirection(new PVector(0, -1, 0));
    float downTrail = senseDirection(new PVector(0, 1, 0));
    float frontTrail = senseDirection(new PVector(0, 0, 1));
    float backTrail = senseDirection(new PVector(0, 0, -1));
    
    if (hasResource) {
      // If carrying resource, follow trail gradients
      PVector influence = new PVector();
      
      // Add weighted influences from all directions
      if (leftTrail > 0) influence.add(new PVector(-leftTrail, 0, 0));
      if (rightTrail > 0) influence.add(new PVector(rightTrail, 0, 0));
      if (upTrail > 0) influence.add(new PVector(0, -upTrail, 0));
      if (downTrail > 0) influence.add(new PVector(0, downTrail, 0));
      if (frontTrail > 0) influence.add(new PVector(0, 0, frontTrail));
      if (backTrail > 0) influence.add(new PVector(0, 0, -backTrail));
      
      if (influence.mag() > 0) {
        influence.normalize();
        targetOrientation = influence;
      } else {
        // Random movement if no trail gradient
        targetOrientation = PVector.random3D();
      }
    } else {
      // Explore using noise
      float angle1 = noiseVal * TWO_PI;
      float angle2 = noise(pos.x * noiseScale + 1000, pos.y * noiseScale + 1000, pos.z * noiseScale + noiseZ) * PI;
      
      targetOrientation.x = sin(angle1) * cos(angle2);
      targetOrientation.y = sin(angle1) * sin(angle2);
      targetOrientation.z = cos(angle1);
      targetOrientation.normalize();
    }
    
    // Smoothly adjust orientation
    orientation.lerp(targetOrientation, 0.3);
    orientation.normalize();
    
    // Update velocity and position
    vel = orientation.copy().mult(termiteSpeed);
    pos.add(vel);
    
    // Wrap around edges
    pos.x = (pos.x + 1000) % 1000;
    pos.y = (pos.y + 1000) % 1000;
    pos.z = (pos.z + 1000) % 1000;
    
    // Random chance to pick up or deposit resource
    if (random(1) < depositRate) {
      hasResource = !hasResource;
      if (!hasResource) {
        // Deposit trail when dropping resource
        depositTrail();
      }
    }
  }
  
  float senseDirection(PVector offset) {
    // Calculate sensing position in the direction of the offset
    PVector senseDir = orientation.copy().add(offset).normalize();
    PVector sensePos = pos.copy().add(senseDir.mult(senseDistance));
    
    // Convert to grid indices
    int gridX = int(constrain(sensePos.x / cellSize, 0, gridSize-1));
    int gridY = int(constrain(sensePos.y / cellSize, 0, gridSize-1));
    int gridZ = int(constrain(sensePos.z / cellSize, 0, gridSize-1));
    
    return trailMap[gridX][gridY][gridZ];
  }
  
  void depositTrail() {
    // Convert position to grid indices
    int gridX = int(constrain(pos.x / cellSize, 0, gridSize-1));
    int gridY = int(constrain(pos.y / cellSize, 0, gridSize-1));
    int gridZ = int(constrain(pos.z / cellSize, 0, gridSize-1));
    
    trailMap[gridX][gridY][gridZ] = 1.0;
  }
  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    
    // Use points instead of spheres for better performance - with larger size
    if (hasResource) {
      stroke(hue(trailColor), saturation(trailColor), brightness(trailColor), 200);
      strokeWeight(4); // Increased from 2
    } else {
      stroke(0, 0, 100, 200); // White in HSB mode
      strokeWeight(2); // Increased from 1.5
    }
    
    point(0, 0, 0);
    popMatrix();
  }
}
