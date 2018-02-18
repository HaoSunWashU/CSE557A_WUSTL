//data
String dataPath = "data.csv";          //data file name
DataReader dataReader;             //load data
String[] namesForColumns;
String[] namesForRows;

int[] displayOrder;
ArrayList<String> selectedRows;
//axes
ArrayList<Axis> axes;

//Canvas size 
float leftMargin = 100.0/1200.0;
float rightMargin = 100.0/1200.0;
float topMargin = 50.0/800.0;
float bottomMargin = 50.0/800.0;

//mouse information
float mouseXPos;
float mouseYPos;
boolean isDrag;
boolean isFilter;

//user bound for flitering data
boolean drawBound = false;
float boundWidth;
float boundHeight;

void setup(){
  size(1200,800);
  smooth();
  surface.setResizable(true);
  background(60);
  
  isDrag = false;
  isFilter = false;
  //Load data from .csv file using DataReader()
  loadData();
  
  //Initialize Axes based on data 
  initializeAxes();
  print(dataReader.getNumColumns());
  
  
  //debug
  axes.get(0).setFlip();
}

void loadData(){
  dataReader = new DataReader(dataPath);
  namesForColumns = new String[dataReader.getNumColumns()];
  namesForColumns = dataReader.getNamesForColumns();
  namesForRows = new String[dataReader.getNumRows()];
  namesForRows = dataReader.getNamesForRows();
  selectedRows = new ArrayList<String>();
  for(String name: namesForRows){
    selectedRows.add(name);
  }
}

//Axes initialization
void initializeAxes(){
  axes = new ArrayList<Axis>();
  for(int i = 0; i < namesForColumns.length; i++){
    axes.add(new Axis(namesForColumns[i], namesForRows, dataReader.getColumnData(i+1), dataReader.getNumColumns()));
  }
}

void drawAxes(){
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).display(i);
  }
}

//based on the data in each row of selectedRows, draw line row by row
void drawLines(){
   strokeWeight(1);
   
   if(isDrag){
     stroke(color(45, 156, 65, 50));
   }else{
     stroke(color(45, 156, 65));
   }
   //checkFilterData();
   
   for(String row : selectedRows){
     for(int i = 1; i < axes.size(); i++){
       float preX = axes.get(i-1).getXPos();
       float preY = axes.get(i-1).getYPos(row);  //get Y position based on the orientation of axis
       float currentX = axes.get(i).getXPos();
       float currentY = axes.get(i).getYPos(row);
       
       line(preX, preY, currentX, currentY);
     }
   }
   
}

void draw(){ // call this function each frame
  background(60);
  drawAxes();
  drawLines();
}

//Detect mouse motion
void mousePressed() {
  //Capture the current mouseX and mouseY for starting bound coordinate
  mouseXPos = mouseX;
  mouseYPos = mouseY;
  
  
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).mouseInFlipButton(); //check whether user press the flip button
    
    //check whether user select 
    if(axes.get(i).mouseInTilteButton()){
      axes.get(i).setSelect(true);
    }
  }

  //If click and bound is drawing before, be false
  if (drawBound) {
    drawBound = false;
  }
}

void mouseReleased(){
  isDrag = false;
  //deselect all axis
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).setSelect(false);
  }
}

void mouseDragged() 
{
  isDrag = true;
  //drag mouse and draw bound
  drawBound = true;
  boundWidth = mouseX-mouseXPos;
  boundHeight = mouseY-mouseYPos;
}

//draw Bound
void drawBound(){
  rectMode(CORNER);
  strokeWeight(2);
  noFill();
  stroke(249,176,12);
  rect(mouseXPos, mouseYPos, boundWidth, boundHeight);
}

void swapAxes(int a, int b) {
  Axis axis1 = axes.get(a);
  Axis axis2 = axes.get(b);
  
  axes.remove(a);
  axes.add(a, axis2);
  axes.remove(b);
  axes.add(b, axis1);
}