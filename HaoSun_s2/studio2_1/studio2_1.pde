float rectSize;
boolean overButton = false;
boolean shrink;
String buttonText = "Shrink";

void setup(){
  size(600, 600);
  smooth();
  rectSize = 400;
  surface.setResizable(true);
}


void draw(){
  background(120);

  //button
  rectMode(CENTER);
  fill(0,0,250);
  rect(50,50,100,40);
  //buttonText
  fill(255,255,255);
  textAlign(CENTER);
  text(buttonText, 50, 50);
  
  
  //central square
  rectMode(CENTER);
  fill(250,0,0);
  rect(300,300,rectSize,rectSize);
  if(shrink){
      rectSize = lerp(rectSize, 200, 0.05);
  }
  else
  {
      rectSize = lerp(rectSize, 400, 0.05); 
  }
  rect(300,300,rectSize,rectSize);
}

// Test if the mouse is over the rect
void mouseOnButton(){
  if (mouseX > 0 && mouseX < 100 && 
      mouseY > 50 - 20 && mouseY < 50 + 20) {
    overButton = true; }
  else{
    overButton = false;}
}

//check if mouse is pressed 
void mousePressed() {
  mouseOnButton(); // check the location of mouse cursor
  if(overButton){  
    if(buttonText == "Shrink") //update 
    {
      background(120);
      shrink = true;
      buttonText = "Expand";
    }
    else
    {
      background(120);
      shrink = false;
      buttonText = "Shrink";
    }
  }
}