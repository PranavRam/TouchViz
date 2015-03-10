class HullZone extends ShapeZone {
  ArrayList<Vect2> vertices;
  public HullZone(ArrayList<Vect2> vertices){
    super("HullZone");
    this.vertices = new ArrayList(vertices);
  }
  
  @Override
  public void draw(){
//    noFill();
    fill(255);
    beginShape();
    for(Vect2 v : vertices){
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
//    rect(100,100,300,300);
  }
  
  @Override
  public void touch() {
    rst();
  }
  
  @Override
  public void touchDown(Touch t){
//    println("TOUCHED ME");
  }
  
}
