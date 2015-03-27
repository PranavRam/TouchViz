import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;
import java.util.*;

class CanvasZone extends Zone {
  int count=0;
  int zoneId = 0;
  Data data;
  Touch currentTouch = null;
  Vector<Vect2> currentEnclosing;
  HashMap<Long, Vector<Touch>> touchTimeMap= new HashMap<Long, Vector<Touch>>();
  Map map = Collections.synchronizedMap(touchTimeMap);
  NaiveBayes bayes;
  
  private void setUpClassifier(){
    Set<String> featureSet = new HashSet<String>(new ArrayList<String>(Arrays.asList("make", "fuel-type", "num-of-doors", "body-style", "drive-wheels", "engine-location")));

    bayes = new NaiveBayes(featureSet, 1.0);
  
//    Map<String, String> human = new HashMap<String, String>();
//    human.put("color", "tan");
//    human.put("legs", "two");
//    bayes.insert("human", human);
//  
//    Map<String, String> horse = new HashMap<String, String>();
//    horse.put("color", "brown");
//    horse.put("legs",  "four");
//    bayes.insert("horse", horse);
//  
//    Map<String, String> penguin = new HashMap<String, String>();
//    penguin.put("color", "black and white");
//    penguin.put("legs", "two");
//    bayes.insert("penguin", penguin);
//  
//    Map<String, String> unknown = new HashMap<String, String>();
//    unknown.put("color", "brown");
//    unknown.put("legs", "four");
//  
//    Map<String, Double> prediction = bayes.classify(unknown);
//    System.out.println(prediction);
  }
  
  
  public CanvasZone(){
    super( "CanvasZone",0,0,displayWidth,displayHeight);
    currentEnclosing = new Vector<Vect2>();
    data = new Data("cars.json");
    addData();
    setUpClassifier();
  }
  
  private void addData(){
    for(int i=0; i<data.values.size(); i++){
      JSONObject car = data.values.getJSONObject(i);
      this.add( new CarZone(car));
    }
  }
  
  public boolean checkAndAddToHull(CarZone cz){
    for(Zone hz : SMT.getZones()){
      if(hz instanceof HullZone){
        if(((HullZone)hz).pointInside(new Vect2(cz.getLocalX()+15, cz.getLocalY()+15))){
          ((HullZone)hz).addCarZone(cz);
          return true;
        }
        else{
          ((HullZone)hz).removeCarZone(cz);
        }
      }
    }
    return false;
  }
  
  private void trainClassifier(CarZone cz){

    Map<String, String> car = new HashMap<String, String>();
    car.put("make", cz.data.getString("make"));
    car.put("fuel-type",  cz.data.getString("fuel-type"));
    car.put("num-of-doors",  cz.data.getString("num-of-doors"));
    car.put("body-style",  cz.data.getString("body-style"));
    car.put("drive-wheels",  cz.data.getString("drive-wheels"));
    car.put("engine-location",  cz.data.getString("engine-location"));
    
//    println(cz.data.getString("make"));
    bayes.insert(Integer.toString(zoneId), car);
  }
  
  
  private void printClassifications(){
    int yes = 0;
    int no = 0;
    for(Zone cz : SMT.getZones()){
      if(cz instanceof CarZone){
        JSONObject data = ((CarZone)cz).data;
        Map<String, String> car = new HashMap<String, String>();
        car.put("make", data.getString("make"));
        car.put("fuel-type",  data.getString("fuel-type"));
        car.put("num-of-doors",  data.getString("num-of-doors"));
        car.put("body-style",  data.getString("body-style"));
        car.put("drive-wheels",  data.getString("drive-wheels"));
        car.put("engine-location",  data.getString("engine-location"));
        
        Map<String, Double> prediction = bayes.classify(car);
        System.out.println(prediction);
//        if(prediction.isEmpty()) no++;
//        else yes++;
      }
    }
    println(yes+":"+no);
  }
  private void checkInHulls(Zone cz){    
    for(Zone hz : SMT.getZones()){
      if(hz instanceof HullZone){
        if(((HullZone)hz).pointInside(new Vect2(cz.getLocalX()+15, cz.getLocalY()+15))){
          ((CarZone)cz).setInHull(true);
          ((HullZone)hz).addCarZone((CarZone)cz);
          trainClassifier((CarZone)cz);
          break;
        }
        else{
          ((HullZone)hz).removeCarZone((CarZone)cz);
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
    printClassifications();
  }
  
  private void showTouchPoints(){
    Set set = map.entrySet();
    synchronized (map) {
        Iterator i = set.iterator();
         // Display elements
        while(i.hasNext()) {
           Map.Entry me = (Map.Entry)i.next();
           Vector<Touch> list = (Vector<Touch>)me.getValue();
           if(list.size() < 5) continue;
           fill(255);
           beginShape();
           for(Touch t : list){
//             ellipse(t.getX(), t.getY(),50,50);
              vertex(t.getX(), t.getY());
           }
           endShape(CLOSE);
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
        }
      }
  }
  
  @Override
  public void draw(){
    c=0;
//    checkLongHold();
    showCurrentEnclosing();
//    showCarZonesInside();
    showTouchPoints();
  }
  
  @Override
  public void touch() {
  }
  
  private float[][] getFloatPoints(Vector<Touch> touchPoints){
    float[][] points = new float[touchPoints.size()][2];
    for(int i=0; i<touchPoints.size(); i++){
      points[i][0] = touchPoints.get(i).getX();
      points[i][1] = touchPoints.get(i).getY();
    }
    return points;
  }
  
  private void reorderTouchPoints(Vector<Touch> touchPoints, Map.Entry entry){
    float[][] pointsToFloat = getFloatPoints(touchPoints);
    Hull myHull = new Hull( pointsToFloat );
    int[] extrema = myHull.getExtrema();
//    println( extrema );
    Vector<Touch> temp = new Vector<Touch>();
    for(int i=0; i<touchPoints.size(); i++){
      temp.add(touchPoints.get(extrema[i]));
    }
    entry.setValue(temp);
//    touchPoints = temp;
  }
  
  private boolean addTouchToCurrentList(Vector<Touch> list, Touch t){
    boolean shouldAdd = false;
    long currentStartTouchTime = t.startTime.getTotalMilliseconds();
    for(Touch ct : list){
      long startTouchTime = ct.startTime.getTotalMilliseconds();
      if(Math.abs(startTouchTime - currentStartTouchTime) < 2000){
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
      Vector<Touch> temp = new Vector<Touch>();
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
             if(addTouchToCurrentList((Vector<Touch>)me.getValue(), t)){
               ((Vector<Touch>)me.getValue()).add(t);
               reorderTouchPoints((Vector<Touch>)me.getValue(), me);
               addNewEntry = false;
               break;
             }
             else {
               addNewEntry = true;
             }
        }
        if(addNewEntry){
          Vector<Touch> temp = new Vector<Touch>();
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
  
  private void clearInActiveTouches(){
    Set set = map.entrySet();
    synchronized (map) {
      Iterator i = set.iterator();
       // Display elements
      while(i.hasNext()) {
         Map.Entry me = (Map.Entry)i.next();
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
         Vector<Touch> temp = (Vector<Touch>)me.getValue();
         Iterator j = temp.iterator();
         while(j.hasNext()){
           Touch current = (Touch)j.next();
           if(!current.isAssigned()){
             j.remove();
           }
         }
      }
    }
  }
  
  @Override
  public void touchUp(Touch t){
    count = 0;
    if(shouldAddHull()){
//      println("ADD THAT HULL!");
      this.add(new HullZone(currentEnclosing, zoneId));
      putCarZoneOnTop();
      showCarZonesInside();
      zoneId++;
    }
    synchronized(this.currentEnclosing){
      currentEnclosing.clear();
    }
    clearInActiveTouches();
  }
  
  @Override
  public void touchMoved(Touch t){
    addMovedTouchPoints(t);
//    if(t.getPath().length > 1 && getTouches().length == 1){
////    if(t.getSessionID() == currentTouch.getSessionID() && t.getLastPoint() == null){
//      println("MOVED: "+t.getX()+":"+t.getY());
//      println(t.getLastPoint());
//      currentEnclosing.add(new Vect2(t.getX(), t.getY()));
//      }
//    }
  }
  
  private void addMovedTouchPoints(Touch touch){
    Set set = map.entrySet();
    synchronized (map) {
      Iterator i = set.iterator();
       // Display elements
      while(i.hasNext()) {
         Map.Entry me = (Map.Entry)i.next();
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
         Vector<Touch> temp = (Vector<Touch>)me.getValue();
         if(temp.size() == 1 && touch.getSessionID() == temp.get(0).getSessionID()){
           Touch t = temp.get(0);
           if(t.getPath().length > 10){
             currentEnclosing.add(new Vect2(t.getX(), t.getY()));
           }
         }
      }
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
    synchronized(this.currentEnclosing){
      if(currentEnclosing == null || currentEnclosing.size() < 5) return false;
      
      Vect2 first = new Vect2(currentEnclosing.get(0));
      Vect2 second = new Vect2(currentEnclosing.get(currentEnclosing.size()-1));
  //    println(currentEnclosing.size());
      return Vect2.distance(first, second) < 60;
    }
  }
  
  private void showCurrentEnclosing(){
    synchronized(this.currentEnclosing){
      stroke(255);
      beginShape(LINES);
      for(Vect2 pv : currentEnclosing){
        vertex(pv.x, pv.y);
      }
      endShape();
      stroke(0);
    }
  }
  
  private void checkLongHold(){
    Set set = map.entrySet();
    synchronized (map) {
      Iterator i = set.iterator();
       // Display elements
      while(i.hasNext()) {
         Map.Entry me = (Map.Entry)i.next();
//           System.out.print(me.getKey() + ": ");
//           System.out.println(me.getValue());
         Vector<Touch> temp = (Vector<Touch>)me.getValue();
         if(temp.size() == 1){
           Long time = temp.get(0).currentTime.getTotalMilliseconds() - temp.get(0).startTime.getTotalMilliseconds();
//            println(time);
            if(time > 1000 && carZoneActive()){
      //        println("ACTIVE");
              CarPieMenuZone m = SMT.get("CarPieMenu",CarPieMenuZone.class);
              if(m == null){
               addPieMenu(temp.get(0));
              }
            }
         }
      }
    }
//    if(currentTouch != null && currentTouch.isAssigned()){
//      Long time = currentTouch.currentTime.getTotalMilliseconds() - currentTouch.startTime.getTotalMilliseconds();
//      println(time);
//      if(time > 1000 && carZoneActive()){
////        println("ACTIVE");
//        CarPieMenuZone m = SMT.get("CarPieMenu",CarPieMenuZone.class);
//        if(m == null){
//         addPieMenu(currentTouch);
//        }
//      }
//    }
  }
  private void addPieMenu(Touch t){
    SMT.remove("CarPieMenu");
    CarPieMenuZone menu = new CarPieMenuZone((int)t.getX(), (int)t.getY());
    SMT.add(menu);
  }
  
  private boolean carZoneActive(){
    for(Zone z : SMT.getActiveZones()){
      if(z instanceof CarZone) return true;
    }
    
    return false;
  }
}
