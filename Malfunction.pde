import processing.net.*; 
import java.util.*;
import static javax.swing.JOptionPane.*;

boolean server;
int step = 1;
int inStep = 1;
boolean keyHeld = false;
int port = 5204;

//server variables
Player[] players = new Player[4];
Server s;
ArrayList<Card> deck = new ArrayList();
ArrayList<Card> discard = new ArrayList();
ArrayList<Room> rooms = new ArrayList(); //used for reference
Doors doors = new Doors();
boolean pilotFixed = false;
boolean airFixed = false;
boolean securityFixed = false;
int pTurn = 0;

//player variables
int pNum;
String name;
Client c;
int actions = 3;
int[] hand = {0, 0, 0, 0}; //used to count each type of card, index is id - 1
String pMsg = "";
int givingTo;
int oxygen = 4;

void setup() { 
  fullScreen();
  Random rand = new Random();
  ArrayList<Integer> nums = new ArrayList();
  for (int i = 1; i <= 18; i++) {
    nums.add(i);
  }
  for (int i = 2; i < 20; i++) {
    int pos = nums.remove(rand.nextInt(nums.size()));
    rooms.add(new Room(i, pos));
  }
  rooms.add(new Room(0, 19));
  rooms.add(new Room(1, 20));
  for (int i = 0; i < 16; i++) { //16 metal in deck, changed from 14
    deck.add(new Card(1));
  }
  for (int i = 0; i < 6; i++) { //6 of each probe type in deck
    deck.add(new Card(2));
    deck.add(new Card(3));
    deck.add(new Card(4));
  }
  for (int i = 0; i < 6; i++) { //6 hull breaches, kept separate to easily modify
    deck.add(new Card(0));
  }
  //Shuffling
  Collections.shuffle(deck);
}

void draw() {
  switch(step) {
  case 1:
    title();
    break;
  case 2:
    if (server) {
      serverMain();
    } else {
      playerMain();
    }
    break;
  }
}

void title() {
  background(255);
  fill(0);
  textAlign(CENTER, TOP);
  imageMode(CENTER);
  textSize(width*.05);
  text("Malfunction", width*.5, height*.5);
  textSize(width*0.02);
  text("Run as Server (s) or Player (p)", width*0.5, height*.9);
  if (keyPressed) { 
    if (!keyHeld) {
      keyHeld = true;
      if (key == 'p') {
        server = false;
        step = 2;
        String ip = "";
        while ("".equals(ip)) {
          ip = showInputDialog("Enter IP Address: ");
        }
        c = new Client(this, ip, port);
      } else if (key == 's') {
        server = true;
        s = new Server(this, port);
        step = 2;
      }
    }
  } else {
    keyHeld = false;
  }
}

void serverMain() {
  switch(inStep) {
  case 1:
    c = s.available();
    if (c != null) {
      String input = c.readString(); 
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      if (inputs.length == 2 && inputs[1].equals("NewPlayer")) {
        println("in");
        int rand = (int)(Math.random()*4);
        while (players[rand] != null) {
          rand = (int)(Math.random()*4);
        }
        players[rand] = new Player(inputs[0], rand+1);
        s.write(inputs[0] + ", " + rand + ", Created" + "\n");
        println(inputs[0] + " msg sent");
        if (players[0] != null && players[1] != null && players[2] != null && players[3] != null) {
          inStep++;
        }
      }
    }
    break;
  case 2: //setup
    doorMalfunction();
    doorMalfunction();
    hullBreach();
    println("begin loop");
    for (int i = 0; i < players.length; i++) {
      println("i " + i); 
      giveCards(i);
      drawBoard();
    }
    inStep = 3;
    break;
  case 3: //player step
    boolean lose =  true;
    for (int i = 0; i < players.length; i++) {
      if (players[pTurn].getOxygen() >= 0) {
        lose = false;
      }
    }
    boolean win = true;
    if (pTurn >= players.length) {
      inStep = 5;
      pTurn = 0;
    }
    for (int i = 0; i < rooms.size(); i++) {
      Room r = rooms.get(i);
      if (r.isBreach()) {
        win = false;
      }
      if (r.getID() >= 2 && r.getID() <= 4 && !r.isFixed()) {
        win = false;
      }
    }
    if (lose) {
      inStep = 7;
    } else if (win) {
      inStep = 6;
    } else {
      if (players[pTurn].getOxygen() >= 0) {
        s.write(players[pTurn].getName() + ", " + "go" + ", " +  players[pTurn].getOxygen() + "\n");
        inStep = 4;
      } else {
        pTurn++;
      }
    }
    break;
  case 4: //player step
    c = s.available();
    if (c != null) {
      String input = c.readString(); 
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      if (inputs.length == 3 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("flipDoor")) {
        if (doors.flipper(Integer.parseInt(inputs[2]), players[pTurn])) {
          s.write(players[pTurn].getName() + ", " + "actionDone" + "\n");
        } else {
          s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
        }
      } else if (inputs.length == 5 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("repair")) {
        Room rm = findRoom(players[pTurn].getX(), players[pTurn].getY());
        if (rm != null && !rm.isFixed()) {
          if (rm.getID() == 2 && Integer.parseInt(inputs[2]) >= 4) {
            s.write(players[pTurn].getName() + ", " + "actionDone" + ", " + "1" + "\n");
            rm.fix();
            securityFixed = true;
          } else if (rm.getID() == 3 && Integer.parseInt(inputs[3]) >= 4) {
            s.write(players[pTurn].getName() + ", " + "actionDone" + ", " + "2" + "\n");
            rm.fix();
            pilotFixed = true;
          } else if (rm.getID() == 4 && Integer.parseInt(inputs[4]) >= 4) {
            s.write(players[pTurn].getName() + ", " + "actionDone" + ", " + "3" + "\n");
            rm.fix();
            airFixed = true;
          } else {
            s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
          }
        } else {
          s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
        }
      } else if (inputs.length == 3 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("fix")) {
        Room rm = findRoom(players[pTurn].getX(), players[pTurn].getY());
        if (rm != null && rm.isBreach() && Integer.parseInt(inputs[2])>=4) {
          rm.repair();
          s.write(players[pTurn].getName() + ", " + "actionDone" + "\n");
        } else {
          s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
        }
      } else if (inputs.length == 3 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("move")) {
        int dir = Integer.parseInt(inputs[2]);
        if (Helpers.canMove(dir, players[pTurn], doors)) {
          players[pTurn].move(dir);
          s.write(players[pTurn].getName() + ", " + "actionDone" + "\n");
        } else {
          s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
        }
      } else if (inputs.length == 4 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("give")) {
        if (players[pTurn].getX() == players[Integer.parseInt(inputs[3])-1].getX() && players[pTurn].getY() == players[Integer.parseInt(inputs[3])-1].getY()) {
          String in = "";
          while (!in.equals(players[Integer.parseInt(inputs[3])-1].getName() + ", " + "receivedCard" + "\n")) {
            s.write(players[Integer.parseInt(inputs[3])-1].getName() + ", card, " + (Integer.parseInt(inputs[2])-1) + "\n");
            delay(100);
            c = s.available();
            if (c != null) {
              in = c.readString();
            }
          }
          s.write(players[pTurn].getName() + ", " + "actionDone" + ", " + (Integer.parseInt(inputs[2])-1) + "\n");
        } else {
          s.write(players[pTurn].getName() + ", " + "actionInvalid" + "\n");
        }
      } else if (inputs.length == 2 && players[pTurn].getName().equals(inputs[0]) && inputs[1].equals("done")) {
        inStep = 3;
        giveCards(pTurn);
        pTurn++;
        if (pTurn >= players.length) {
          pTurn = 0;
          inStep = 5;
        }
        players[pTurn].loseOxygen(findRoom(players[pTurn].getX(), players[pTurn].getY()).getOxygenLoss());
      }
    }
    break;
  case 5:
    doorMalfunction();
    oxygenLoop();
    inStep = 3;
    break;
  case 6: // win
    break;
  case 7: // lose
    break;
  }
  drawBoard();
}

void hullBreach() {
  if (!pilotFixed) {
    Room r = rooms.get((int)(Math.random()*rooms.size()));
    r.breach();
  }
}

void oxygenLoop() {
  for (int i = 0; i < rooms.size(); i++) {
    oxygenLoss(rooms.get(i));
  }
  for (int i = 0; i < rooms.size(); i++) {
    rooms.get(i).resetSpread();
  }
}

Room findRoom(int x, int y) {
  for (int i = 0; i<rooms.size(); i++) {
    if (rooms.get(i).getX() == x && rooms.get(i).getY() == y) {
      return rooms.get(i);
    }
  }
  return null;
}

void giveCards(int i) {
  int id = deck.get((int)(Math.random()*deck.size())).getID(); //could change to remove and have a discard
  if (id != 0) {
    String input = "";
    while (!input.equals(players[i].getName() + ", " + "receivedCard")) {
      s.write(players[i].getName() + ", card, " + (id-1) + "\n");
      delay(100);
      c = s.available();
      if (c != null) {
        input = c.readString(); 
        input = input.substring(0, input.indexOf("\n"));
      }
    }
  } else
    hullBreach();
  id = deck.get((int)(Math.random()*deck.size())).getID();
  if (id != 0) {
    String input = "";
    while (!input.equals(players[i].getName() + ", " + "receivedCard")) {
      s.write(players[i].getName() + ", card, " + (id-1) + "\n");
      delay(100);
      c = s.available();
      if (c != null) {
        input = c.readString(); 
        input = input.substring(0, input.indexOf("\n"));
      }
    }
  } else
    hullBreach();
}

void oxygenLoss(Room r) {
  if (r.isBreach()) {
    int spread;
    if (airFixed)
      spread = r.leak(1);
    else
      spread = r.leak(2);
    if (spread > 0) {
      for (int i = 0; i < rooms.size(); i++) {
        Room f = rooms.get(i);
        if (!f.spread() && (f.getX()-r.getX() == 1 || f.getX()-r.getX() == -1 || f.getY()-r.getY() == 1 || f.getY()-r.getY() == -1)) {
          oxygenLoss(f);
        }
      }
    }
  }
}

void doorMalfunction() {
  if (!securityFixed) {
    Room r = rooms.get((int)(Math.random()*rooms.size()));
    doors.flipRoom(r);
  }
}

void drawBoard() {
  background(255);
  rectMode(CORNER);
  textAlign(CENTER, CENTER);
  textSize(width*.015);
  if (inStep == 6) {
    textSize(width*.05);
    text("You win! The ship is saved!", width*.5, height*.5);
  } else if (inStep == 7) {
    text("You lose. Everyone died.", width*.5, height*.5);
  } else {
    for (int i = 0; i < rooms.size(); i++) {
      fill(255);
      rect(rooms.get(i).getX()*(width*.9)/5+width*.05, rooms.get(i).getY()*(height*.9)/6+height*.05, (width*.9)/5, (height*.9)/6);
      fill(0, 255, 0);
      if (rooms.get(i).isFixed())
        rect(rooms.get(i).getX()*(width*.9)/5+width*.05, rooms.get(i).getY()*(height*.9)/6+height*.05, (width*.9)/30, (width*.9)/30);
      fill(255, 0, 0);
      if (rooms.get(i).isBreach())
        rect((rooms.get(i).getX()+1)*(width*.9)/5+width*.05, (rooms.get(i).getY()+1)*(height*.9)/6+height*.05, -(width*.9)/30, -(width*.9)/30);
      fill(0);
      text(rooms.get(i).getName(), (rooms.get(i).getX()+.5)*(width*.9)/5+width*.05, (rooms.get(i).getY()+.5)*(height*.9)/6+height*.05);
      text(rooms.get(i).getOxygenLoss() + " Oxygen Loss", (rooms.get(i).getX()+.5)*(width*.9)/5+width*.05, (rooms.get(i).getY()+.5)*(height*.9)/6);
    }
    if (inStep >= 2) {
      for (int i = 0; i < players.length; i++) {
        if (i == 0)
          fill(255, 255, 0);
        if (i == 1)
          fill(255, 0, 0);
        if (i == 2)
          fill(0, 255, 0);
        if (i == 3)
          fill(0, 0, 255);
        rect((players[i].getX()+i*1.0/players.length)*(width*.9)/5+width*.05, (players[i].getY()+.75)*(height*.9)/6+height*.05, (width*.9)/5/players.length, (height*.9)/6/players.length);
      }
    }
    doors.drawDoors();
  }
}

void playerMain() {
  switch(inStep) {
  case 1: 
    name = showInputDialog("Enter player name: ");
    inStep++;
    break;
  case 2:
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      if (inputs.length == 3 && inputs[0].equals(name)) {
        pNum = Integer.parseInt(inputs[1])+1;
        inStep++;
        pMsg = "Waiting for turn.";
      }
    } else {
      c.write(name + ", " + "NewPlayer" + "\n");
    }
    break;
  case 3:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, go
      if (inputs.length == 3 && inputs[0].equals(name) && inputs[1].equals("go")) {
        pMsg = "Input action.";
        oxygen = Integer.parseInt(inputs[2]);
        inStep = 4;
        actions = 3;
      } else if (inputs.length == 3 && inputs[0].equals(name)) {
        if (inputs[1].equals("card")) {
          int cardID = Integer.parseInt(inputs[2]);
          hand[cardID]++;
          c.write(name + ", " + "receivedCard" + "\n");
        }
      }
    }
    break;
  case 4:
    drawPScreen();
    if (keyPressed) { 
      if (!keyHeld) {
        keyHeld = true;
        if (key == 'l') {
          inStep = 41;
        } else if (key == 'r') {
          c.write(name + ", " + "repair, " + hand[1] + ", " + hand[2] + ", " + hand[3] + "\n");
          inStep = 43;
        } else if (key == 'f') {
          c.write(name + ", " + "fix, " + hand[0] + "\n");
          inStep = 42;
        } else if (keyCode == LEFT || keyCode == RIGHT || keyCode == UP || keyCode == DOWN) {
          c.write(name + ", " + "move, " + keyCode + "\n");
          inStep = 44;
        } else if (key == 'g') {
          inStep = 45;
        } else if (key == 's') {
          inStep = 3;
          c.write(name + ", " + "done" + "\n");
          pMsg = "Waiting for turn.";
        }
      }
    } else {
      keyHeld = false;
    }
    break;
  case 41:
    drawPScreen();
    if (hand[0] < 2) {
      pMsg = "Invald input. Select a new action.";
    } else {
      pMsg = "Enter a direction (arrow keys)";
      if (keyPressed) { 
        if (!keyHeld) {
          keyHeld = true;
          if (keyCode == LEFT || keyCode == RIGHT || keyCode == UP || keyCode == DOWN) {
            //send message
            c.write(name + ", " + "flipDoor, " + keyCode + "\n");
            inStep = 48;
          } else {
            pMsg = "Invald input. Select a new action.";
            inStep = 4;
          }
        }
      } else {
        keyHeld = false;
      }
    }
    break;
  case 42:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, actionDone or name, actionInvalid
      if (inputs.length == 2 && inputs[0].equals(name)) {
        if (inputs[1].equals("actionDone")) {
          actions--;
          inStep = 4;
          pMsg = "Input action.";
          hand[0] -= 4;
          if (actions <= 0) {
            inStep = 3;
            c.write(name + ", " + "done" + "\n");
            pMsg = "Waiting for turn.";
          }
        } else if (inputs[1].equals("actionInvalid")) {
          inStep = 4;
          pMsg = "Invalid action, try again.";
        }
      }
    }
    break;
  case 43:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, actionDone or name, actionInvalid
      if (inputs.length >= 2 && inputs[0].equals(name)) {
        if (inputs[1].equals("actionDone")) {
          actions--;
          inStep = 4;
          hand[Integer.parseInt(inputs[2])] -= 4;
          pMsg = "Input action.";
          if (actions <= 0) {
            inStep = 3;
            c.write(name + ", " + "done" + "\n");
            pMsg = "Waiting for turn.";
          }
        } else if (inputs[1].equals("actionInvalid")) {
          inStep = 4;
          pMsg = "Invalid action, try again.";
        }
      }
    }
    break;
  case 44:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, actionDone or name, actionInvalid
      if (inputs.length == 2 && inputs[0].equals(name)) {
        if (inputs[1].equals("actionDone")) {
          actions--;
          inStep = 4;
          pMsg = "Input action.";
          if (actions <= 0) {
            inStep = 3;
            pMsg = "Waiting for turn.";
            c.write(name + ", " + "done" + "\n");
          }
        } else if (inputs[1].equals("actionInvalid")) {
          inStep = 4;
          pMsg = "Invalid action, try again.";
        }
      }
    }
    break;
  case 45:
    pMsg = "Enter the number of the player you want to give to.";
    drawPScreen();
    textAlign(CENTER, CENTER);
    textSize(width*.015);
    fill(255, 255, 0);
    text("1", width*.2, height*.7);
    fill(255, 0, 0);
    text("2", width*.4, height*.7);
    fill(0, 255, 0);
    text("3", width*.6, height*.7);
    fill(0, 0, 255);
    text("4", width*.8, height*.7);
    if (keyPressed) { 
      if (!keyHeld) {
        keyHeld = true;
        if (key == '1' || key == '2' || key == '3' || key == '4') {
          if (Character.forDigit(pNum, 10) == key) {
            pMsg = "Invald input. Select a new action.";
            inStep = 4;
          } else {
            inStep = 46;
            givingTo = Character.getNumericValue(key);
          }
        } else {
          pMsg = "Invald input. Select a new action.";
          inStep = 4;
        }
      }
    } else {
      keyHeld = false;
    }

    break;
  case 46:
    pMsg = "Which card do you want to give? (1: Metal, 2: Security AI Probe, 3: Air Control AI Probe, 4: Pilot AI Probe)";
    drawPScreen();
    if (keyPressed) {
      if (!keyHeld) {
        keyHeld = true;
        if (key == '1' || key == '2' || key == '3' || key == '4') {
          if (hand[Character.getNumericValue(key)-1] == 0) {
            pMsg = "Invald input. Select a new action.";
            inStep = 4;
          } else {
            c.write(name + ", " + "give" + ", " + key + ", " + givingTo + "\n");
            inStep = 47;
          }
        } else {
          pMsg = "Invald input. Select a new action.";
          inStep = 4;
        }
      }
    } else {
      keyHeld = false;
    }
    break;
  case 47:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, actionDone or name, actionInvalid
      if (inputs.length >= 2 && inputs[0].equals(name)) {
        if (inputs[1].equals("actionDone")) {
          actions--;
          inStep = 4;
          hand[Integer.parseInt(inputs[2])] -= 1;
          pMsg = "Input action.";
          if (actions <= 0) {
            inStep = 3;
            c.write(name + ", " + "done" + "\n");
            pMsg = "Waiting for turn.";
          }
        } else if (inputs[1].equals("actionInvalid")) {
          inStep = 4;
          pMsg = "Invalid action, try again.";
        }
      }
    }
    break;
  case 48:
    drawPScreen();
    if (c.available() > 0) {
      String input = c.readString();
      input = input.substring(0, input.indexOf("\n"));
      String[] inputs = input.split(", ");
      //Message format: name, actionDone or name, actionInvalid
      if (inputs.length == 2 && inputs[0].equals(name)) {
        if (inputs[1].equals("actionDone")) {
          actions--;
          inStep = 4;
          pMsg = "Input action.";
          hand[0] -= 2;
          if (actions <= 0) {
            inStep = 3;
            c.write(name + ", " + "done" + "\n");
            pMsg = "Waiting for turn.";
          }
        } else if (inputs[1].equals("actionInvalid")) {
          inStep = 4;
          pMsg = "Invalid action, try again.";
        }
      }
    }
    break;
  }
}

void drawPScreen() {
  background(255);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(width*.015);
  if (pNum == 1)
    fill(255, 255, 0);
  if (pNum == 2)
    fill(255, 0, 0);
  if (pNum == 3)
    fill(0, 255, 0);
  if (pNum == 4)
    fill(0, 0, 255);
  rect(width*.5, height*.05, width*.4, height*.04);
  fill(0);
  text(name + ": Player " + pNum, width*.5, height*.05);
  text(actions + " actions left.", width*.5, height*.1);
  text("Hand: " + hand[0] + "x Metal, " + hand[1] + "x Security AI Probe, " + hand[2] + "x Air Control AI Probe, " + hand[3] + "x Pilot AI Probe", width*.5, height*.2);
  text("Actions: Move (Arrow Keys), Lock/Unlock Door (L), Repair (R), Fix Breach (F), Give Card (G), Skip Turn (S)", width*.5, height *.4);
  text(pMsg, width*.5, height*.6);
  text("Oxygen: " + oxygen, width * .5, height * .9);
}
