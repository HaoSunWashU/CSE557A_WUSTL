int rectSize = 200;
boolean overRect = false;
boolean changed = false;

void setup(){
  size(600, 600);
  background(120);
  surface.setResizable(true);
}

void draw(){
  rectMode(CENTER);
  fill(250,0,0);
  rect(300,300,rectSize,rectSize);
  
  fill(255,255,255);
  textAlign(CENTER);
  text("this is a rect", 300, 300);
}

// Test if the mouse is over the rect
void mouseOnRect(){
  if (mouseX > 300 - rectSize/2 && mouseX < 300 + rectSize/2 && 
      mouseY > 300 - rectSize/2 && mouseY < 300 + rectSize/2) {
    overRect = true; }
  else{
    overRect = false;}
}

void mousePressed() {
  mouseOnRect(); 
  //&& !changed
  if(overRect){  
    if(changed)
    {
      background(120);  
      changed = false;
    }
    else
    {
      background(0);
      changed = true;
    }
  }
}

//if (mousePressed) {
  //  stroke(255);
  //} else {
  //  stroke(120);
  //}
  //line(mouseX-66, mouseY, mouseX+66, mouseY);
  //line(mouseX, mouseY-66, mouseX, mouseY+66); 
  ////ellipseMode(CENTER);
  //fill(250,0,0);
  //ellipse(300,300,200,200);
  //fill(255,255,255);
  //ellipse(300,300,40,40);
  //text("123",200,200);

  //fill(255);
  //rect(200, 200, 200, 200);
  
  //char letter = char(0);
  //text(letter, 200, 200);