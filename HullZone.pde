class HullZone extends ShapeZone {
  Vector<Vect2> vertices;
  Vector<CarZone> carZones;
  public HullZone(Vector<Vect2> vertices){
    super("HullZone");
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
  
  void addCarZone(CarZone cz){
    for(CarZone current : this.carZones){
      if(cz.hashCode() == current.hashCode()) return;
    }
    this.carZones.add(cz);
//    println(carZones.size());
  }
  
  void removeCarZone(CarZone cz){
    Iterator i = this.carZones.iterator();
    while(i.hasNext()){
      CarZone current = (CarZone)i.next();
      if(current.hashCode() == cz.hashCode()){
        i.remove();
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
