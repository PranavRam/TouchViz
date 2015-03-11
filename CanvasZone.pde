import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

class CanvasZone extends Zone {
  int count=0;
  Data data;
  Touch currentTouch = null;
  ArrayList<Vect2> currentEnclosing;
  HashMap<Long, ArrayList<Touch>> touchTimeMap= new HashMap<Long, ArrayList<Touch>>();
  Map map = Collections.synchronizedMap(touchTimeMap);
  
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
  
  private void showTouchPoints(){
    Set set = map.entrySet();
    synchronized (map) {
        Iterator i = set.iterator();
         // Display elements
        while(i.hasNext()) {
           Map.Entry me = (Map.Entry)i.next();
           ArrayList<Touch> list = (ArrayList<Touch>)me.getValue();
           if(list.size() < 5) continue;
           fill(255);
           for(Touch t : list){
             ellipse(t.getX(), t.getY(),50,50);
           }
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
        }
      }
  }
  
  @Override
  public void draw(){
    c=0;
    checkLongHold();
    showCurrentEnclosing();
    showCarZonesInside();
    showTouchPoints();
  }
  
  @Override
  public void touch() {
  }
  
  private boolean addTouchToCurrentList(ArrayList<Touch> list, Touch t){
    boolean shouldAdd = false;
    long currentStartTouchTime = t.startTime.getTotalMilliseconds();
    for(Touch ct : list){
      long startTouchTime = ct.startTime.getTotalMilliseconds();
      if(Math.abs(startTouchTime - currentStartTouchTime) < 5000){
        shouldAdd = true;
      }
      else {
        shouldAdd = false;
      }
    }
    return shouldAdd;
  }
  
  private void addTouchToMap(Touch t){
    if(touchTimeMap.isEmpty()){
      ArrayList<Touch> temp = new ArrayList<Touch>();
      temp.add(t);
      synchronized (map) {
          Long key = t.getSessionID();
          map.put(key, temp);
      }
    }
    else {
      Set set = map.entrySet();
      boolean addNewEntry = false;
      synchronized (map) {
        Iterator i = set.iterator();
         // Display elements
        while(i.hasNext()) {
           Map.Entry me = (Map.Entry)i.next();
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
             if(addTouchToCurrentList((ArrayList<Touch>)me.getValue(), t)){
               ((ArrayList<Touch>)me.getValue()).add(t);
               addNewEntry = false;
               break;
             }
             else {
               addNewEntry = true;
             }
        }
        if(addNewEntry){
          ArrayList<Touch> temp = new ArrayList<Touch>();
          temp.add(t);
          Long key = t.getSessionID();
          map.put(key, temp);
        }
      }
    }
  }
  
  @Override
  public void touchDown(Touch t){
    int numTouches = getNumTouches();
    currentTouch = getActiveTouch(numTouches-1);
    CarPieMenuZone m = SMT.get("CarPieMenu",CarPieMenuZone.class);
    if(m != null){
      SMT.remove("CarPieMenu");
    }
    addTouchToMap(t);
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
    if(t.getPath().length > 1 && getTouches().length == 1){
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
        CarPieMenuZone m = SMT.get("CarPieMenu",CarPieMenuZone.class);
        if(m == null){
         addPieMenu(currentTouch);
        }
      }
    }
  }
  private void addPieMenu(Touch t){
    SMT.remove("CarPieMenu");
    CarPieMenuZone menu = new CarPieMenuZone((int)t.getX(), (int)t.getY());
    SMT.add(menu);
  }
}
