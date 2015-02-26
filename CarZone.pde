class CarZone extends Zone {
  public boolean dead = false;
  public double ani_step = 0;
  public String name;
  public color carColor;
  public CarZone(String name, String cylinderNum){
    super( "CarZone", 0, 0, 30, 30100);
    this.name = name+"-"+cylinderNum;
    this.carColor = #88dd88;
    if(cylinderNum.equals("four")) {
      println(cylinderNum);
      this.carColor = #FF0000;
    }
    this.translate(
      random( displayWidth - 100),
      random( displayHeight - 100));
  }
}
