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
Data data;
int c = 0;

void setup(){
  boundingHulls = new ArrayList<PVector>();
  zoneLocations = new ArrayList<PVector>();
  data = new Data("cars.json");
  
  //SMT and Processing setup
  size( displayWidth, displayHeight, SMT.RENDERER);
  SMT.init( this, TouchSource.AUTOMATIC);
  
  CanvasZone canvas = new CanvasZone();
  data.addTo(canvas);
  SMT.add(canvas);
}

void showFirstTouch(){
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
}

//Draw function for the sketch
void draw(){
  background( 30);
  zoneLocations.clear();
//  showBoundingHull();
//  showHullAroundPts();
  showFirstTouch();
  //show all current touches too
  text("All Touches: ",100,150);
  c=0;

//  MPolygon myRegion = myHull.getRegion();
//  fill(255, 0, 0);
//  myRegion.draw(this);
  
}
