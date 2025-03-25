class Agent3D {
  PVector pos;
  PVector vel;
  PVector orientation;
  boolean hasResource;

  Agent3D(float x, float y, float z) {
    pos = new PVector(x, y, z);
    vel = PVector.random3D();
    vel.mult(termiteSpeed);
    orientation = vel.copy().normalize();
    hasResource = false;
  }

  void update() {
    // Create a target orientation based only on trails
    PVector targetOrientation = new PVector();

    // Check surrounding trail levels
    //float centerTrail = senseDirection(new PVector(0, 0, 0));
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
      // Simple random movement instead of noise-based movement
      if (random(1) < 0.05) { // Small chance to change direction randomly
        targetOrientation = PVector.random3D();
      } else {
        // Keep current direction with small random deviation
        targetOrientation = orientation.copy();
        PVector randomDeviation = PVector.random3D();
        randomDeviation.mult(0.2); // Scale down the deviation
        targetOrientation.add(randomDeviation);
        targetOrientation.normalize();
      }
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

    if (hasResource) {
      stroke(hue(trailColor), saturation(trailColor), brightness(trailColor), 200);
      strokeWeight(4); 
    } else {
      stroke(0, 0, 100, 200); 
      strokeWeight(2); 
    }

    point(0, 0, 0);
    popMatrix();
  }
}
