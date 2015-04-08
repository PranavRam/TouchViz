class HullZone extends ShapeZone {
  Vector<Vect2> vertices;
  Vector<CarZone> carZones;
  int id;
  
  public HullZone(Vector<Vect2> vertices, int id){
    super("HullZone");
    this.id = id;
    this.vertices = new Vector(vertices);
    this.carZones = new Vector<CarZone>();
  }
  
  @Override
  public void draw(){
//    noFill();
    fill(#7fc97f);
    beginShape();
    for(Vect2 v : vertices){
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
//    rect(100,100,300,300);
  }
  
  @Override
  public void touch() {
    drag();
  }
  
  @Override
  public void touchDown(Touch t){
//    println("TOUCHED ME");
  }
  
  @Override
  public void touchUp(Touch t){
  }
  
  @Override
  public void translate( float x, float y){
//    super.translate(x, y);
    for(Vect2 v : vertices){
      v.add(new Vect2(x,y));
    }
    for(CarZone cz : carZones){
      cz.translate(x, y);
    }
  }
  
  void syncWithFirebase(){
    Firebase firebaseHullRef = myFirebaseRef.child("hullZones");
    HashMap<String,HashMap<String, String>> temp = new HashMap<String, HashMap<String, String>>();
    for(CarZone cz : this.carZones){
      temp.put(Integer.toString(cz.hashCode()), cz.getCarDetails());
    }
    firebaseHullRef.child(Integer.toString(id)).setValue(temp);
  }

  void addCarZone(CarZone cz){
    for(CarZone current : this.carZones){
      if(cz.hashCode() == current.hashCode()) return;
    }
    this.carZones.add(cz);
    ((CanvasZone)getParent()).retrainClassifier();
    syncWithFirebase();
    // String col = colorMap.get(id);
    // col = "FF" + col.substring(1);
    // cz.carColor = unhex(col);
//    println(carZones.size());
  }
  
  void removeCarZone(CarZone cz){
    Iterator i = this.carZones.iterator();
    while(i.hasNext()){
      CarZone current = (CarZone)i.next();
      if(current.hashCode() == cz.hashCode()){
        i.remove();
        syncWithFirebase();
      }
    }
  }
  
  boolean pointInside(Vect2 point){
    Vect2[] temp = new Vect2[vertices.size()];
    for(int i=0; i<temp.length; i++){
      temp[i] = vertices.get(i);
    }
    return Space2.insidePolygon(point, temp);
  }
}
