class Axis{
  //data
  HashMap<String, Number> values;         //get value through name. <String, name>
  String nameForColumn;                   //axis name
  String[] namesForRows;                  //names for each row
  int numAxes;                            //total axis number
  Number min, max;                        //minimum and maximum number of that axis
  Number up, down;                   
  PFont fontInfo = createFont("Georgia", 16, false);
  //statement
  boolean isSelect = false;  
  boolean formerSelected = false;
  boolean isFilter = false;
  boolean isFlipped = false;
  float width_flipButton = 20.0/1200.0 * width;
  float height_flipButton = 20.0/800.0 * height;
  
  float width_titleButton = 50.0/1200.0 * width;
  float height_titleButton = 25.0/800.0 * height;
  
  ArrayList<String>  hiddenRows;          //the names for hidden rows, use ArrayList because it is easier to change length
  color c;
  
  //position
  float axisHeight, xPos, tempX;
  float[] filterRange;
  
  Axis(String nameForColumn, String[] namesForRows, HashMap<String, Number> values, int numAxes){
    this.nameForColumn = nameForColumn;
    this.namesForRows = namesForRows;
    this.values = values;
    this.numAxes = numAxes;
    
    //create supporting variable
    hiddenRows = new ArrayList<String>();
    filterRange = new float[2];
    
    
    //calculate the min and max value in this axis
    min = values.get(namesForRows[0]);  //values is a hashMap, use get(key)
    max = min;
    
    for(String name : namesForRows) {
      Number val = values.get(name);
      if(min.floatValue() > val.floatValue()){
        min = val;
      }
      if(max.floatValue() < val.floatValue()){
        max = val;
      }
    }
    
    if(!isFlipped){
      up = min;
      down = max;
    }else{
      up = max;
      down = min;
    }
    
    filterRange[0] = min.floatValue();
    filterRange[1] = max.floatValue();  //*****
  }
    
   //update filter range
   void changeFilterPosition(float value1, float value2){
     if(value1 <= value2){
       filterRange[0] = value1;
       filterRange[1] = value2;
     }else{
       filterRange[0] = value2;
       filterRange[1] = value1;
     }
      
     // check names of rows outside the filter range
     for(String name : namesForRows){
       if(values.get(name).floatValue() < filterRange[0] || values.get(name).floatValue() > filterRange[1]){
         hiddenRows.add(name);
       }
     }
   }
    
   void setSelect(boolean isSelect){ 
     this.isSelect = isSelect;
   }
   
   void setFilter(boolean isFilter){
     this.isFilter = isFilter;
   }
   
   boolean getSelect(){
     return this.isSelect;
   }
    
   boolean getFilter(){
     return this.isFilter;
   }
   
   void removeFilter(){
     setFilter(false);
     hiddenRows.clear();
     //update filterRange[0] and filterRange[1]
   }
    
   //get Y postion of a name's value
   float getYPos(String nameForRow){
     return getYPos(values.get(nameForRow).floatValue());
   }
    
   //return the x position of this axis
   float getXPos(){
     return xPos;
   }
    
   float getYPos(float value){
     if(!isFlipped){ // up: min;  down: max.
       return 50.0/800.0 * height + 
       700.0/800.0 * height * ((value - min.floatValue())/(max.floatValue() - min.floatValue()));
     }else{          // up: max; down: min.
       return 50.0/800.0 * height +
       700.0/800.0 * height * ((max.floatValue() - value)/(max.floatValue() - min.floatValue()));
     }
     
   }
    
   ArrayList<String> getHiddenRows(){
     return hiddenRows;
   }
   
   //Allow the user to flip the orientation of a dimension
   void flipAxis(){
     if(isFlipped){
       up = max;
       down = min;
     }else{  //normal up: min; down: max.
       up = min;
       down = max;
     }
   }
   
   void setFlip(){
     if(isFlipped){
       isFlipped = false;
       flipAxis();
     }else{
       isFlipped = true;
       flipAxis();
     }
   }
   
   void mouseInFlipButton(){
     if(mouseX > xPos - width_flipButton/2 && mouseX < xPos + width_flipButton/2 &&
         mouseY > 780.0/800.0 * height - height_flipButton /2 && mouseY < 780.0/800.0 * height + height_flipButton/2){
       setFlip();    
     }
   }
   
   boolean mouseInTilteButton(){
     if(mouseX > xPos - width_titleButton/2 && mouseX < xPos + width_titleButton/2 &&
         mouseY > 20.0/800.0 * height - height_titleButton /2 && mouseY < 20.0/800.0 * height + height_titleButton/2){
       return true;
     }
     else{
       return false;
     }
   }
   
   void display(int order){
     xPos = 100.0/1200.0 * width + order * ((1000.0/1200.0 * width)/(this.numAxes-1));
     if(isSelect){
       xPos = mouseX; 
       tempX = mouseX;
       formerSelected = true;
     }
     else if(formerSelected){
       xPos = tempX;
     }
     stroke(255);
     strokeWeight(1);
     textAlign(CENTER);
     float textPercentage = (width/1200.0 + height/800.0)/2.0;
     float textSize = 16 * textPercentage;
     textFont(fontInfo, textSize);
     fill(255);
     
     //line
     line(xPos, 50.0/800.0 * height, xPos, 750.0/800.0 * height);
     
     //title and title button for moving the axis
     if(mouseX > xPos - width_titleButton/2 && mouseX < xPos + width_titleButton/2 &&
         mouseY > 20.0/800.0 * height - height_titleButton /2 && mouseY < 20.0/800.0 * height + height_titleButton/2){
       fill(180);    
     }
     else{
       fill(52,109,241);
     }
     stroke(220);
     rectMode(CENTER);
     rect(xPos, 13.0/800.0 * height, width_titleButton, height_titleButton, 5.0/1200.0 * width);
     fill(255);
     text(nameForColumn, xPos, 20.0/800.0*height);
     
     
     //Max and Min
     textAlign(CENTER);
     textSize(14 * textPercentage);
     text(up.toString(), xPos, 40.0/800.0 * height);
     text(down.toString(), xPos, 765.0/800.0 * height);
     
     //flip button
     if(mouseX > xPos - width_flipButton/2 && mouseX < xPos + width_flipButton/2 &&
         mouseY > 780.0/800.0 * height - height_flipButton /2 && mouseY < 780.0/800.0 * height + height_flipButton/2){
       fill(180);
     }else{
       fill(52,109,241);
     }
     stroke(220);
     rectMode(CENTER);
     rect(xPos, 780.0/800.0 * height, 20.0/1200.0 * width, 20.0/800.0 * height, 3);
     fill(255);
     if(!isFlipped){
       text("+", xPos, 785.0/800.0 * height);
     }else{
       text("-", xPos, 785.0/800.0 * height);
     }
     
     rectMode(CORNER);
     //ends
     line(xPos - (4.0/1200.0 * width), 50.0/800.0 * height, xPos + (4.0/1200.0 * width), 50.0/800.0 * height);
     line(xPos - (4.0/1200.0 * width), 750.0/800.0 * height, xPos + (4.0/1200.0 * width), 750.0/800.0 * height);
     
     //filter
     stroke(220);
     strokeWeight(2);
     fill(220,100);
     //filterRange is the value range for this axis
     
     if(!isFlipped){
       rect(xPos - (4.0/1200.0 * width), 
         50.0/800.0 * height + 700.0/800.0 * height * ((filterRange[0] - min.floatValue())/(max.floatValue()-min.floatValue())), 
         8.0/1200.0 * width,
         700.0/800.0 * height * (filterRange[1] - filterRange[0])/(max.floatValue()-min.floatValue()), 3);
     }else{
       rect(xPos - (4.0/1200.0 * width), 
         50.0/800.0 * height + 700.0/800.0 * height * ((max.floatValue() - filterRange[1])/(max.floatValue()-min.floatValue())), 
         8.0/1200.0 * width,
         700.0/800.0 * height * (filterRange[1] - filterRange[0])/(max.floatValue()-min.floatValue()), 3);
     }
   }
}