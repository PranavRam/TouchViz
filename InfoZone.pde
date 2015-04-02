class InfoZone extends Zone {
  public JSONObject data;
  public InfoZone(JSONObject data){
    super( "InfoZone", 0, 0, 150, 150);
    this.data = data;
    
    positionZone();
  }
  
  private void positionZone(){
    this.translate(-50, -130);
  }
  
  @Override
  public void draw(){
    fill(#af8dc3);
    rect(0, 0, 150, 100);
    displayText();
  }
  
  @Override
  
  public void touch() {
  }
  
  void displayText(){
    int currentLoc = 20;
    fill(255);
    text(data.getString("make"), 10,currentLoc*0 + 20);
    text(data.getString("body-style"), 10,currentLoc*1 + 20);
    text(data.getString("drive-wheels"), 10,currentLoc*2 + 20);
    text(data.getString("num-of-doors"), 10,currentLoc*3 + 20);
  }
}
