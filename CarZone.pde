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
    HashMap<String,String> car = getCarDetails();

    myFirebaseRef.child("currentCarZone").setValue(car);
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

  private HashMap<String, String> getCarDetails(){
    HashMap<String,String> car = new HashMap<String, String>();
    car.put("symboling", Float.toString(data.getFloat("symboling")));      
    car.put("normalized-losses",  Float.toString(data.getFloat("normalized-losses")));      
    car.put("make", data.getString("make"));
    car.put("fuel-type", data.getString("fuel-type"));
    car.put("aspiration", data.getString("aspiration"));
    car.put("num-of-doors", data.getString("num-of-doors"));
    car.put("body-style", data.getString("body-style"));
    car.put("drive-wheels", data.getString("drive-wheels"));
    car.put("engine-location", data.getString("engine-location"));
    car.put("wheel-base",  Float.toString(data.getFloat("wheel-base")));
    car.put("length",  Float.toString(data.getFloat("length")));
    car.put("width",  Float.toString(data.getFloat("width")));
    car.put("height",  Float.toString(data.getFloat("height")));
    car.put("curb-weigh",  Float.toString(data.getFloat("curb-weigh")));
    car.put("engine-type", data.getString("engine-type"));
    car.put("num-of-cylinders", data.getString("num-of-cylinders"));
    car.put("engine-size", Float.toString(data.getFloat("engine-size")));
    car.put("fuel-system", data.getString("fuel-system"));
    car.put("bore",  Float.toString(data.getFloat("bore")));
    car.put("stroke",  Float.toString(data.getFloat("stroke")));
    car.put("compression-ratio",  Float.toString(data.getFloat("compression-ratio")));
    car.put("horsepower",  Float.toString(data.getFloat("horsepower")));
    car.put("peak-rpm",  Float.toString(data.getFloat("peak-rpm")));
    car.put("city-mpg",  Float.toString(data.getFloat("city-mpg")));
    car.put("highway-mpg",  Float.toString(data.getFloat("highway-mpg")));
    car.put("price",  Float.toString(data.getFloat("price")));
    return car;
  }
}
