import megamu.mesh.*;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;
import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;
/**
 * Sketch for Gesture Api
 */

import vialab.SMT.*;

//Setup function for the applet
Hull myHull;

Touch first=null;
boolean assigned = false;
ArrayList<PVector> zoneLocations;
JSONArray values;
ArrayList<PVector> boundingHulls;

public void weka() throws Exception{
    
     // Declare two numeric attributes
     Attribute Attribute1 = new Attribute("firstNumeric");
     Attribute Attribute2 = new Attribute("secondNumeric");
     
     // Declare a nominal attribute along with its values
     FastVector fvNominalVal = new FastVector(3);
     fvNominalVal.addElement("blue");
     fvNominalVal.addElement("gray");
     fvNominalVal.addElement("black");
     Attribute Attribute3 = new Attribute("aNominal", fvNominalVal);
     
     // Declare the class attribute along with its values
     FastVector fvClassVal = new FastVector(2);
     fvClassVal.addElement("positive");
     fvClassVal.addElement("negative");
     Attribute ClassAttribute = new Attribute("theClass", fvClassVal);
     
     // Declare the feature vector
     FastVector fvWekaAttributes = new FastVector(4);
     fvWekaAttributes.addElement(Attribute1);    
     fvWekaAttributes.addElement(Attribute2);    
     fvWekaAttributes.addElement(Attribute3);    
     fvWekaAttributes.addElement(ClassAttribute);
     
     // Create an empty training set
     Instances isTrainingSet = new Instances("Rel", fvWekaAttributes, 10);       
     
     // Set class index
     isTrainingSet.setClassIndex(3);
     
     // Create the instance
     Instance iExample = new Instance(4);
     iExample.setValue((Attribute)fvWekaAttributes.elementAt(0), 1.0);      
     iExample.setValue((Attribute)fvWekaAttributes.elementAt(1), 0.5);      
     iExample.setValue((Attribute)fvWekaAttributes.elementAt(2), "gray");
     iExample.setValue((Attribute)fvWekaAttributes.elementAt(3), "positive");
     
     // add the instance
     isTrainingSet.add(iExample);
     Classifier cModel = (Classifier)new NaiveBayes();   
     cModel.buildClassifier(isTrainingSet);

     // Test the model
     Evaluation eTest = new Evaluation(isTrainingSet);
     eTest.evaluateModel(cModel, isTrainingSet);
     
     // Print the result à la Weka explorer:
     String strSummary = eTest.toSummaryString();
     System.out.println(strSummary);
     
     // Get the confusion matrix
     double[][] cmMatrix = eTest.confusionMatrix();
     for(int row_i=0; row_i<cmMatrix.length; row_i++){
       for(int col_i=0; col_i<cmMatrix.length; col_i++){
         System.out.print(cmMatrix[row_i][col_i]);
         System.out.print("|");
       }
       System.out.println();
     }
  }

void addPieMenu(Touch t){
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

void setup(){
  try{
    weka();
  }
  catch(Exception e){};
  boundingHulls = new ArrayList<PVector>();
  
  //SMT and Processing setup
  values = loadJSONArray("cars.json");
//  removeElements();
//  println(values.size());
  size( displayWidth, displayHeight, SMT.RENDERER);
  SMT.init( this, TouchSource.AUTOMATIC);
  Zone zone = new Zone("Parent",0,0,displayWidth,displayHeight);
  for(int i=0; i<values.size(); i++){
    JSONObject car = values.getJSONObject(i);
    zone.add( new CarZone(car.getString("make"), car.getString("num-of-cylinders")));
  }
  SMT.add(zone);
  
  //Make a new Zone
  //Zone circleZoneOne = new ShapeZone("CircleOne", 300, 200, 30, 30);
  //Zone circleZoneTwo = new ShapeZone("CircleTwo", 600, 400, 30, 30);
  //Zone circleZoneThree = new ShapeZone("CircleThree", 800, 600, 30, 30);
  //SMT.add(circleZoneOne, circleZoneTwo, circleZoneThree);

  float[][] points = new float[3][2];
      
points[0][0] = 325; // first point, x
points[0][1] = 225; // first point, y
points[1][0] = 625; // second point, x
points[1][1] = 425; // second point, y
points[2][0] = 825; // third point, x
points[2][1] = 625; // third point, y
zoneLocations = new ArrayList<PVector>();
myHull = new Hull( points );
}

void removeElements(){
  JSONArray temp = new JSONArray();
  for(int i=0; i<50; i++){
    temp.append(values.getJSONObject(i));
  }
  values = temp;
}

void showBoundingHull(){
  stroke(255);
  beginShape();
  for(PVector t : boundingHulls){
    vertex((int)t.x, (int)t.y);
//    println(boundingHulls.size());
  }
  endShape();
  stroke(0);
}

//Draw function for the sketch
void draw(){
  background( 30);
  zoneLocations.clear();
  showBoundingHull();
  showHullAroundPts();
  if(SMT.getTouches().length>0){
    first=SMT.getTouches()[0];
  }
  //display info on first touch
  if(first==null){
    text("First Touch: Null",100,100);
  }
  else{
    text("First Touch: x:"+first.x+"\ty:"+first.y+" Touch is down:"+(first.isDown?"yes":"no"),100,100);
  }
  //show all current touches too
  text("All Touches: ",100,150);
  int c=0;
  for(Touch t : SMT.getUnassignedTouches()){
    text("Touch ID#"+t.sessionID+"x:"+t.x+"\ty:"+t.y+"Source: "+t.getTouchSource(),100,170+c*20);
    c++;
  }
  
  Zone[] activeZones = SMT.getActiveZones();
  Zone[] allZones = SMT.getZones();
  if(allZones != null && zoneLocations.size()> 0){
    for(Zone z : allZones){
//      text("Zone Locations:"+z.getName()+"--"+z.getX()+":"+z.getY(), 100,170+c*20);
//      c++;
      if(inPolyCheck(new PVector(z.getX()+15, z.getY()+15), zoneLocations)){
        text("Zone Name In Hull:"+z.getName(), 100,170+c*20);
      }
      else {
        text("Zone Name Not In Hull:"+z.getName(), 100,170+c*20);
      }
      c++;
    }
  }
  if(activeZones != null){
    for(Zone z : activeZones){
      if(z instanceof CarZone){
        CarZone cz = (CarZone)z;
        text("Zone Name:"+cz.name, 100,170+c*20);
        c++;
        if(SMT.getUnassignedTouches().length == 2){
          if(!assigned){
            //assigned = true;
            z.unassign(z.getActiveTouch(0));
            SMT.assignTouches(z, SMT.getUnassignedTouches()[0], SMT.getUnassignedTouches()[1]);
          }
        }
      }
    }
  }
  

//  MPolygon myRegion = myHull.getRegion();
//  fill(255, 0, 0);
//  myRegion.draw(this);
  
}

void showHullAroundPts(){
//  MPolygon myRegion = myHull.getRegion();
//  fill(255,0,0);
//  myRegion.draw(this);

  Touch[] allTouches = SMT.getUnassignedTouches();
  if(allTouches.length > 4){
    float[][] pts = new float[allTouches.length][2];
    for(int i = 0; i < allTouches.length; i++){
      pts[i][0] = allTouches[i].x;
      pts[i][1] = allTouches[i].y;
      zoneLocations.add(new PVector(allTouches[i].x, allTouches[i].y));
    }
    
    myHull = new Hull(pts);
    MPolygon myRegion = myHull.getRegion();
    fill(255, 0, 0);
    myRegion.draw(this);
  }
}

void drawCarZone(CarZone zone) {
  fill(zone.carColor);
  rect(0, 0, 30, 30);
}

void touchCarZone(CarZone zone) {
  zone.rst();
}

boolean inPolyCheck(PVector v, ArrayList<PVector> p) {
  float a = 0;
  for (int i =0; i<p.size()-1; ++i) {
    PVector v1 = p.get(i);
    PVector v2 = p.get(i+1);
    a += vAtan2cent180(v, v1, v2);
  }
  PVector v1 = p.get(p.size()-1);
  PVector v2 = p.get(0);
  a += vAtan2cent180(v, v1, v2);
//  if (a < 0.001) println(degrees(a));
 
  if (abs(abs(a) - TWO_PI) < 0.2) return true;
  return false;
}
float vAtan2cent180(PVector cent, PVector v2, PVector v1) {
  PVector vA = v1.get();
  PVector vB = v2.get();
  vA.sub(cent);
  vB.sub(cent);
  vB.mult(-1);
  float ang = atan2(vB.x, vB.y) - atan2(vA.x, vA.y);
  if (ang < 0) ang = TWO_PI + ang;
  ang-=PI;
  return ang;
}

void touchUpForward(){println("Forward");}
void touchUpSubmenu(){println("Submenu");}
void touchUpAdd(){println("Add");SMT.get("PieMenu",PieMenuZone.class).add("Remove Self");}
void touchUpViewSource(){println("View Source");}
void touchUpRemoveSelf(Zone z){println("Remove Self");SMT.get("PieMenu").remove(z);}
void touchUpPieMenu(PieMenuZone m){
  println("Selected: "+m.getSelectedName());
}

void drawParent(Zone zone){
//  background(255);
}
int count=0;
void touchParent(Zone z){ 
   // Check out the gesture example for RST 
   int numTouches = z.getNumTouches();
   Touch active = z.getActiveTouch(numTouches-1);
   if(!(active.getCurrentPoint().x == active.getLastPoint().x && active.getCurrentPoint().y == active.getLastPoint().y)){
     boundingHulls.add(new PVector(active.x, active.y));
   }
   else {
     count++;
   }
//   println(active.getCurrentPoint().x+":"+active.getCurrentPoint().y+" - "+active.getLastPoint().x+":"+active.getLastPoint().y);
     println("Last"+active.getLastPoint());
//   println(active.getTuioTime().getTotalMilliseconds());
//   if(active.getCurrentPoint().x == active.getLastPoint().x && active.getCurrentPoint().y == active.getLastPoint().y) count++;
//   println(count);
   if(count > 10){
//     println("SHOW PIE");
     PieMenuZone m = SMT.get("PieMenu",PieMenuZone.class);
     if(m == null){
       addPieMenu(active);
     }
     count = 0;
   }
//   println(SMT.getTouchesFromZone(z).length);
//   println(SMT.getTouchesFromZone(z)[0].getSessionID());
}
void touchDownParent(Zone z){
  SMT.remove("PieMenu");
   // Check out the gesture example for RST 
//   println(SMT.getTouchesFromZone(z).length);
//   println(SMT.getTouchesFromZone(z)[0].getTuioTime().getTotalMilliseconds() );
}
