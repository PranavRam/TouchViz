class CarZone extends Zone {
  public boolean dead = false;
  public double ani_step = 0;
  public String bodyStyle;
  public color carColor;
  public boolean inHull = false;
  public JSONObject data;
  public CarZone(JSONObject data){
    super( "CarZone", 0, 0, 30, 30);
    this.data = data;
    this.bodyStyle = data.getString("body-style");
    this.carColor = #f0027f;
    if(bodyStyle.equals("wagon")) this.carColor = #beaed4;
    if(bodyStyle.equals("sedan")) this.carColor = #fdc086;
    if(bodyStyle.equals("hatchback")) this.carColor = #ffff99;
    if(bodyStyle.equals("convertible")) this.carColor = #386cb0;
    positionZone();
  }
  
  private void positionZone(){
    int width = displayWidth/5;
    int location = 0;
    if(this.bodyStyle.equals("hardtop")) location = 0;
    else if(this.bodyStyle.equals("wagon")) location = 1;
    else if(this.bodyStyle.equals("sedan")) location = 2;
    else if(this.bodyStyle.equals("hatchback")) location = 3;
    else location = 4;
 
    this.translate(
      random( width - 50),
      random( displayHeight - 100));
    this.translate(location * width, 0);
  }
  
  @Override
  public void draw(){
    fill(carColor);
    rect(0, 0, 30, 30);
    showText();
  }
  
  @Override
  
  public void touch() {
    rst();
  }
  
  @Override
  public void touchUp(Touch t){
    inHull = ((CanvasZone)getParent()).checkAndAddToHull(this);
  }
  
  private void showText(){
    for(Touch t : getTouches()){
      text("Touch ID#"+t.sessionID+"x:"+t.x+"\ty:"+t.y+"Source: "+t.getTouchSource(),100-getLocalX(),170+c*20-getLocalY());
      c++;
    }
    if(inHull){
      text("In Hull "+bodyStyle,100-getLocalX(),170+c*20-getLocalY());
      c++;
    }
  }
  
  public void setInHull(boolean inHull){
//    text("In Hull "+name,100-getLocalX(),170+c*20-getLocalY());
//    c++;
    this.inHull = inHull;
  }
}
