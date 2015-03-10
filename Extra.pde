//boolean inPolyCheck(PVector v, ArrayList<PVector> p) {
//  float a = 0;
//  for (int i =0; i<p.size()-1; ++i) {
//    PVector v1 = p.get(i);
//    PVector v2 = p.get(i+1);
//    a += vAtan2cent180(v, v1, v2);
//  }
//  PVector v1 = p.get(p.size()-1);
//  PVector v2 = p.get(0);
//  a += vAtan2cent180(v, v1, v2);
////  if (a < 0.001) println(degrees(a));
// 
//  if (abs(abs(a) - TWO_PI) < 0.2) return true;
//  return false;
//}
//float vAtan2cent180(PVector cent, PVector v2, PVector v1) {
//  PVector vA = v1.get();
//  PVector vB = v2.get();
//  vA.sub(cent);
//  vB.sub(cent);
//  vB.mult(-1);
//  float ang = atan2(vB.x, vB.y) - atan2(vA.x, vA.y);
//  if (ang < 0) ang = TWO_PI + ang;
//  ang-=PI;
//  return ang;
//}
//
//
//void showHullAroundPts(){
////  MPolygon myRegion = myHull.getRegion();
////  fill(255,0,0);
////  myRegion.draw(this);
//
//  Touch[] allTouches = SMT.getUnassignedTouches();
//  if(allTouches.length > 4){
//    float[][] pts = new float[allTouches.length][2];
//    for(int i = 0; i < allTouches.length; i++){
//      pts[i][0] = allTouches[i].x;
//      pts[i][1] = allTouches[i].y;
//      zoneLocations.add(new PVector(allTouches[i].x, allTouches[i].y));
//    }
//    
//    myHull = new Hull(pts);
//    MPolygon myRegion = myHull.getRegion();
//    fill(255, 0, 0);
//    myRegion.draw(this);
//  }
//}
//
//Zone[] activeZones = SMT.getActiveZones();
//  Zone[] allZones = SMT.getZones();
//  if(allZones != null && zoneLocations.size()> 0){
//    for(Zone z : allZones){
////      text("Zone Locations:"+z.getName()+"--"+z.getX()+":"+z.getY(), 100,170+c*20);
////      c++;
//      if(inPolyCheck(new PVector(z.getX()+15, z.getY()+15), zoneLocations)){
//        text("Zone Name In Hull:"+z.getName(), 100,170+c*20);
//      }
//      else {
//        text("Zone Name Not In Hull:"+z.getName(), 100,170+c*20);
//      }
//      c++;
//    }
//  }
//  if(activeZones != null){
//    for(Zone z : activeZones){
//      if(z instanceof CarZone){
//        CarZone cz = (CarZone)z;
//        text("Zone Name:"+cz.name, 100,170+c*20);
//        c++;
//        if(SMT.getUnassignedTouches().length == 2){
//          if(!assigned){
//            //assigned = true;
//            z.unassign(z.getActiveTouch(0));
//            SMT.assignTouches(z, SMT.getUnassignedTouches()[0], SMT.getUnassignedTouches()[1]);
//          }
//        }
//      }
//    }
//  }
//  
//  void showBoundingHull(){
//  stroke(255);
//  beginShape();
//  for(PVector t : boundingHulls){
//    vertex((int)t.x, (int)t.y);
////    println(boundingHulls.size());
//  }
//  endShape();
//  stroke(0);
//}

//void touchDownParent(Zone z){ 
   // Check out the gesture example for RST 
   
//   if(!(active.getCurrentPoint().x == active.getLastPoint().x && active.getCurrentPoint().y == active.getLastPoint().y)){
//     boundingHulls.add(new PVector(active.x, active.y));
//   }
//   else {
//     count++;
//   }
////   println(active.getCurrentPoint().x+":"+active.getCurrentPoint().y+" - "+active.getLastPoint().x+":"+active.getLastPoint().y);
//     println("Last"+active.getLastPoint());
////   println(active.getTuioTime().getTotalMilliseconds());
////   if(active.getCurrentPoint().x == active.getLastPoint().x && active.getCurrentPoint().y == active.getLastPoint().y) count++;
////   println(count);
//   if(count > 10){
////     println("SHOW PIE");
//     PieMenuZone m = SMT.get("PieMenu",PieMenuZone.class);
//     if(m == null){
//       addPieMenu(active);
//     }
//     count = 0;
//   }
//   println(SMT.getTouchesFromZone(z).length);
//   println(SMT.getTouchesFromZone(z)[0].getSessionID());
//}

//void touchUpParent(Zone z){
//  SMT.remove("PieMenu");
//  println("Session ID Done: "+currentTouch.getSessionID());
//  count = 0;
   // Check out the gesture example for RST 
//   println(SMT.getTouchesFromZone(z).length);
//   println(SMT.getTouchesFromZone(z)[0].getTuioTime().getTotalMilliseconds() );
//}
