//data
String dataPath = "data.csv";          //data file name
DataReader dataReader;             //load data
String[] namesForColumns;
String[] namesForRows;

int[] displayOrder;
ArrayList<String> selectedRows;
//axes
ArrayList<Axis> axes;
Axis draggingAxis;
int id_draggingAxis;

//Canvas size 
float leftMargin = 100.0/1200.0;
float rightMargin = 100.0/1200.0;
float topMargin = 50.0/800.0;
float bottomMargin = 50.0/800.0;

//mouse information
float mouseXPos;
float mouseYPos;
boolean isDraggingAxis;
boolean isFilter;

//user bound for flitering data
boolean drawBound = false;
float boundWidth = 0;
float boundHeight = 0;

void setup(){
  size(1200,800);
  smooth();
  surface.setResizable(true);
  background(140);
  
  isDraggingAxis = false;
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
   
   if(isDraggingAxis){
     stroke(color(52,109,241, 70));
   }else{
     stroke(color(52,109,241));
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
   
   //unselectedRows
}

void draw(){ // call this function each frame
  background(140);
  drawLines();
  drawAxes();
  updateFilters();
  updataSelectedRows();
  
  if(drawBound){
    drawBound();
  }
}

//Detect mouse motion
void mousePressed() {
   if(!isDraggingAxis){
    for(int i = 0; i < axes.size(); i++){
      axes.get(i).mouseInFlipButton(); //check whether user press the flip button
    
      //check whether user select 
      if(axes.get(i).mouseInTilteButton()){
        axes.get(i).setSelect(true);
        isDraggingAxis = true;
        //drawBound = false; //if mouse in title button, don't draw Bound
      }
    }
  }
  if(!isDraggingAxis){  //if user is not dragging axis, can draw bound
    //Capture the current mouseX and mouseY for starting bound coordinate
    mouseXPos = mouseX;
    mouseYPos = mouseY;
  }
  
  //If click and bound is drawing before, be false
  if (drawBound) {
    drawBound = false;
  }
}

void mouseReleased(){
  isDraggingAxis = false;
  //deselect all axis
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).setSelect(false);
  }
  drawBound = false;
}

void mouseDragged() 
{
  for(int i = 0; i < axes.size(); i++){
    if(axes.get(i).getSelect()){
      isDraggingAxis = true;
      draggingAxis = axes.get(i);
      id_draggingAxis = i;
    }
  }
  
  if(isDraggingAxis){
    for(int i = 0; i < axes.size(); i++){
      if(i != id_draggingAxis){
        if(draggingAxis.getXPos() > axes.get(i).getXPos() - 50.0/1200.0 * width &&
          draggingAxis.getXPos() < axes.get(i).getXPos() + 50.0/1200.0 * width){
          swapAxes(i, id_draggingAxis);    
        }
      }
    }
  }
  
  if(!isDraggingAxis){
    //drag mouse and draw bound
    drawBound = true;
    boundWidth = mouseX-mouseXPos;
    boundHeight = mouseY-mouseYPos;
  }
}

//draw Bound
void drawBound(){
  rectMode(CORNER);
  strokeWeight(2);
  noFill();
  stroke(249,176,12);
  rect(mouseXPos, mouseYPos, boundWidth, boundHeight);
  println(boundWidth);
  println(boundHeight);
}

//swap two axes based on their order num
void swapAxes(int a, int b) {
  Axis axis1 = axes.get(a);
  Axis axis2 = axes.get(b);
  
  axis1.setSwap();
  
  axes.set(a, axis2);
  axes.set(b, axis1);
}

void updateFilters(){
  //find filtered axis and update selectedRows
  //mouseXPos;
  //mouseYPos; 
  //boundWidth = mouseX-mouseXPos;
  //boundHeight = mouseY-mouseYPos;
  
  for(int i = 0; i < axes.size(); i++){
    //if draw from left to right
    if(boundWidth > 0){
      if(axes.get(i).getXPos() > mouseXPos && axes.get(i).getXPos() < mouseXPos + boundWidth){
        //if draw from up to down
        if(boundHeight > 0){
          if(!axes.get(i).isFlipped()){ // if not flipped; up: min; down: max.
            //condition1 #correct
            if(mouseYPos/800.0 * height <= 50.0/800.0 * height && 
                (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
                (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(axes.get(i).getMin(), newFilter2);
            }
            //condition2 #correct
            if(mouseYPos/800.0 * height > 50.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
                (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, newFilter2);
            }
            //condition3 #correct
            if(mouseYPos/800.0 * height > 50.0/800.0 * height && mouseYPos/800.0 * height < 750.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMax());
            }
          }else{ // if flipped  up: max; down: min
            //condition1 #correct
            if(mouseYPos/800.0 * height <= 50.0/800.0 * height && 
                (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
                (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(axes.get(i).getMax(), newFilter2);
            }
            //condition2 
            if(mouseYPos/800.0 * height > 50.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
                (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
              //upbound
              Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              //lowbound
              Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, newFilter2);
            }
            //condition3
            if(mouseYPos/800.0 * height > 50.0/800.0 * height && mouseYPos/800.0 * height < 750.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMin());
            }
          }
        }else if(boundHeight < 0){
          
        }
      }
    }else if(boundWidth < 0){
    
    }
  }
}

//update 
void updataSelectedRows(){

}