//Drawable(something that can be drawn..) Infomation of objects
int objCount;

float[] objPointX;  //Position X of each object 
float[] objPointY;  //Position Y of each object 
color[] objColor;   //Color info of each object
float objRad;        //Radius of whole object
float mainRad;       //Main(Center) color ball radius
color mainColor;     //Main(Center) color ball color
float accelerationAnimation;  //For rotation animation

// Project Variable
float maxRad;          //Maximum Radius
float minRad;          //Minimum Radius
float maxDistance;     //Maximum Distance
float minDistance;     //Minimum Distance
float currentDistance; //Current Distance
float centerPosX;      //Center position about project canvasX
float centerPosY;      //Center position about project cnavasY
float currentSpeed;    //Controll Animation Speed;

int clickedIndex;      // == Clicked Objects Index

// Text Position / Alpha
float textPosX;        //Text Position X
float textPosY;        //Text Position Y
float toTextPosX;      //This variable is About position for Fade In(?) and Out Animation
float toTextPosY;      //
float beginTextPosX;   //
float beginTextPosY;   //
float textAlpha;       //Text Alpha

// DeltaTime
long currentTime;
long lastTime;
float deltaTime;
float time;

PFont f;

void setup() {
  //Init Project
  size(800, 600);
  frameRate(144);

  colorMode(HSB, 360);
  noStroke();

  // Init Variable
  maxRad = 1000;
  minRad = 100;
  objRad = 30;
  mainRad = 1;
  maxDistance = 800;
  minDistance = 200;
  currentDistance = 0; //Start Position
  
  objCount = 36;
  
  currentSpeed = 3;
  accelerationAnimation = -100;

  objPointX = new float[objCount];
  objPointY = new float[objCount];
  objColor = new color[objCount];

  centerPosX = width / 2;
  centerPosY = height / 2;

  clickedIndex = -1;
  
  textPosX = -100;
  textPosY = 100;
  toTextPosX = 50;
  toTextPosY = 100;
  beginTextPosX = -200;
  beginTextPosY = 100;
  textAlpha = 360;
  
  for (int i = 0; i < objCount; i++) {
    objPointX[i] = centerPosX;
    objPointY[i] = centerPosY;
    objColor[i] = color((360 / objCount) * i, 360, 360);
  }

  // Init Deltatime
  lastTime = millis();
  deltaTime = 0;
  time = 0;
  
  f = createFont("Palatino Linotype Bold", 144, true);
}

// Check what object is clicked with cursor and object position
void checkObjClicked(int posX, int posY) {
  for (int i = 0; i < objCount; i++) {
    
    //Simple Box Check Algorithm
    if (objPointX[i] - objRad < posX && posX < objPointX[i] + objRad) {
      if (objPointY[i] - objRad < posY && posY < objPointY[i] + objRad) {
        if (i != clickedIndex) {  
          clickedIndex = i;
          accelerationAnimation = 200;
          break;
        }
      }
    }
    // If, user clicked background or main color ball
    else if(clickedIndex != -1) {
      clickedIndex = -1;
      accelerationAnimation = -100;
    }
  }
}

// 
void drawAndMoveObj() {
  // Contoll project speed about movement, rotation etc...
  accelerationAnimation = lerp(accelerationAnimation, 0.0f, 3 * deltaTime);
  
  // time is essential to rotate objects
  // time will be used for object angle(degrees)
  time = ((time + (currentSpeed + accelerationAnimation) * deltaTime)) % 360;
  
  // this variable is target color about main color ball
  color targetColor = #FFFFFF;
  
  // Controll object distance and main color ball radius
  if (clickedIndex != -1) {
    currentDistance = lerp(currentDistance, maxDistance, currentSpeed * deltaTime);
    mainRad = lerp(mainRad, maxRad, currentSpeed * deltaTime);
  } else {
    currentDistance = lerp(currentDistance, minDistance, currentSpeed * deltaTime);
    mainRad = lerp(mainRad, minRad, currentSpeed * deltaTime);
  }

  // Move Object and Draw!
  for (int i = 0; i < objCount; i++) {
    objPointX[i] = centerPosX + cos(radians(time + (360 / objCount) * i + 3 * accelerationAnimation)) * currentDistance;
    objPointY[i] = centerPosY + sin(radians(time + (360 / objCount) * i + 3 * accelerationAnimation)) * currentDistance;
    
    if(clickedIndex == i) {
      targetColor = objColor[i];
    }
    fill(objColor[i]);
    ellipse(objPointX[i], objPointY[i], objRad, objRad);
  }
  
  // If, any object didn't clicked, than main color ball would change rainbow color
  if(clickedIndex == -1) {
    targetColor = color(time, 360, 360);
  }
  
  // Draw Main Color Ball!
  mainColor = lerpColor(mainColor, targetColor, currentSpeed * deltaTime);
  fill(mainColor);
  ellipse(centerPosX, centerPosY, mainRad, mainRad);
}

// Get DeltaTime to apply same effect when framerate(frame per sec) is not equally
void getDeltaTime() {
  currentTime = millis();
  deltaTime = (currentTime - lastTime)  * 0.001f;
  lastTime = currentTime;
}

// Draw Color Infomation
void printColorInfo() {
  // Fade In(?) and Out(?) Animation
  // If object is clicked then start this animation
  if(clickedIndex != -1) {
    textPosX = lerp(textPosX, toTextPosX, 2 * deltaTime);
    textPosY = lerp(textPosY, toTextPosY, 2 * deltaTime);
    textAlpha = lerp(textAlpha, 360, 2 * deltaTime);    
  }  
  else {
    textPosX = lerp(textPosX, beginTextPosX, 2 * deltaTime);
    textPosY = lerp(textPosY, beginTextPosY, 2 * deltaTime);
    textAlpha = lerp(textAlpha, 0, 2 * deltaTime);
  }
  
  // Draw Text!
  textFont(f, 38);
  fill(#FFFFFF, textAlpha);
  text("Code / #" + hex(mainColor, 6), textPosX, textPosY);
  textFont(f, 20);
  text("HUE / " + 360 / objCount * clickedIndex, textPosX, textPosY+40);
}

void draw() {
  // Project Cycle...
  background(#FFFFFF);  //1. Clear screen
  getDeltaTime();       //2. Get DeltaTime
  drawAndMoveObj();     //3. Update Object Info 
  printColorInfo();     //              and Draw!
}

// Mouse Interaction
void mouseClicked() {
  checkObjClicked(mouseX, mouseY);
}
