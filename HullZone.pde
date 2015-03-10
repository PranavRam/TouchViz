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
//    drag();
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
  }
  
  boolean pointInside(Vect2 point){
    Vect2[] temp = new Vect2[vertices.size()];
    for(int i=0; i<temp.length; i++){
      temp[i] = vertices.get(i);
    }
    return Space2.insidePolygon(point, temp);
  }
}
