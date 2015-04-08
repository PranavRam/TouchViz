class CarZone extends Zone {
  public boolean dead = false;
  public double ani_step = 0;
  public String bodyStyle;
  public color carColor;
  public boolean inHull = false;
  public JSONObject data;
  
  InfoZone info;
  boolean showInfo = false;
  public CarZone(JSONObject data){
    super( "CarZone", 0, 0, 40, 40);
    this.data = data;
    this.bodyStyle = data.getString("body-style");
    this.carColor = #386cb0;
//    if(bodyStyle.equals("wagon")) this.carColor = #beaed4;
//    if(bodyStyle.equals("sedan")) this.carColor = #fdc086;
//    if(bodyStyle.equals("hatchback")) this.carColor = #ffff99;
//    if(bodyStyle.equals("convertible")) this.carColor = #386cb0;
    positionZone();
    info = new InfoZone(data);
    this.add(info);
    info.setVisible(false);
    info.setPickable(false);
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
    if(showInfo) fill(#af8dc3);
    rect(0, 0, 40, 40);
    // showText();
  }
  
  @Override
  
  public void touch() {
    rst();
  }
  
  Touch previousTouch = null;
  @Override
  public void touchDown(Touch t) {
    long time = 0;
    if(previousTouch != null){
      // Vect2 currentPoint = new Vect2(t.getX(), t.getY());
      // Vect2 prevPoint = new Vect2(previousTouch.getX(), previousTouch.getY());
      // distance = Vect2.distance(currentPoint, prevPoint);
      // println(distance);
      long prevTime = previousTouch.getTuioTime().getTotalMilliseconds();
      long currentTime = t.getTuioTime().getTotalMilliseconds();
      time = currentTime - prevTime;
    }
    if(previousTouch != null && time < 1000){
      showInfo = !showInfo;
      info.setVisible(showInfo);
      info.setPickable(showInfo);
      this.getParent().putChildOnTop(this);
    }
//    this.getParent().putChildOnTop(info);
    previousTouch = t;
  }
  
  @Override
  public void touchUp(Touch t){
    boolean prevInHull = inHull;
    inHull = ((CanvasZone)getParent()).checkAndAddToHull(this);
    if(prevInHull && !inHull) ((CanvasZone)getParent()).retrainClassifier();
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
