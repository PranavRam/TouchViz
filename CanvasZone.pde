class CanvasZone extends Zone {
  int count=0;
  Touch currentTouch = null;
  public CanvasZone(){
    super( "CanvasZone",0,0,displayWidth,displayHeight);
  }
  
  @Override
  public void draw(){
    checkLongHold();
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
