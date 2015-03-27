import point2line.*;

import megamu.mesh.*;
//import weka.classifiers.Classifier;
//import weka.classifiers.Evaluation;
//import weka.classifiers.bayes.NaiveBayes;
//import weka.core.Attribute;
//import weka.core.FastVector;
//import weka.core.Instance;
//import weka.core.Instances;
/**
 * Sketch for Gesture Api
 */

import vialab.SMT.*;

import java.util.Arrays;

//Setup function for the applet
Hull myHull;

Touch first=null;
boolean assigned = false;
ArrayList<PVector> zoneLocations;

int c = 0;

void setup(){
  zoneLocations = new ArrayList<PVector>();
  
  //SMT and Processing setup
  size( displayWidth, displayHeight, SMT.RENDERER);
  SMT.init( this, TouchSource.AUTOMATIC);
  
  CanvasZone canvas = new CanvasZone();
  
  SMT.add(canvas);
//  Set<String> featureSet = new HashSet<String>(new ArrayList<String>(Arrays.asList("color", "legs")));
//
//  NaiveBayes bayes = new NaiveBayes(featureSet, 1.0);
//
//  Map<String, String> zebra = new HashMap<String, String>();
//  zebra.put("color", "black and white");
//  zebra.put("legs",  "four");
//  bayes.insert("zebra", zebra);
//
//  Map<String, String> human = new HashMap<String, String>();
//  human.put("color", "tan");
//  human.put("legs", "two");
//  bayes.insert("human", human);
//
//  Map<String, String> horse = new HashMap<String, String>();
//  horse.put("color", "brown");
//  horse.put("legs",  "four");
//  bayes.insert("horse", horse);
//
//  Map<String, String> penguin = new HashMap<String, String>();
//  penguin.put("color", "black and white");
//  penguin.put("legs", "two");
//  bayes.insert("penguin", penguin);
//
//  Map<String, String> unknown = new HashMap<String, String>();
//  unknown.put("color", "brown");
//  unknown.put("legs", "four");
//
//  Map<String, Double> prediction = bayes.classify(unknown);
//  System.out.println(prediction);
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

//  MPolygon myRegion = myHull.getRegion();
//  fill(255, 0, 0);
//  myRegion.draw(this);
  
}
