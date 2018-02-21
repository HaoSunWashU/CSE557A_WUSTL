//data
String dataPath = "data.csv";          //data file name
DataReader dataReader;             //load data
String[] namesForColumns;
String[] namesForRows;

int[] displayOrder;
ArrayList<String> selectedRows; 
ArrayList<String> allRows;
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
float startPointX;
float startPointY;
float filterWidth;
float filterHeight;

//hovering
boolean isHovering = false;
ArrayList<String> hoveringRows;

void setup(){
  size(1200,800);
  smooth();
  surface.setResizable(true);
  background(60);
  
  isDraggingAxis = false;
  isFilter = false;
  //Load data from .csv file using DataReader()
  loadData();
  
  //Initialize Axes based on data 
  initializeAxes();
  print(dataReader.getNumColumns());
  
  
  hoveringRows = new ArrayList<String>();
  //debug
  //axes.get(0).setFlip();
}

void loadData(){
  dataReader = new DataReader(dataPath);
  namesForColumns = new String[dataReader.getNumColumns()];
  namesForColumns = dataReader.getNamesForColumns();
  namesForRows = new String[dataReader.getNumRows()];
  namesForRows = dataReader.getNamesForRows();
  selectedRows = new ArrayList<String>();
  allRows = new ArrayList<String>();
  for(String name: namesForRows){
    selectedRows.add(name);
    allRows.add(name);
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
   hoveringRows.clear();
   strokeWeight(2);
   
   //if(isDraggingAxis){
   //  stroke(color(52,109,241, 50));
   //}else{
   //  stroke(color(52,109,241));
   //}
   //checkFilterData();
   
   //draw all rows first
   for(String row : allRows){
     Number colorPos;
     //float yPos_0 = axes.get(0).getYPos(row);
     colorPos = axes.get(0).getValue(row);
     colorPos = ((colorPos.floatValue() - axes.get(0).getMin().floatValue())/(axes.get(0).getMax().floatValue()-axes.get(0).getMin().floatValue())) * 255;
     //colorPos = (int)(((yPos_0/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height) * 255)/800.0 * height);
     //colorPos = (int)((yPos_0/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height) * 255);
     if(isDraggingAxis){
         stroke(color(colorPos.intValue(),109,241, 50));
       }else{
         stroke(color(colorPos.intValue(),109,241, 70));
       }
     for(int i = 1; i < axes.size(); i++){
       float preX = axes.get(i-1).getXPos();
       float preY = axes.get(i-1).getYPos(row);  //get Y position based on the orientation of axis
       float currentX = axes.get(i).getXPos();
       float currentY = axes.get(i).getYPos(row);
       
       line(preX, preY, currentX, currentY);
     }
   }
   
   //draw selected rows with different Color
   for(String row : selectedRows){
     Number colorPos;
     //float yPos_0 = axes.get(0).getYPos(row);
     colorPos = axes.get(0).getValue(row);
     colorPos = ((colorPos.floatValue() - axes.get(0).getMin().floatValue())/(axes.get(0).getMax().floatValue()-axes.get(0).getMin().floatValue())) * 255;
     //debug
     //int colorPos;
     //float yPos_0 = axes.get(0).getYPos(row);
     //colorPos = (int)((yPos_0/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height) * 255);
     if(isDraggingAxis){
         stroke(color(colorPos.intValue(),109,241, 80));
       }else{
         stroke(color(colorPos.intValue(),109,241));
       }
     for(int i = 1; i < axes.size(); i++){
       float preX = axes.get(i-1).getXPos();
       float preY = axes.get(i-1).getYPos(row);  //get Y position based on the orientation of axis
       float currentX = axes.get(i).getXPos();
       float currentY = axes.get(i).getYPos(row);
       if(mouseX > preX && mouseX < currentX && Math.abs((mouseY-preY)/(mouseX-preX)-(currentY-preY)/(currentX-preX))<0.1)
         hoveringRows.add(row);
       line(preX, preY, currentX, currentY);
     }
   }
   
   //unselectedRows
}

void drawHoveringRowsInfo(){
  
  stroke(255);
  strokeWeight(2);
  //draw highlighted line for hovering line
  for(int j=0; j<hoveringRows.size();j++){
    for(int i = 1; i < axes.size(); i++){
       float preX = axes.get(i-1).getXPos();
       float preY = axes.get(i-1).getYPos(hoveringRows.get(j));  //get Y position based on the orientation of axis
       float currentX = axes.get(i).getXPos();
       float currentY = axes.get(i).getYPos(hoveringRows.get(j));
       line(preX, preY, currentX, currentY);
    }
  }
  //draw values
  for(int j=0; j<hoveringRows.size();j++){
    for(int i=0; i<axes.size(); i++){
      float currentX = axes.get(i).getXPos();
      float currentY = axes.get(i).getYPos(hoveringRows.get(j));
      fill(220);
      //stroke(220);
      noStroke();
      textSize(18*(width/1200.0 + height/800.0)/2.0);
      rectMode(CENTER);
      rect(currentX,currentY - 5.0/800*height,40.0/1200.0*width, 25.0/800.0*height,5.0*(width/1200.0 + height/800.0)/2.0);
      fill(226, 44, 41);
      text(axes.get(i).getValue(hoveringRows.get(j)).toString(),currentX,currentY);
    }
  }
  
  //fill(45, 156, 65);
  fill(255);
  textSize(18*(width/1200.0 + height/800.0)/2.0);
  text(hoveringRows.get(0), mouseX, mouseY);
         
         

}
void draw(){ // call this function each frame
  
  background(60);
  drawAxes();
  drawLines();
  if(hoveringRows.size()!=0){
    drawHoveringRowsInfo();
  }
  if(drawBound){
    drawBound();
  }
  updateFilters();
  updataSelectedRows();
  
  
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
    startPointX = 0;
    startPointY = 0;
    filterWidth = 0;
    filterHeight =0;
  }
}

void mouseReleased(){
  isDraggingAxis = false;
  //deselect all axis
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).setSelect(false);
  }
  drawBound = false;
  startPointX = 0;
  startPointY = 0;
  filterWidth = 0;
  filterHeight =0;
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
  //unify the position of bounding rect
  if(boundWidth >0 && boundHeight >0){
    startPointX = mouseXPos;
    startPointY = mouseYPos;
    filterWidth = boundWidth;
    filterHeight = boundHeight;
  }
  
  if(boundWidth > 0 && boundHeight <0){
    startPointX = mouseXPos;
    startPointY = mouseYPos + boundHeight;
    filterWidth = boundWidth;
    filterHeight = -boundHeight;
  }
  
  if(boundWidth <0 && boundHeight >0){
    startPointX = mouseXPos + boundWidth;
    startPointY = mouseYPos;
    filterWidth = -boundWidth;
    filterHeight = boundHeight;
  }
  
  if(boundWidth <0 && boundHeight <0){
    startPointX = mouseXPos + boundWidth;
    startPointY = mouseYPos + boundHeight;
    filterWidth = -boundWidth;
    filterHeight = -boundHeight;
  }
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
      if(axes.get(i).getXPos() > startPointX && axes.get(i).getXPos() < startPointX + filterWidth){
          if(!axes.get(i).isFlipped()){ // if not flipped; up: min; down: max.
            //condition1 #correct
            if(startPointY/800.0 * height <= 50.0/800.0 * height && 
                (startPointY+filterHeight)/800.0 * height > 50.0/800.0 * height &&
                (startPointY+filterHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (startPointY+filterHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(axes.get(i).getMin(), newFilter2);
            }
            //condition2 #correct
            if(startPointY/800.0 * height > 50.0/800.0 * height && (startPointY+filterHeight)/800.0 * height > 50.0/800.0 * height &&
                (startPointY+filterHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((startPointY/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (startPointY+filterHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, newFilter2);
            }
            //condition3 #correct
            if(startPointY/800.0 * height > 50.0/800.0 * height && startPointY/800.0 * height < 750.0/800.0 * height && (startPointY+filterHeight)/800.0 * height > 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((startPointY/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMax());
            }
          }else{ // if flipped  up: max; down: min
            //condition1 #correct
            if(startPointY/800.0 * height <= 50.0/800.0 * height && 
                (startPointY+filterHeight)/800.0 * height > 50.0/800.0 * height &&
                (startPointY+filterHeight)/800.0 * height < 750.0/800.0 * height){
              Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (startPointY+filterHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(axes.get(i).getMax(), newFilter2);
            }
            //condition2 
            if(startPointY/800.0 * height > 50.0/800.0 * height && (startPointY+filterHeight)/800.0 * height > 50.0/800.0 * height &&
                (startPointY+filterHeight)/800.0 * height < 750.0/800.0 * height){
              //upbound
              Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((startPointY/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              //lowbound
              Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (startPointY+filterHeight)/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, newFilter2);
            }
            //condition3
            if(startPointY/800.0 * height > 50.0/800.0 * height && startPointY/800.0 * height < 750.0/800.0 * height && (startPointY+filterHeight)/800.0 * height > 750.0/800.0 * height){
              Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((startPointY/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
                * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
              axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMin());
            }
          }
        //}else if(boundHeight < 0){
        //  if(!axes.get(i).isFlipped()){ // if not flipped; up: min; down: max.
        //    //condition1 #correct
        //    if(mouseYPos/800.0 * height <= 50.0/800.0 * height && 
        //        (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
        //        (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
        //      Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
        //      axes.get(i).changeFilterPosition(axes.get(i).getMin(), newFilter2);
        //    }
        //    //condition2 #correct
        //    if(mouseYPos/800.0 * height > 50.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
        //        (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
        //      Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
        //      Number newFilter2 = (int)((axes.get(i).getMax().floatValue() - (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
        //      axes.get(i).changeFilterPosition(newFilter1, newFilter2);
        //    }
        //    //condition3 #correct
        //    if(mouseYPos/800.0 * height > 50.0/800.0 * height && mouseYPos/800.0 * height < 750.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 750.0/800.0 * height){
        //      Number newFilter1 = (int)((axes.get(i).getMin().floatValue() + ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
        //      axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMax());
        //    }
        //  }else{ // if flipped  up: max; down: min
        //    //condition1 #correct
        //    if(mouseYPos/800.0 * height <= 50.0/800.0 * height && 
        //        (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
        //        (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
        //      Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
        //      axes.get(i).changeFilterPosition(axes.get(i).getMax(), newFilter2);
        //    }
        //    //condition2 
        //    if(mouseYPos/800.0 * height > 50.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 50.0/800.0 * height &&
        //        (mouseYPos+boundHeight)/800.0 * height < 750.0/800.0 * height){
        //      //upbound
        //      Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
        //      //lowbound
        //      Number newFilter2 = (int)((axes.get(i).getMin().floatValue() + (((750.0/800.0 * height - (mouseYPos+boundHeight)/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue())))*10)/10.0;
        //      axes.get(i).changeFilterPosition(newFilter1, newFilter2);
        //    }
        //    //condition3
        //    if(mouseYPos/800.0 * height > 50.0/800.0 * height && mouseYPos/800.0 * height < 750.0/800.0 * height && (mouseYPos+boundHeight)/800.0 * height > 750.0/800.0 * height){
        //      Number newFilter1 = (int)((axes.get(i).getMax().floatValue() - ((mouseYPos/800.0 * height - 50.0/800.0 * height) / (700.0/800.0 * height))
        //        * (axes.get(i).getMax().floatValue() - axes.get(i).getMin().floatValue()))*10)/10.0;
        //      axes.get(i).changeFilterPosition(newFilter1, axes.get(i).getMin());
        //    }
        //  }
      }
  }
  startPointX = 0;
  startPointY = 0;
  filterWidth = 0;
  filterHeight =0;
}

//update 
void updataSelectedRows(){
  ArrayList<String> allRowsClone = new ArrayList<String>();
  for(int i = 0; i<allRows.size(); i++){
    allRowsClone.add(allRows.get(i));
  }
  
  selectedRows = allRowsClone;
  
  //int size = axes.get(0).getHiddenRows().size();
  //int filterAxis = 0;
  for(int i = 0; i < axes.size(); i++){
    axes.get(i).updateHiddenRows();
    for(int j = 0; j < axes.get(i).getHiddenRows().size(); j++){
      selectedRows.remove(axes.get(i).getHiddenRows().get(j));
    }
  }
  
  //ArrayList<String>  hiddenRows = axes.get(filterAxis).getHiddenRows();
  //for(int i = 0; i < hiddenRows.size(); i++){
  //  selectedRows.remove(hiddenRows.get(i));
  //}
  
}