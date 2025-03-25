// Export.pde - Export functions for 3D Termite Simulation

void saveVariation() {
  saveFrame("termite3d-variation-####.png");
  println("Screenshot saved!");
}

void exportPoints() {
  // Format timestamp
  String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  String filename = "termite3d-points-" + timestamp + ".csv";
  
  PrintWriter output = createWriter(filename);
  
  
  output.println("x,y,z,intensity");
  
  
  int pointCount = 0;
  
  float visibilityThreshold = 5.0 / trailStrength;
  
  // Export all trail points with intensity above threshold
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      for (int z = 0; z < gridSize; z++) {
        
        if (trailMap[x][y][z] > visibilityThreshold) { 
          float intensity = trailMap[x][y][z];
          float worldX = x * cellSize;
          float worldY = y * cellSize;
          float worldZ = z * cellSize;
          
          // Write point data to file
          output.println(worldX + "," + worldY + "," + worldZ + "," + intensity);
          pointCount++;
        }
      }
    }
  }
  
  // If no points were found, add a message and lower the threshold
  if (pointCount == 0) {
    output.println("# No points were found above the threshold");
    
    // Output with much lower threshold just to get some data if possible
    visibilityThreshold = 0.001;  // Fall back to previous threshold
    for (int x = 0; x < gridSize; x += 5) {  // Sample every 5th point to keep file size manageable
      for (int y = 0; y < gridSize; y += 5) {
        for (int z = 0; z < gridSize; z += 5) {
          if (trailMap[x][y][z] > visibilityThreshold) { 
            float intensity = trailMap[x][y][z];
            float worldX = x * cellSize;
            float worldY = y * cellSize;
            float worldZ = z * cellSize;
            
            output.println(worldX + "," + worldY + "," + worldZ + "," + intensity);
            pointCount++;
          }
        }
      }
    }
  }
  
  output.flush();
  output.close();
  
  // Display output location in Processing console
  if (pointCount > 0) {
    println("Points exported successfully!");
    println("Exported " + pointCount + " points to: " + sketchPath() + "/" + filename);
    println("Used visibility threshold: " + visibilityThreshold);
  } else {
    println("No trail points found to export. Try running the simulation longer or modifying parameters.");
  }
}

void exportOBJ() {
  // Format timestamp
  String timestamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  String filename = "termite3d-points-" + timestamp + ".obj";
  
  PrintWriter output = createWriter(filename);
  
  // Calculate the actual visibility threshold based on trailStrength
  float visibilityThreshold = 5.0 / trailStrength;
  
  // Write OBJ header
  output.println("# Termite 3D Trail Points");
  output.println("# Generated: " + timestamp);
  output.println("# Visibility threshold: " + visibilityThreshold);
  output.println("# Points: " + countTrailPoints(visibilityThreshold));
  output.println();
  
  // Counter for exported points
  int pointCount = 0;
  float pointSize = cellSize * 0.3; // Size of each point (sphere)
  
  // Export vertices for all trail points above threshold
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      for (int z = 0; z < gridSize; z++) {
        if (trailMap[x][y][z] > visibilityThreshold) { 
          float intensity = trailMap[x][y][z];
          float worldX = x * cellSize;
          float worldY = y * cellSize;
          float worldZ = z * cellSize;
          
          // Write vertex data
          output.println("v " + worldX + " " + worldY + " " + worldZ + " " + 
                        hue(trailColor)/360.0 + " " + saturation(trailColor)/100.0 + " " + 
                        (brightness(trailColor)/100.0 * intensity));
                        
          pointCount++;
        }
      }
    }
  }
  
  // If we have points, define them as spheres or point primitives
  if (pointCount > 0) {
    output.println();
    output.println("# Point size: " + pointSize);
    output.println("# Use this parameter in your 3D software to render points as spheres");
    output.println("# or adjust during import when prompted about point size");
  } else {
    // If no points were found, add a comment and lower the threshold
    output.println("# No points were found above the visibility threshold");
    
    visibilityThreshold = 0.001;  // Fall back to previous threshold
    
    // Output with much lower threshold just to get some data if possible
    for (int x = 0; x < gridSize; x += 5) {  // Sample every 5th point
      for (int y = 0; y < gridSize; y += 5) {
        for (int z = 0; z < gridSize; z += 5) {
          if (trailMap[x][y][z] > visibilityThreshold) { 
            float intensity = trailMap[x][y][z];
            float worldX = x * cellSize;
            float worldY = y * cellSize;
            float worldZ = z * cellSize;
            
            output.println("v " + worldX + " " + worldY + " " + worldZ + " " + 
                          hue(trailColor)/360.0 + " " + saturation(trailColor)/100.0 + " " + 
                          (brightness(trailColor)/100.0 * intensity));
            pointCount++;
          }
        }
      }
    }
  }
  
  output.flush();
  output.close();
  
  // Display output location in Processing console
  if (pointCount > 0) {
    println("OBJ exported successfully!");
    println("Exported " + pointCount + " points to: " + sketchPath() + "/" + filename);
    println("Used visibility threshold: " + visibilityThreshold);
  } else {
    println("No trail points found to export. Try running the simulation longer or modifying parameters.");
  }
}

// Helper function to count trail points without exporting
int countTrailPoints() {
  return countTrailPoints(0.001); // Use default threshold if not specified
}

// Overloaded helper function that takes a threshold parameter
int countTrailPoints(float threshold) {
  int count = 0;
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      for (int z = 0; z < gridSize; z++) {
        if (trailMap[x][y][z] > threshold) {
          count++;
        }
      }
    }
  }
  return count;
}

// Add a slider to control export threshold
void addExportThresholdSlider(ControlP5 cp5, Group group) {
  cp5.addSlider("exportThreshold")
     .setPosition(10, 380)
     .setSize(180, 15)
     .setRange(0.001, 0.1)
     .setValue(0.01)
     .setLabel("Export Detail Level")
     .setGroup(group);
}
