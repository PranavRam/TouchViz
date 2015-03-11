class CarPieMenuZone extends PieMenuZone{

  public CarPieMenuZone(int x, int y){
    super("CarPieMenu", 200, x, y);
//    add("Features",loadImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE_lpEhrobnGhxrMyF6TFLUuAcVpGJixDzak4TxVQjjiDW5UjF", "png"));
    add("Submenu");
    add("Features");
//    add("View Source");
//    setDisabled("View Source",true);
    add("Remove Self");
  }
  
  void touchUpForward(){println("Forward");}
  void touchUpSubmenu(){println("Submenu");}
  void touchUpFeatures(){println("Add");SMT.get("PieMenu",PieMenuZone.class).add("Remove Self");}
  void touchUpViewSource(){println("View Source");}
  void touchUpRemoveSelf(Zone z){println("Remove Self");SMT.get("PieMenu").remove(z);}
  void touchUpPieMenu(PieMenuZone m){
    println("Selected: "+m.getSelectedName());
  }
}
