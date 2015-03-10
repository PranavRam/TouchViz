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
  
  public void addTo(Zone zone){
    for(int i=0; i<values.size(); i++){
      JSONObject car = values.getJSONObject(i);
      zone.add( new CarZone(car.getString("make"), car.getString("num-of-cylinders")));
    }
  }
}
