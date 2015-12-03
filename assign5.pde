//PImage
PImage bg1;
PImage bg2;
PImage enemy;
PImage fighter;
PImage hp;
PImage treasure;
PImage start;
PImage start2;
PImage end;
PImage end2;
PImage[] flame;
PImage bullet;

//int.float
int bg2x = 0;
int bg1x = -640;
int nbrFl = 5;
int timer = 0;
int flame_time = 0;
int[] bulletPositionX = new int[5];
int[] bulletPositionY = new int[5];
int countBulletFrame = 0;
int ID_bullet= 0;
int num_bullet = 5;
int score = 0;
float a = random(122, 297);
float[] ewave1x = new float[5];
float[] ewave1y = new float[5];
float[] ewave2x = new float[5];
float[] ewave2y = new float[5];
float[] ewave3x = new float[8];
float[] ewave3y = { a, a - 61, a + 61, a - 122, a + 122, a - 61, a + 61, a };
float enemyx = 0;
float enemyy = 0;
float treasurex = random(0, 599);
float treasurey = random(0, 439);
float l = 38;
float fighterx = 589;
float fightery = 240;
float speed = 5;
float flamex = 10000;
float flamey = 10000;
float bulletSpeed = 5;

//boolean gameState.enemyWave.bombAnimation
boolean GameState;
boolean GameOver;
boolean upPressed;
boolean downPressed;
boolean leftPressed;
boolean rightPressed;
boolean wave1;
boolean wave2;
boolean wave3;
boolean bulletPressed;
boolean[] bullet_appear = new boolean[5];
boolean[] bullet_crush = new boolean[5];
boolean isHit;


void setup() {
  size(640, 480);
  frameRate(100);
  bg2 = loadImage("img/bg2.png");
  bg1 = loadImage("img/bg1.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  start = loadImage("img/start2.png");
  start2 = loadImage("img/start1.png");
  end = loadImage("img/end2.png");
  end2 = loadImage("img/end1.png");
  flame = new PImage[nbrFl];
  for (int b = 0; b < nbrFl; b++) {
    flame[b] = loadImage("img/flame" + (b + 1) + ".png");
  }
  bullet = loadImage("img/shoot.png");
  GameState = false;
  wave1 = false;
  wave2 = false;
  wave3 = false;
  bulletPressed = false;
  isHit = false;
  for (int i =0; i<bullet_crush.length; i++) {
    bullet_crush[i] = false;
  }
  for (int i =0; i<bullet_appear.length; i++) {
    bullet_appear[i] = false;
  }
}
void scoreChange(int score) {
  fill(255, 255, 255);
  textSize(32);
  text("Score:"+score, 20, 460);
}

void draw() {
  //backGround
  image(bg2, bg2x, 0);
  image(bg1, bg1x, 0);
  image(fighter, fighterx, fightery);
  fill(225, 0, 0);
  rect(13, 5, l, 15);
  image(hp, 0, 0);
  image(treasure, treasurex, treasurey);
  scoreChange(score);

  //gameStart
  if (GameState == false) {
    image(start, 0, 0);
    enemyx = 0;
  }
  bg2x++;
  bg1x++;
  while (bg2x > 640) {
    bg2x = -640;
  }
  while (bg1x > 640) {
    bg1x = -640;
  }

  if (GameState == false && mouseX > 200 && mouseX < 440 && mouseY > 360 && mouseY < 420) {
    image(start2, 0, 0);
    if (mousePressed) {
      GameState = true;
      wave1 = true;
      enemyy = random(0, 419);
    }
  }

  //enemyWave
  if (wave1 == true && isHit == false) {
    for (int i = 0; i < ewave1x.length; i++) {
      ewave1x[i] = enemyx - (i * 61);
      ewave1y[i] = enemyy;
      image(enemy, ewave1x[i], ewave1y[i]);
    }
  }
  if (wave1 == true) {
    for (int i = 0; i < ewave1x.length; i++) {
      if (ewave1x[i] - fighterx <= 61 && ewave1x[i] - fighterx >= -61 && ewave1y[i] - fightery <= 61
        && ewave1y[i] - fightery >= -61) {
        isHit = true;
        ewave1y[i] += 1000;
        l = l - 38;
        flamex = ewave1x[i];
        flamey = ewave1y[i] - 1000;
        flame_time = 0;
      }

      for (int j=0; j<bulletPositionX.length; j++) {
        if (bullet_appear[j] && bulletPositionX[j] > ewave1x[i]) {
          if (ewave1y[i] > bulletPositionY[j]) {
            bulletPositionY[j] += 4;
          } else if (bulletPositionY[j] > ewave1y[i]) {
            bulletPositionY[j] -= 4;
          }
        } else if (ewave1y[i] > 480) {
          bulletPositionY[j] -= 2;
        }
        if (bullet_appear[j]) {
          if (!bullet_crush[j]) {
            if (ewave1x[i]+30 >= (int)bulletPositionX[j]-15 && ewave1x[i]-30 <= (int)bulletPositionX[j]+15) {
              if (ewave1y[i]+30 >= (int)bulletPositionY[j]-13 && ewave1y[i]-30 <= (int)bulletPositionY[j]+13) {
                isHit = true;
                ewave1y[i] += 1000;
                flamex = ewave1x[i]+30;
                flamey = ewave1y[i]-970;
                flame_time = 0;
                bullet_appear[j] = false;
                bullet_crush[j] = true;
                flame_time = 0;
                score += 20;
                //num_bullet --;
              }
            }
          }
        }
      }

      image(enemy, ewave1x[i], ewave1y[i]);
      ewave1x[i] += 6;
    }
  }
  if (wave1 == true && enemyx > 884) {
    wave1 = false;
    wave2 = true;
    isHit = false;
    enemyx = 0;
    enemyy = random(0, 175);
  }
  if (wave2 == true && isHit == false) {
    for (int i = 0; i < ewave2x.length; i++) {
      ewave2x[i] = enemyx - (i * 61);
      ewave2y[i] = enemyy + (i * 61);
      image(enemy, ewave2x[i], ewave2y[i]);
    }
  }
  if (wave2 == true) {
    for (int i = 0; i < ewave2x.length; i++) {
      if (ewave2x[i] - fighterx <= 61 && ewave2x[i] - fighterx >= -61 && ewave2y[i] - fightery <= 61
        && ewave2y[i] - fightery >= -61) {
        isHit = true;
        ewave2y[i] += 1000;
        l = l - 38;
        flamex = ewave2x[i];
        flamey = ewave2y[i] - 1000;
        flame_time = 0;
      }

      for (int j=0; j<bulletPositionX.length; j++) {
        if (bullet_appear[j] && bulletPositionX[j] > ewave2x[i]) {
          if (ewave2y[i] > bulletPositionY[j]) {
            bulletPositionY[j] += 4;
          } else if (bulletPositionY[j] > ewave2y[i]) {
            bulletPositionY[j] -= 4;
          }
        } else if (ewave2y[i] > 480) {
          bulletPositionY[j] -= 2;
        }
        if (bullet_appear[j]) {
          if (!bullet_crush[j]) {
            if (ewave2x[i]+30 >= (int)bulletPositionX[j]-15 && ewave2x[i]-30 <= (int)bulletPositionX[j]+15) {
              if (ewave2y[i]+30 >= (int)bulletPositionY[j]-13 && ewave2y[i]-30 <= (int)bulletPositionY[j]+13) {
                isHit = true;
                ewave2y[i] += 1000;
                flamex = ewave2x[i]+30;
                flamey = ewave2y[i]-970;
                flame_time = 0;
                bullet_appear[j] = false;
                bullet_crush[j] = true;
                flame_time = 0;
                score += 20;
                //num_bullet --;
              }
            }
          }
        }
      }
      image(enemy, ewave2x[i], ewave2y[i]);
      ewave2x[i] += 6;
    }
  }
  if (wave2 == true && enemyx > 884) {
    wave2 = false;
    wave3 = true;
    isHit = false;
    enemyx = 0;
  }
  if (wave3 == true && isHit == false) {
    float k = 0;
    for (int i = 0; i < ewave3x.length; i++) {
      if (ewave3y[i] > 1000) {
        ewave3y[i] -= 1000;
      }
      ewave3x[i] = enemyx - ceil(k / 2) * 61;
      k++;
      image(enemy, ewave3x[i], ewave3y[i]);
    }
  }
  if (wave3 == true) {
    for (int i = 0; i < ewave3x.length; i++) {
      if (ewave3x[i] - fighterx <= 61 && ewave3x[i] - fighterx >= -61 && ewave3y[i] - fightery <= 61
        && ewave3y[i] - fightery >= -61) {
        isHit = true;
        ewave3y[i] += 1000;
        l = l - 38;
        flamex = ewave3x[i];
        flamey = ewave3y[i] - 1000;
        flame_time = 0;
      }

      for (int j=0; j<bulletPositionX.length; j++) {
        if (bullet_appear[j] && bulletPositionX[j] > ewave3x[i]) {
          if (ewave3y[i] > bulletPositionY[j]) {
            bulletPositionY[j] += 4;
          } else if (bulletPositionY[j] > ewave3y[i]) {
            bulletPositionY[j] -=4;
          }
        } else if (ewave3y[i] > 480) {
          bulletPositionY[j] -= 2;
        }
        if (bullet_appear[j]) {
          if (!bullet_crush[j]) {
            if (ewave3x[i]+30 >= (int)bulletPositionX[j]-15 && ewave3x[i]-30 <= (int)bulletPositionX[j]+15) {
              if (ewave3y[i]+30 >= (int)bulletPositionY[j]-13 && ewave3y[i]-30 <= (int)bulletPositionY[j]+13) {
                isHit = true;
                ewave3y[i] += 1000;
                flamex = ewave3x[i]+30;
                flamey = ewave3y[i]-970;
                flame_time = 0;
                bullet_appear[j] = false;
                bullet_crush[j] = true;
                flame_time = 0;
                score += 20;
                //num_bullet --;
              }
            }
          }
        }
      }
      image(enemy, ewave3x[i], ewave3y[i]);
      ewave3x[i] += 6;
    }
  }
  if (wave3 == true && enemyx > 884) {
    wave3 = false;
    wave1 = true;
    isHit = false;
    enemyx = 0;
    enemyy = random(0, 419);
  }

  //bombAnimation
  image(flame[flame_time], flamex, flamey, 60, 60);
  timer++;
  if (timer > 10) {
    flame_time++;
    timer = 0;
  }
  if (flame_time >= flame.length) {
    flamex = 10000;
    flamey = 10000;
    flame_time = 0;
  }
  if (bulletPressed) {

    for (int i=0; i<bulletPositionX.length; i++) {
      bulletPositionX[i] -= 10;
      if (!bullet_crush[i]) {
        image(bullet, bulletPositionX[i], bulletPositionY[i]);
      }
      if (bullet_crush[i]) {
        image(bullet, bulletPositionX[i], 100000);
      }

      if (bulletPositionX[i]<0) {
        num_bullet --;
        bulletPositionX[i]=10000;
      }
      if (bulletPositionX[i]<0 || bullet_crush[i]) {
        bulletPositionY[i]=10000;
        bullet_crush[i]=false;
        bullet_appear[i]=false;
      }
    }
  }
  if (GameState == false) {
    bulletPressed = false;
  } 
  countBulletFrame++;

  //gameOver
  if (GameOver == true) {
    image(end, 0, 0);
    wave1 = true;
    wave2 = false;
    wave3 = false;
    isHit = false;
    fighterx = 589;
    fightery = 240;
    enemyx = 0;
    enemyy = random(0, 429);
    l = 38;
    bg2x = 0;
    bg1x = -640;
    for (int i = 0; i < 5; i++) {
      bulletPositionY[i] = 10000;
    }
    flamex = 10000;
    score = 0;
  }
  if (GameOver == true && mouseX > 200 && mouseX < 440 && mouseY > 300 && mouseY < 360) {
    image(end2, 0, 0);
    if (mousePressed) {
      GameOver = false;
    }
  }

  //board
  if (upPressed) {
    fightery -= speed;
    ;
  }
  if (downPressed) {
    fightery += speed;
  }
  if (leftPressed) {
    fighterx -= speed;
  }
  if (rightPressed) {
    fighterx += speed;
  }
  if (fighterx > 589) {
    fighterx = 589;
  }
  if (fighterx < 0) {
    fighterx = 0;
  }
  if (fightery > 429) {
    fightery = 429;
  }
  if (fightery < 0) {
    fightery = 0;
  }
  if (bg2x > 640) {
    bg2x = 0;
  }

  if (treasurex - fighterx <= 41 && treasurex - fighterx >= -41 && treasurey - fightery <= 41
    && treasurey - fightery >= -41) {
    isHit = true;
    treasurex = random(0, 599);
    treasurey = random(0, 439);
    l = l + 19;
  }
  if (l > 190) {
    l = 190;
  }
  if (l <= 0) {
    GameOver = true;
  }
  enemyx += 6;
}


void keyPressed() {

  if (key == CODED) {
    switch (keyCode) {
    case UP:
      upPressed = true;
      break;
    case DOWN:
      downPressed = true;
      break;
    case LEFT:
      leftPressed = true;
      break;
    case RIGHT:
      rightPressed = true;
      break;
    }
  }
  if (key==' ' && countBulletFrame > 15 && num_bullet <= 5) {
    bulletPressed = true;

    bulletPositionX[ID_bullet] = (int)fighterx;
    bulletPositionY[ID_bullet] = (int)fightery;
    bullet_appear[ID_bullet] = true;
    countBulletFrame=0;
    ID_bullet++;
    num_bullet++;
    if (ID_bullet>=bulletPositionX.length) {
      ID_bullet=0;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}
