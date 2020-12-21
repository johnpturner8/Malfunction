public class Player {
  private int pNum;
  private int x;
  private int y;
  private int oxygen;
  private String id;
  
  public Player(String playerID, int num){
    id = playerID;
    x = 2;
    y = 2;
    pNum = num;
    oxygen = 4;
  }
  
  public void setNum(int num){
    pNum = num;
  }
  
  public int getNum(){
    return pNum;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public void setX(int X){
    x = X;
  }
  
  public void setY(int Y){
    y = Y;
  }
  
  public String getName(){
    return id;
  }
  
  public int getOxygen(){
    return oxygen;
  }
  
  public void loseOxygen(int loss){
    oxygen -= loss;
  }
  
  public void move(int dir){
    if(dir == UP)
      y--;
    if(dir == RIGHT)
      x++;
    if(dir == LEFT)
      x--;
    if(dir == DOWN)
      y++;
  }
}
