/*  *** Spiked Stars ***

    By GrandeMago & Carola, AUG 2016
    
    this sketch draws some Spiked Stars.
    Stars can be "single" or "double", changing the call to the function .run or .runDouble in the draw routine.
    For higher number of Stars, a better visual outcome is achieved using "single" Stars only;
    try changing the following variables:
    
    num: number of Stars per row;
    frameSwitch: affect the numbers of lines used in each star. Suggested combination of num and frameSwitch value are:
    
      num        frameSwitch

      18         200    single stars
      12         500    single stars
      9          400    single stars
      6          450    single stars
      6          1200   double stars
      2          1500   double stars
      
    The sketch stop drawing automatically and saves a screenshot in .PNG format
    
    Enjoy!

*/

Ds[][] spike;
Ds cSpike;
int num;   //  num of tiles
float tileW;  //  horiz width of each tile
float xW;  //  square width
int frameSwitch;

void setup() {
  size(540, 540, P3D);
  //pixelDensity(2);
  frameRate(900);
  
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 0, 100);
  
  num =54 ;
  frameSwitch = 150;
  tileW = width/num;
  xW = tileW/(sqrt(2));
  spike = new Ds[num][num];
  float diff = (tileW-xW)/2;
  
  for(int i=0; i< num; i++) {
    for(int j=0; j<num; j++) {
  
    spike[i][j] = new Ds(diff+i*tileW, diff+j*tileW, xW, 6, random(360), frameSwitch);
    }
  }
  
  //create a spike in the center
  cSpike = new Ds(width/2-xW/6, height/2-xW/6, xW/3, 6 , random(360), frameSwitch);
 
}

void draw() {
  //println(frameRate+"   "+frameCount);
  for(int i=0; i< num; i++) {
    for(int j=0; j<num; j++) {
    
      spike[i][j].run();
      //spike[i][j].runDouble();  // uncomment for "double" stars
    }
  }
  //cSpike.runDouble();  //  uncomment for "double" star at center of canvas
  //cSpike.run();  //  uncomment for "single" star at center of canvas
  
  if(frameCount > frameSwitch*6) {       
    saveFrame("frame-###.png");
    println("I am done");
    noLoop();
  }
}