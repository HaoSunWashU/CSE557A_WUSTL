//adapted and fixed from github
class DataReader {
  Table table;
  int numRows, numColumns;
  String[] namesForColumns;  //first rows except first one
  String[] namesForRows;       //first column
  
  //because data will be int or float in different columns, so in this class,
  //I use hashMap to shore the data of each column based on int or float.
  
  DataReader(String dataPath){
    table = loadTable(dataPath, "header");
    //table = loadTable("data.csv", "header");
    //remove non-numeric data columns
    for(int i = 1; i < table.getColumnCount(); i++) {
      Character c = new Character((table.getString(0, i).charAt(0))); // get first character in (0,i)
      if(Character.isLetter(c)){ //If it is not numeric value, remove this column from table
        table.removeColumn(i);
      }
    }
    
    //fetch attributes name from data file, from the second column
    String[] columnTitles = table.getColumnTitles();
    namesForColumns = new String[table.getColumnCount()-1];
    for(int i = 1; i < table.getColumnCount(); i++){
      namesForColumns[i-1] = columnTitles[i];
    }
    
    //get names for rows
    namesForRows = table.getStringColumn(0);
    numRows = namesForRows.length;
    numColumns = namesForColumns.length;
  }
  
  //get functions
  String[] getNamesForColumns(){return namesForColumns;}
  String[] getNamesForRows(){return namesForRows;}
  int getNumColumns(){
    return numColumns;
  }
  int getNumRows(){
    return numRows;
  }
  //construct hashmap for name and value in some column
  HashMap<String, Number> getColumnData(int column){
    
    HashMap<String, Number> columnData = new HashMap<String, Number>();
    
    //check the data type, by checking if there is . in string data in the column
    String[] stringData = table.getStringColumn(column);
    String allStringData = "";
    for(String currentString : stringData) {
      allStringData += currentString; 
    }
    
    if(allStringData.contains(".")){ //data is float
      for(int i = 0; i < table.getRowCount(); i++){
        //hashMap (name, value) in this column (float)
        columnData.put(table.getString(i, 0), table.getFloat(i, column));
      }
    }else{    //data is int
      for(int i = 0; i < table.getRowCount(); i++){
        //hashMap (name, value) in this column (int)
        columnData.put(table.getString(i, 0), table.getInt(i, column));
      }
    }
    return columnData;
  }
}