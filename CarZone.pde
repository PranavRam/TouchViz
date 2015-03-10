class CarZone extends Zone {
  public boolean dead = false;
  public double ani_step = 0;
  public String name;
  public color carColor;
  public CarZone(String name, String cylinderNum){
    super( "CarZone", 0, 0, 30, 30);
    this.name = name+"-"+cylinderNum;
    this.carColor = #88dd88;
    if(cylinderNum.equals("four")) this.carColor = #FF0000;
    if(cylinderNum.equals("three")) this.carColor = #FF33CC;
    if(cylinderNum.equals("two")) this.carColor = #0099FF;
    this.translate(
      random( displayWidth - 100),
      random( displayHeight - 100));
  }
  
  @Override
  public void draw(){
    fill(carColor);
    rect(0, 0, 30, 30);
    showText();
  }
  
  
  
  @Override
  
  public void touch() {
    rst();
  }
  
  private void showText(){
    int temp = c;
    for(Touch t : getTouches()){
      text("Touch ID#"+t.sessionID+"x:"+t.x+"\ty:"+t.y+"Source: "+t.getTouchSource(),100-getLocalX(),170+c*20-getLocalY());
      c++;
    }
    c = temp;
  }
}
