public class Room {
  private final int MAX_OXYGEN = 4; 
  
  private int id;
  private String name;
  private boolean breach;
  private int position;
  private boolean fixed;
  private int oxygenLoss;
  private int x;
  private int y;
  private boolean spread;

  public Room(int num, int pos){
    id = num;
    breach = false;
    fixed = false;
    position = pos;
    oxygenLoss = 0;
    switch(id){
      case 0:
        name = "Passenger Quarters";
        break;
      case 1:
        name = "Passenger Quarters";
        break;
      case 2:
        name = "Security AI Core";
        break;
      case 3:
        name = "Air Control AI Core";
        break;
      case 4:
        name = "Pilot AI Core";
        break;
      case 5:
        name = "Air Purifier";
        break;
      case 6:
        name = "Power Storage";
        break;
      case 7:
        name = "Pod Launch Bay";
        break;
      case 8:
        name = "Engine Room";
        break;
      case 9:
        name = "Matter Synthesizer";
        break;
      case 10:
        name = "Airlock 1";
        break;
      case 11:
        name = "Airlock 2";
        break;
      case 12:
        name = "Drone Bay";
        break;
      case 13:
        name = "Generator Room";
        break;
      case 14:
        name = "Medical Bay";
        break;
      case 15:
        name = "Kitchen";
        break;
      case 16:
        name = "Water Purifier";
        break;
      case 17:
        name = "Cargo Bay 1";
        break;
      case 18:
        name = "Cargo Bay 2";
        break;
      case 19:
        name = "Cargo Bay 3";
        break;
    }
    switch(position){
      case 1:
        x = 2;
        y = 0;
        break;
      case 2:
        x = 1;
        y = 1;
        break;
      case 3:
        x = 2;
        y = 1;
        break;
      case 4:
        x = 3;
        y = 1;
        break;
      case 5:
        x = 1;
        y = 2;
        break;
      case 6:
        x = 3;
        y = 2;
        break;
      case 7:
        x = 0;
        y = 3;
        break;
      case 8:
        x = 1;
        y = 3;
        break;
      case 9:
        x = 3;
        y = 3;
        break;
      case 10:
        x = 4;
        y = 3;
        break;
      case 11:
        x = 0;
        y = 4;
        break;
      case 12:
        x = 1;
        y = 4;
        break;
      case 13:
        x = 2;
        y = 4;
        break;
      case 14:
        x = 3;
        y = 4;
        break;
      case 15:
        x = 4;
        y = 4;
        break;
      case 16:
        x = 0;
        y = 5;
        break;
      case 17:
        x = 2;
        y = 5;
        break;
      case 18:
        x = 4;
        y = 5;
        break;
      case 19:
        x = 2;
        y = 2;
        break;
      case 20:
        x = 2;
        y = 3;
        break;
    }
  }
  
  public int getID(){
    return id;
  }
  
  public int getPosition(){
    return position;
  }
  
  public int getOxygenLoss(){
    return oxygenLoss;
  }
  
  public int leak(int speed){ //speed - how much oxygen is lost per turn
    spread = true;
    oxygenLoss += speed;
    if(oxygenLoss > MAX_OXYGEN){
      int ret = oxygenLoss - MAX_OXYGEN; //excess oxygen loss is returned 
      oxygenLoss = MAX_OXYGEN;
      return ret;
    }
    return 0;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public String getName(){
    return name;
  }
  
  public boolean isFixed(){
    return fixed;
  }
  
  public boolean isBreach(){
    return breach;
  }
  
  public void breach(){
    breach = true;
  }
  
  public void repair(){
    breach = false;
  }
  
  public void fix(){
    fixed = true;
  }
  
  public boolean spread(){
    return spread;
  }
  
  public void resetSpread(){
    spread = false;
  }
}
