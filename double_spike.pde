class Ds {
  float xW;  // width of the square containing the single star
             // the double spike star is contained in a circle of radious the diagonal of the square
  float cX;  //  x of top left corner
  float cY;  //  y of top left corner
  float diagonal;
  boolean drawingIsActive; //  stars is still be rendered
  
  int num;     // the number of items in the array
  float[] x;       // x-position of point
  float[] y;       // y-position of point
  float[] speed;   // speed 
  float[] phase;   // phase,  used if sin/cos function is used for moving the drawing points
  float theta = 45;  // how many degrees the second pattern is rotated
    
  float distanceMargin;  // defines the max distance between points for drawing lines
  float rowHeight;
  float lineDensity;
  float frameSwitch; // number of frames that triggers the generation of new random speeds for the drawing point
  
  // colour control
  float h;
  float s;
  float b;
  float a;
  float startHue;
  float hueIncrem;
  
  Ds(float cX_, float cY_, float xW_, int num_, float startHue_, int frameSwitch_) {
    cX = cX_;
    cY = cY_;
    xW = xW_;
    diagonal = sqrt(xW*xW + xW*xW);  //radious of the circle containing the double spike star
    num = num_;
    rowHeight = xW/(num/2-1);
    distanceMargin = rowHeight*.03;
    lineDensity = 0.06*xW;
    frameSwitch = frameSwitch_;
    drawingIsActive = true;
    
    // allocate size of arrays
    x = new float[num];
    y = new float[num];
    speed = new float[num];
    phase = new float[num]; 
    
    startHue = startHue_;
    h = startHue;
    hueIncrem = 4;
    s = 50;
    b = 100;
    a = 20;
      
    //setup an initial value for each item in the array
    for (int i=0; i<num; i++) {
      // even index points run horizontally
      if(i%2 ==0) {
        x[i] = random(xW); 
        y[i] = rowHeight * i/2;
        speed[i] = random(1); // returns a random float bewteen 0 and 1
        phase[i] = random(TWO_PI);
      } else {
        // odd index points run vertically
        x[i] = rowHeight * (i-1)/2; 
        y[i] = random(xW);
        speed[i] = random(1); // returns a random float bewteen 0 and 1
        phase[i] = random(TWO_PI);
      }      
    }        
  }
  
  void update() {
    for (int i=0; i<num; i++) {

      if (i%2 == 1) { // odd index points run vertically
        y[i] = y[i]+ lineDensity*speed[i];//xW/2 + sin(r + phase[i])* xW/2;
        if(y[i] > xW) {
          y[i] = xW;
          speed[i] *= -1;
        }
        if(y[i] < 0) {
          y[i] = 0;
          speed[i] *= -1;
        }
      }
      else { // even index points run horizontally
        x[i] = x[i] + lineDensity*speed[i];  //xW/2 + cos(r + phase[i])* xW/2;
        if(x[i] > xW) {
          x[i] = xW;
          speed[i] *= -1;
        }
        if(x[i] < 0) {
          x[i] = 0;
          speed[i] *= -1;
        }
      }
    
      // create new random speed every frameSwitch frames
      if(frameCount%int(frameSwitch) == 0) {  
        speed[i] = random(1);
      }          
    }
  }
  
  void dissimilar(float startHue) {
    for(int i=0; i< num; i+=2) {
      h = startHue;
      for(int j = 1; j<num; j+=2) {
         float distance = dist(x[i], y[i], x[j], y[j]);
         if (distance > rowHeight && distance < rowHeight + distanceMargin*1.2) {
    
           h = h + hueIncrem * (i+1.5*j); 
           if(h>360) {
             h-= 360;
           }
           
          stroke(h, s, b, a);
          float sw = map(xW, 200, 50, 1, 0.4);  //  strokeWeight is function of Star size
          strokeWeight(sw);
          line(x[i], y[i], x[j], y[j]);
          
          // uncomment if you want to display the moving points
          //fill(128);
          //stroke(255);
          //ellipse(x[i], y[i], 7, 7);
          //ellipse(x[j], y[j], 7, 7);
          //fill(255); 
          } 
       }
    } 
  }
  
  void run() {
    if(drawingIsActive) {
      update();
      
      pushMatrix();
      translate(cX, cY);
      noFill(); 
      dissimilar(startHue);
      popMatrix();
    }
  }
  
  void runDouble() {
    if(drawingIsActive) {
      update();
      
      if(frameCount<frameSwitch*3) {
        pushMatrix();
        translate(cX, cY);
        dissimilar(startHue);
        popMatrix();
      } else {
        pushMatrix();
        translate(cX, cY);
        translate(xW/2, xW/2);
        rotate(radians(theta));
        translate(-xW/2, -xW/2);
        dissimilar(startHue+180);
        popMatrix();
      }
      //    stop drawing after frameSwitch * 3 frames
      if(frameCount > int(frameSwitch)*6) { 
        drawingIsActive = false;
      }
    }
  }
            
}  //  end of class