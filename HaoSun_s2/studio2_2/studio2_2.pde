//this code is created based on the discussion with Qitao Xu
//part of code is from https://processing.org/examples/loadsavetable.html
Table dataTable;    //create a table to load data from .csv
int[] heights;      //store the heights in the .csv
String[] names;     //store the names in the .csv
int dataNum;        //store the num of data

void setup(){
  size(600,400);
  loadData();
}

void draw(){
   //draw axis
   stroke(0);
   line(50,50,50,350);
   line(50,350,550,350);
   fill(200,0,0);
   textAlign(CENTER);
   textSize(15);
   text("height",30,200);
   fill(0,0,200);
   text("name", 300, 380);
   
   
   //draw bar chart
   for(int i=0; i<dataNum; i++){
     //println("name " + names[i]);
     //println("height " + heights[i]);
     //bars
     fill(120,20,20);
     rect(60+i*50, 400 - heights[i] - 50, 40, heights[i]);
     textAlign(CENTER);
     textSize(15);
     text(heights[i], 80 + i*50, 400 - heights[i] - 60);
     
     
     //names
     fill(0,0,200);
     textAlign(CENTER);
     textSize(15);
     text(names[i], 80 + i*50, 370);
     
   }
}


void loadData(){
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  dataTable = loadTable("height.csv", "header");
  dataNum = dataTable.getRowCount();
  heights = new int[dataNum];
  names = new String[dataNum];
  println("num of rows" + dataNum);
  // You can access iterate over all the rows in a table
  int rowCount = 0;
  for (TableRow row : dataTable.rows()) {
    // You can access the fields via their column name (or index)
    String name = row.getString("name");
    int height = row.getInt("height");
    names[rowCount] = name;
    heights[rowCount] = height;
    rowCount++;
  }
}