// Agent.pde
class Agent {
  PVector pos;
  PVector vel;
  float angle;
  boolean hasResource;
  
  Agent(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    angle = random(TWO_PI);
    hasResource = false;
  }
  
  void update() {
    // Get environmental influence from noise
    float noiseVal = noise(pos.x * noiseScale, pos.y * noiseScale, noiseZ);
    
    // Adjust movement based on noise and trails
    float targetAngle = angle;
    
    // Check surrounding trail levels
    float leftTrail = senseDirection(radians(-45));
    float rightTrail = senseDirection(radians(45));
    float centerTrail = senseDirection(0);
    
    // Adjust direction based on trails and noise
    if (hasResource) {
      if (centerTrail > leftTrail && centerTrail > rightTrail) {
        targetAngle = angle;
      } else if (leftTrail > rightTrail) {
        targetAngle = angle - radians(45);
      } else {
        targetAngle = angle + radians(45);
      }
    } else {
      targetAngle = noiseVal * TWO_PI;
    }
    
    // Smooth rotation
    angle = lerp(angle, targetAngle, 0.3);
    
    // Update velocity and position
    vel.x = cos(angle) * termiteSpeed;
    vel.y = sin(angle) * termiteSpeed;
    pos.add(vel);
    
    // Wrap around edges
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
    
    // Random chance to deposit trail
    if (random(1) < depositRate) {
      depositTrail();
    }
  }
  
  void attractToMouse(float mx, float my) {
    // Calculate direction to mouse
    PVector mousePos = new PVector(mx, my);
    PVector direction = PVector.sub(mousePos, pos);
    float distance = direction.mag();
    
    // Only affect agents within influence radius
    if (distance < drawingInfluenceRadius) {
      direction.normalize();
      
      // Set new angle based on mouse direction
      angle = atan2(direction.y, direction.x);
      
      // Move towards mouse
      vel.x = cos(angle) * termiteSpeed * 2;
      vel.y = sin(angle) * termiteSpeed * 2;
      pos.add(vel);
      
      // Always deposit trail when near mouse
      depositTrail();
    }
  }
  
  float senseDirection(float angleOffset) {
    float senseX = pos.x + cos(angle + angleOffset) * senseDistance;
    float senseY = pos.y + sin(angle + angleOffset) * senseDistance;
    
    // Check bounds
    senseX = constrain(senseX, 0, width-1);
    senseY = constrain(senseY, 0, height-1);
    
    return trailMap[int(senseX)][int(senseY)];
  }
  
  void depositTrail() {
    int x = int(pos.x);
    int y = int(pos.y);
    if (x >= 0 && x < width && y >= 0 && y < height) {
      trailMap[x][y] = 1.0;
    }
  }
  
  void display() {
    noStroke();
    if (hasResource) {
      fill(hue(trailColor), saturation(trailColor), brightness(trailColor), 150);
    } else {
      fill(0, 0, 100, 150); // White in HSB mode
    }
    ellipse(pos.x, pos.y, 4, 4);
  }
}
