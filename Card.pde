public class Card {
  private int id;
  private String name;
  ArrayList<Card> hand = new ArrayList();
  
  public Card(int num){
    id = num;
    switch(id){
      case 0:
        name = "Hull Breach";
        break;
      case 1:
        name = "Metal";
        break;
      case 2:
        name = "Security AI Probe";
        break;
      case 3:
        name = "Air Control AI Probe";
        break;
      case 4:
        name = "Pilot AI Probe";
        break;
    }
  }
  
  public int getID(){
    return id;
  }
}
