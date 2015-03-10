class CanvasZone extends Zone {
  int count=0;
  Data data;
  Touch currentTouch = null;
  ArrayList<Vect2> currentEnclosing;
  
  public CanvasZone(){
    super( "CanvasZone",0,0,displayWidth,displayHeight);
    currentEnclosing = new ArrayList<Vect2>();
    data = new Data("cars.json");
    addData();
  }
  
  private void addData(){
    for(int i=0; i<data.values.size(); i++){
      JSONObject car = data.values.getJSONObject(i);
      this.add( new CarZone(car.getString("make"), car.getString("num-of-cylinders")));
    }
  }
  
  private void checkInHulls(Zone cz){    
    for(Zone hz : SMT.getZones()){
      if(hz instanceof HullZone){
        if(((HullZone)hz).pointInside(new Vect2(cz.getLocalX(), cz.getLocalY()))){
          ((CarZone)cz).setInHull(true);
          break;
        }
        else{
          ((CarZone)cz).setInHull(false);
        }
      }
    }
  }
  
  private void showCarZonesInside(){
    for(Zone z : SMT.getZones()){
      if(z instanceof CarZone){
        checkInHulls(z);
      }
    }
  }
  
  @Override
  public void draw(){
    c=0;
    checkLongHold();
    showCurrentEnclosing();
    showCarZonesInside();
  }
  
  @Override
  public void touch() {
  }
  
  @Override
  public void touchDown(Touch t){
    int numTouches = getNumTouches();
    currentTouch = getActiveTouch(numTouches-1);
    PieMenuZone m = SMT.get("PieMenu",PieMenuZone.class);
    if(m != null){
      SMT.remove("PieMenu");
    }
  }
  
  @Override
  public void touchUp(Touch t){
    count = 0;
    if(shouldAddHull()){
//      println("ADD THAT HULL!");
      this.add(new HullZone(currentEnclosing));
      putCarZoneOnTop();
    }
    currentEnclosing.clear();
  }
  
  @Override
  public void touchMoved(Touch t){
    if(t.getPath().length > 1){
//    if(t.getSessionID() == currentTouch.getSessionID() && t.getLastPoint() == null){
//      println("MOVED: "+t.getX()+":"+t.getY());
//      println(t.getLastPoint());
      currentEnclosing.add(new Vect2(t.getX(), t.getY()));
    }
  }
  
  
  private void putCarZoneOnTop(){
    for(Zone z : SMT.getZones()){
      if(z instanceof CarZone){
        putChildOnTop(z);
      }
    }
  }
  
  private boolean shouldAddHull(){
    if(currentEnclosing == null || currentEnclosing.size() < 5) return false;
    
    Vect2 first = new Vect2(currentEnclosing.get(0));
    Vect2 second = new Vect2(currentEnclosing.get(currentEnclosing.size()-1));
//    println(currentEnclosing.size());
    return Vect2.distance(first, second) < 60;
  }
  
  private void showCurrentEnclosing(){
    stroke(255);
    beginShape(LINES);
    for(Vect2 pv : currentEnclosing){
      vertex(pv.x, pv.y);
    }
    endShape();
    stroke(0);
  }
  
  private void checkLongHold(){
    if(currentTouch != null && currentTouch.isAssigned()){
      count++;
      if(count > 10 && currentTouch.getLastPoint() == null){
        PieMenuZone m = SMT.get("PieMenu",PieMenuZone.class);
        if(m == null){
         addPieMenu(currentTouch);
        }
      }
    }
  }
  private void addPieMenu(Touch t){
    SMT.remove("PieMenu");
    PieMenuZone menu = new PieMenuZone("PieMenu", 200, (int)t.getX(), (int)t.getY());
    SMT.add(menu);
    menu.add("Forward",loadImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE_lpEhrobnGhxrMyF6TFLUuAcVpGJixDzak4TxVQjjiDW5UjF", "png"));
    menu.add("Submenu");
    menu.add("Add");
    menu.add("View Source");
    menu.setDisabled("View Source",true);
    menu.add("Remove Self");
  }
  
  void touchUpForward(){println("Forward");}
  void touchUpSubmenu(){println("Submenu");}
  void touchUpAdd(){println("Add");SMT.get("PieMenu",PieMenuZone.class).add("Remove Self");}
  void touchUpViewSource(){println("View Source");}
  void touchUpRemoveSelf(Zone z){println("Remove Self");SMT.get("PieMenu").remove(z);}
  void touchUpPieMenu(PieMenuZone m){
    println("Selected: "+m.getSelectedName());
  }
}
