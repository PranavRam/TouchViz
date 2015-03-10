class Data {
  JSONArray values;
  int LIMIT = 50;
  public Data(String file){
    values = loadJSONArray(file);
  }
  
  public void removeElements(){
    JSONArray temp = new JSONArray();
    for(int i=0; i<LIMIT; i++){
      temp.append(values.getJSONObject(i));
    }
    values = temp;
  }
}
