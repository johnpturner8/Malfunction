public static class Helpers {  
  public static boolean canMove(int k, Player p, Doors d) {
    int x = p.getX();
    int y = p.getY();
    if (x == 2 && y == 0) {
      if (k == DOWN && !d.get(0)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 1) {
      if (k == DOWN && !d.get(1)) {
        return true;
      } else if (k == RIGHT && !d.get(15)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 1) {
      if (k == DOWN && !d.get(2)) {
        return true;
      } else if (k == RIGHT && !d.get(16)) {
        return true;
      } else if (k == LEFT && !d.get(15)) {
        return true;
      } else if (k == UP && !d.get(0)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 1) {
      if (k == DOWN && !d.get(3)) {
        return true;
      } else if (k == LEFT && !d.get(16)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 2) {
      if (k == DOWN && !d.get(4)) {
        return true;
      } else if (k == UP && !d.get(1)) {
        return true;
      } else if (k == RIGHT && !d.get(17)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 2) {
      if (k == DOWN && !d.get(5)) {
        return true;
      } else if (k == UP && !d.get(2)) {
        return true;
      } else if (k == LEFT && !d.get(17)) {
        return true;
      } else if (k == RIGHT && !d.get(18)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 2) {
      if (k == DOWN && !d.get(6)) {
        return true;
      } else if (k == LEFT && !d.get(18)) {
        return true;
      } else if (k == UP && !d.get(3)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 3) {
      if (k == DOWN && !d.get(7)) {
        return true;
      } else if (k == RIGHT && !d.get(19)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 3) {
      if (k == DOWN && !d.get(8)) {
        return true;
      } else if (k == UP && !d.get(4)) {
        return true;
      } else if (k == RIGHT && !d.get(20)) {
        return true;
      } else if (k == LEFT && !d.get(19)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 3) {
      if (k == DOWN && !d.get(9)) {
        return true;
      } else if (k == UP && !d.get(5)) {
        return true;
      } else if (k == LEFT && !d.get(20)) {
        return true;
      } else if (k == RIGHT && !d.get(21)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 3) {
      if (k == DOWN && !d.get(6)) {
        return true;
      } else if (k == UP && !d.get(10)) {
        return true;
      } else if (k == RIGHT && !d.get(22)) {
        return true;
      } else if (k == LEFT && !d.get(21)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 3) {
      if (k == DOWN && !d.get(11)) {
        return true;
      } else if (k == LEFT && !d.get(22)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 4) {
      if (k == DOWN && !d.get(12)) {
        return true;
      } else if (k == UP && !d.get(7)) {
        return true;
      } else if (k == RIGHT && !d.get(23)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 1 && y == 4) {
      if (k == UP && !d.get(8)) {
        return true;
      } else if (k == RIGHT && !d.get(24)) {
        return true;
      } else if (k == LEFT && !d.get(23)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 4) {
      if (k == DOWN && !d.get(13)) {
        return true;
      } else if (k == UP && !d.get(9)) {
        return true;
      } else if (k == RIGHT && !d.get(25)) {
        return true;
      } else if (k == LEFT && !d.get(24)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 3 && y == 4) {
      if (k == DOWN && !d.get(10)) {
        return true;
      } else if (k == RIGHT && !d.get(25)) {
        return true;
      } else if (k == RIGHT && !d.get(26)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 4) {
      if (k == DOWN && !d.get(14)) {
        return true;
      } else if (k == UP && !d.get(11)) {
        return true;
      } else if (k == LEFT && !d.get(26)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 0 && y == 5) {
      if (k == UP && !d.get(12)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 2 && y == 5) {
      if (k == UP && !d.get(13)) {
        return true;
      } else {
        return false;
      }
    } else if (x == 4 && y == 5) {
      if (k == UP && !d.get(14)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
