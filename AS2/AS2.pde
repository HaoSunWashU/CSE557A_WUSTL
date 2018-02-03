//Canvas intformation for chart
int xCenter;
int yCenter;
int widthSize;
int heightSize;
PFont fontInfo;

//Data information
Table dataTable;                    //create a table to load data from .csv
String fileName = "data_1.csv";     //fileName stores the name of data source
int count;                          //store the num of data
String[] dataNames;                 //name of first column
float[] dataNums;                   //populations of different distributions
String[] titles;                    //titles of first row in .csv
float maxNum = 0.0;                 //store the max population
float dataSum = 0.0;                //store the sum of date num
boolean[] isSelected;               //indicate which data is selected
String chartTitle = "Population distributions";       //title of chart

//position informaiton for bar chart
float[] heights;
float barWidth;
float[] xPos;
float[] yPos;

//position information for line chart

//position information for pie chart
float[] directions;                  //direction angle for each part
float[] xPosPie;
float[] yPosPie;

//Colors of pie

//Current chart statement
boolean bar = true;                  
boolean line = false;

//Chart transition statement
int currentChartMode = 0;            //current chart mode 0 : bar chart; 1 : line chart; 2: pie chart
int whichButton = 0;                 //indicate which button the mouse is on. 0 for nothing, 1,2,3 for three buttons
boolean barToLine = false;           //The following variables are used to judge chart transition action
boolean barToPie = false;
boolean lineToBar = false;
boolean lineToPie = false;
boolean pieToBar = false;
boolean pieToLine = false;
  
//initialize canvas
void setup(){
  size(1200,800);
  //size of center canvas for chart display
  xCenter = 600;
  yCenter = 400;
  widthSize = 1000;
  heightSize = 600;
  smooth();
  surface.setResizable(true);
  background(120);
  
  //Load data from .csv file and store the data into dataNames and dataNums
  loadData();                      
  updatePositionInformationForBar(); //update position information for Bar Chart
  chartTitle = "Population distribution";
  fontInfo = createFont("Georgia", 16, true);
}

void draw(){
  //refresh the canvas
  //clear();
  //background(120);
  surface.setResizable(true);
  rectMode(CENTER);
  fill(230);
  rect(xCenter, yCenter, widthSize, heightSize, 1);
  textFont(fontInfo, 38);
  fill(250);
  textAlign(CENTER);
  text(chartTitle, 300, 50);
  
  //if current chart mode is bar chart or line chart, draw the following text
  if(currentChartMode!=2){
    pushMatrix(); //push current transformation setting into matrix for later use
    //modify transform
    translate(0.05* width, 0.5 * height);
    rotate(3 * PI / 2);
    textFont(fontInfo, 20);
    text(titles[1], 0, 0);
    popMatrix();  //pop former transform
    text(titles[0], 0.5*width, 0.95*height);
  }
  
  //draw three buttons : 1. Bar Chart; 2. Line Chart; 3. Pie Chart.
  
  
}

void loadData(){
  //load first row of the data.csv
  String[] data = loadStrings(fileName);
  titles = split(data[0], ",");
  //load data from CSV file into a Table Object
  // "header" option indicates the file has a header row
  dataTable = loadTable(fileName,"header");
  count = dataTable.getRowCount();
  dataNames = new String[count];
  dataNums = new float[count];
  
  //iterate over all the rows in a table
  int rowCount = 0;
  for(TableRow row : dataTable.rows()){
    //you can access the fields via their column name (or index)
    String name = row.getString(titles[0]);
    int num = row.getInt(titles[1]);
    dataNames[rowCount] = name;
    dataNums[rowCount] = num;
    rowCount++;
    dataSum += num;
    if(num>maxNum){
      maxNum = num;
    }
  }
  //debug
  println("num of rows: " + count);
  println("title: " + titles[0] + ", " + titles[1]);
  println("First row of data: " + dataNames[0] + ", " + dataNums[0]);
  println("The max num is: " + maxNum);
  println("The sum is: " + dataSum);
}

void updatePositionInformationForBar(){
  heights = new float[count];
  xPos = new float[count];
  yPos = new float[count];
  directions = new float[count];
  barWidth = widthSize/(2.0 * count + 1);
  for(int i = 0; i < count; i++){
    //ratioToMaxNum is designed to adjust the height of each bar
    float ratioToMaxNum = dataNums[i] / maxNum;
    heights[i] = 0.8 * heightSize * ratioToMaxNum; //80% zoom
    //(xCenter - widthSize/2) is the left margin
    xPos[i] = (xCenter - widthSize/2) + barWidth + (2 * i * barWidth);
    yPos[i] = (yCenter - heightSize/2) + heightSize - heights[i];
    directions[i] = 360.0 * dataNums[i] / dataSum; //computer direction angle for pie chart
  }
}
void mouseOnWhichButton(){
  
}

void mousePressed(){
  mouseOnWhichButton();
  switch(whichButton){
    case 0: break;
    case 1: break;
    case 2: break;
    case 3: break;
  }
  
  
}