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

void setup(){
//  try{
//    weka();
//  }
//  catch(Exception e){};
  boundingHulls = new ArrayList<PVector>();
  
  //SMT and Processing setup
  values = loadJSONArray("cars.json");
//  removeElements();
//  println(values.size());
  size( displayWidth, displayHeight, SMT.RENDERER);
  SMT.init( this, TouchSource.AUTOMATIC);
  CanvasZone canvas = new CanvasZone();
  for(int i=0; i<values.size(); i++){
    JSONObject car = values.getJSONObject(i);
    canvas.add( new CarZone(car.getString("make"), car.getString("num-of-cylinders")));
  }
  SMT.add(canvas);
  zoneLocations = new ArrayList<PVector>();
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
