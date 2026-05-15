Table table;

String col1 = "Time (seconds)";
String col2 = "Total Energy (joules)";
String col3 = "Percent Energy Conserved";
String col4 = "Length Error (meters)";

void setupTable() {
  table = new Table();
  
  table.addColumn(col1);
  table.addColumn(col2);
  table.addColumn(col3);
  table.addColumn(col4);
}

void addTableRow(float time, float energy, float percentConserved, float lengthError) {
  TableRow newRow = table.addRow();
  newRow.setFloat(col1, time);
  newRow.setFloat(col2, energy);
  newRow.setFloat(col3, percentConserved);
  newRow.setFloat(col4, lengthError);
}
