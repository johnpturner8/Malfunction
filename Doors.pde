public class Doors {
  boolean[] doors;
  public Doors() {
    doors = new boolean[27];
    for (int i = 0; i < doors.length; i++) {
      doors[i] = false;
    }
  }

  public boolean flip(int num) {
    doors[num] = !doors[num];
    return true; //hacky way to avoid writing code
  }

  public boolean flipper(int k, Player p) {
    int x = p.getX();
    int y = p.getY();
    if (x == 2 && y == 0) {
      if (k == DOWN && flip(0)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 1) {
      if (k == DOWN && flip(1)) {
        return true;
      } else if (k == RIGHT && flip(15)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 1) {
      if (k == DOWN && flip(2)) {
        return true;
      } else if (k == RIGHT && flip(16)) {
        return true;
      } else if (k == LEFT && flip(15)) {
        return true;
      } else if (k == UP && flip(0)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 1) {
      if (k == DOWN && flip(3)) {
        return true;
      } else if (k == LEFT && flip(16)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 2) {
      if (k == DOWN && flip(4)) {
        return true;
      } else if (k == UP && flip(1)) {
        return true;
      } else if (k == RIGHT && flip(17)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 2) {
      if (k == DOWN && flip(5)) {
        return true;
      } else if (k == UP && flip(2)) {
        return true;
      } else if (k == LEFT && flip(17)) {
        return true;
      } else if (k == RIGHT && flip(18)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 2) {
      if (k == DOWN && flip(6)) {
        return true;
      } else if (k == LEFT && flip(18)) {
        return true;
      } else if (k == UP && flip(3)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 3) {
      if (k == DOWN && flip(7)) {
        return true;
      } else if (k == RIGHT && flip(19)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 3) {
      if (k == DOWN && flip(8)) {
        return true;
      } else if (k == UP && flip(4)) {
        return true;
      } else if (k == RIGHT && flip(20)) {
        return true;
      } else if (k == LEFT && flip(19)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 3) {
      if (k == DOWN && flip(9)) {
        return true;
      } else if (k == UP && flip(5)) {
        return true;
      } else if (k == LEFT && flip(20)) {
        return true;
      } else if (k == RIGHT && flip(21)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 3) {
      if (k == DOWN && flip(6)) {
        return true;
      } else if (k == UP && flip(10)) {
        return true;
      } else if (k == RIGHT && flip(22)) {
        return true;
      } else if (k == LEFT && flip(21)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 3) {
      if (k == DOWN && flip(11)) {
        return true;
      } else if (k == LEFT && flip(22)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 4) {
      if (k == DOWN && flip(12)) {
        return true;
      } else if (k == UP && flip(7)) {
        return true;
      } else if (k == RIGHT && flip(23)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 4) {
      if (k == UP && flip(8)) {
        return true;
      } else if (k == RIGHT && flip(24)) {
        return true;
      } else if (k == LEFT && flip(23)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 4) {
      if (k == DOWN && flip(13)) {
        return true;
      } else if (k == UP && flip(9)) {
        return true;
      } else if (k == RIGHT && flip(25)) {
        return true;
      } else if (k == LEFT && flip(24)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 4) {
      if (k == DOWN && flip(10)) {
        return true;
      } else if (k == RIGHT && flip(25)) {
        return true;
      } else if (k == RIGHT && flip(26)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 4) {
      if (k == DOWN && flip(14)) {
        return true;
      } else if (k == UP && flip(11)) {
        return true;
      } else if (k == LEFT && flip(26)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 5) {
      if (k == UP && flip(12)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 5) {
      if (k == UP && flip(13)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 5) {
      if (k == UP && flip(14)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  public void flipRoom(Room r) {
    int x = r.getX();
    int y = r.getY();
    if (x == 2 && y == 0) {
      flip(0);
    } else if (x == 1 && y == 1) {
      flip(1);
      flip(15);
    } else if (x == 2 && y == 1) {
      flip(15);
      flip(16);
      flip(2);
    } else if (x == 3 && y == 1) {
      flip(16);
      flip(3);
    } else if (x == 1 && y == 2) {
      flip(17);
      flip(4);
      flip(1);
    } else if (x == 2 && y == 2) {
      flip(2);
      flip(5);
      flip(17);
      flip(18);
    } else if (x == 3 && y == 2) {
      flip(3);
      flip(6);
      flip(18);
    } else if (x == 0 && y == 3) {
      flip(7);
      flip(19);
    } else if (x == 1 && y == 3) {
      flip(4);
      flip(8);
      flip(19);
      flip(20);
    } else if (x == 2 && y == 3) {
      flip(5);
      flip(9);
      flip(20);
      flip(21);
    } else if (x == 3 && y == 3) {
      flip(6);
      flip(10);
      flip(21);
      flip(22);
    } else if (x == 4 && y == 3) {
      flip(22);
      flip(11);
    } else if (x == 0 && y == 4) {
      flip(7);
      flip(12);
      flip(23);
    } else if (x == 1 && y == 4) {
      flip(23);
      flip(24);
      flip(8);
    } else if (x == 2 && y == 4) {
      flip(24);
      flip(25);
      flip(9);
      flip(13);
    } else if (x == 3 && y == 4) {
      flip(10);
      flip(25);
      flip(26);
    } else if (x == 4 && y == 4) {
      flip(26);
      flip(11);
      flip(14);
    } else if (x == 0 && y == 5) {
      flip(12);
    } else if (x == 2 && y == 5) {
      flip(13);
    } else if (x == 4 && y == 5) {
      flip(14);
    }
  }

  public boolean get(int i) {
    return doors[i];
  }

  public void drawDoors() {
    rectMode(CENTER);
    fill(255, 0, 0);
    for (int i = 0; i < doors.length; i++) {
      if (doors[i]) {
        if (i <= 14) {
          float yMod = -1;
          float xMod = -1;
          if (i == 0) {
            xMod = 2.5;
            yMod = 1;
          }
          if (i == 1 || i == 4 || i == 8)
            xMod = 1.5;
          else if (i == 7 || i == 12)
            xMod = 0.5;
          else if (i == 2 || i == 5 || i == 9 || i == 13)
            xMod = 2.5;
          else if (i == 3 || i == 6 || i == 10)
            xMod = 3.5;
          else if (i == 11 || i == 14)
            xMod = 4.5;  
          if (i >= 1 && i <= 3)
            yMod = 2;
          else if (i >= 4 && i <= 6)
            yMod = 3;
          else if (i >= 7 && i <= 11)
            yMod = 4;
          else if (i >= 12 && i <= 14)
            yMod = 5;
          rect(xMod*(width*.9)/5+width*.05, yMod*(height*.9)/6+height*.05, (width*.9)/5, (height*.9)/6/10);
        } else {
          float xMod = -1;
          float yMod = -1;
          if (i == 19 || i == 23)
            xMod = 1;
          else if (i == 15 || i == 17 || i == 20 || i == 24)
            xMod = 2;
          else if (i == 16 || i == 18 || i == 21 || i == 25)
            xMod = 3;
          else if (i == 22 || i == 26)
            xMod = 4;
          if(i == 15 || i == 16)
            yMod = 1.5;
          else if(i == 17 || i == 18)
            yMod = 2.5;
          else if(i >= 19 && i <= 22)
            yMod = 3.5;
          else if(i >= 23)
            yMod = 4.5;
          rect(xMod*(width*.9)/5+width*.05, yMod*(height*.9)/6+height*.05, (height*.9)/6/10, (height*.9)/6);
        }
      }
    }
  }
}
