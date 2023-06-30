final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float COIN_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = .6;
final static float JUMP_SPEED = 15; 
final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 
int w_Scale;
int h_Scale;
float WIDTH ;
float HEIGHT ;
float GROUND_LEVEL;
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;
final static int screen_Width = 850;
final static int screen_Height = 850;
int no_Maps;//number of maps + orignal one
float old_x;
float old_y;
float old2_x;
int level=0;
import processing.sound.*;
SoundFile file;
SoundFile loss;
SoundFile enemyloss;
SoundFile win;
SoundFile jump;



int score;
boolean isGameOver;
Player player;
PImage snow, crate, red_brick, brown_brick, gold, spider,p,background,bee,trophy,grass,razor;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Sprite> Prizes;
ArrayList<Sprite> enemy;
ArrayList<Sprite> enemy2;
ArrayList<Sprite> enemy4;
ArrayList<Sprite> stairs;
float view_x;
float view_y;
float temp;

void setup(){
 isGameOver=false;
  file = new SoundFile(this, "Run-Amok.mp3");

  //loss.stop();
 size(850,850);
 imageMode(CENTER);
 background=loadImage("sunnyday.png");
 background.resize(screen_Width,screen_Height);
 p=loadImage("player.png");
 player = new Player(p, 0.8);
 platforms = new ArrayList<Sprite>();
 coins = new ArrayList<Sprite>(); 
 Prizes = new ArrayList<Sprite>(); 
  enemy = new ArrayList<Sprite>();
  enemy2 = new ArrayList<Sprite>();
    enemy4 = new ArrayList<Sprite>();
 gold = loadImage("gold1.png"); 
 trophy=loadImage("prize1.png");
 grass=loadImage("grass.png");
 spider = loadImage("spider_walk_right1.png"); 
  razor = loadImage("razor_walk_right1.png"); 
 bee = loadImage("bee_walk_right1.png"); 
 red_brick = loadImage("red_brick.png");
 brown_brick = loadImage("brown_brick.png");
 crate = loadImage("crate.png");
 snow = loadImage("snow.png");
 createPlatforms();
 if(this.level==0){
  w_Scale=38;
 h_Scale=17;
 WIDTH = SPRITE_SIZE * w_Scale;
 HEIGHT = SPRITE_SIZE * h_Scale;
 GROUND_LEVEL = HEIGHT - SPRITE_SIZE ;
 no_Maps = 0;
 }
 else if(this.level==1){
 w_Scale=17;
 h_Scale=34;
 WIDTH = SPRITE_SIZE * w_Scale;
 HEIGHT = SPRITE_SIZE * h_Scale;
 GROUND_LEVEL = HEIGHT - SPRITE_SIZE ;
 no_Maps = 1;
 }
 player.setBottom(GROUND_LEVEL);
 player.center_x = 100;
 player.center_y = HEIGHT;
 view_x=0;
 view_y=((HEIGHT/2))*no_Maps;
 if(level==0)
 score=0;
}
void draw(){
 background(255);
 background(background);
 scroll(); 
 displayAll();
 if(isGameOver)
 {file.stop();}
 if(!isGameOver){
   updateAll();
   if(file.isPlaying()==false)
  {
    file.play();
  }
   //resolveCoinsCollisions();
   //if(player.lives!=0)
   //checkDeath();
    }
      
} 
void displayAll(){
  player.display();
  textSize(32);
  fill(255, 0, 0);
  if(level==0){
  text("Coins:" + score, view_x+15, view_y+40);
  text("lives:" + player.lives, view_x+15, view_y+75);}
  else if(level==1)
  { text("Coins:" + score, view_x+100, view_y+100);
  text("lives:" + player.lives, view_x+100, view_y+140);}
  for(Sprite s: platforms)
       {s.display();}
    
  for(Sprite c: coins)
       {c.display();}
        for(Sprite p: Prizes)
       {p.display();}
  for(Sprite e: enemy)
       {e.display();} 
       for(Sprite e: enemy2)
       {e.display();} 
        for(Sprite e: enemy4)
       {e.display();} 
  if(isGameOver){
    fill(0,0,255);
   
    text("GAMEOVER!", view_x + width/2 -100, view_y + height/2);
   
      if(player.lives==0){
       text("youlose!", view_x + width/2 -100, view_y + height/2 + 50);
     
   text("Press SPACE to restart!", view_x + width/2 -100, view_y + height/2+100);  
 }
     else if(level==1) 

     {text("You Win!", view_x + width/2 -100, view_y + height/2+50);   
   text("Press SPACE to restart!", view_x + width/2 -100, view_y + height/2+100);  
 }
     else 

     {text("You Win!", view_x + width/2 -100, view_y + height/2+50);   
   text("Press SPACE to continue!", view_x + width/2 -100, view_y + height/2+100);  
 }
     
    }
  
   
      //for(int i=0;i<WIDTH/SPRITE_SIZE ;i++) {
      //  g.line(i*SPRITE_SIZE , 0, i*SPRITE_SIZE , HEIGHT);
      //  g.line(0, i*SPRITE_SIZE , WIDTH, i*SPRITE_SIZE );
      //}
}
void lossmusic(){
  loss = new SoundFile(this, "2G7CF5V-gamers-fail-game.mp3");
  if(loss.isPlaying()==false)
loss.play();
}
void enemylossmusic(){
  //loss = new SoundFile(this, "jingles_HIT15.mp3");
    loss = new SoundFile(this, "mixkit-arcade-fast-game-over-233.wav");

  if(loss.isPlaying()==false)
loss.play();
}
void winmusic(){
  loss = new SoundFile(this, "mixkit-small-win-2020.mp3");
  if(loss.isPlaying()==false)
loss.play();
}
void coinmusic(){
  loss = new SoundFile(this, "mixkit-arcade-score-interface-217.wav");
  if(loss.isPlaying()==false)
loss.play();
}
void updateAll(){
  player.updateAnimation();
  resolvePlatformCollisions(player, platforms);
  resolveCoinsCollisions();
   resolvePrizeCollisions();
  for(Sprite c: coins)
        {((AnimatedSprite)c).updateAnimation();   }
          for(Sprite p: Prizes)
        {((AnimatedSprite)p).updateAnimation();   }
  for(Sprite e: enemy)
        {e.update(); 
      ((AnimatedSprite)e).updateAnimation();   }
      for(Sprite e: enemy2)
        {e.update(); 
      ((AnimatedSprite)e).updateAnimation();   }
         for(Sprite e: enemy4)
        {e.update(); 
      ((AnimatedSprite)e).updateAnimation();   }
  checkDeath();
}
void checkDeath(){
boolean collideEnemy;  
ArrayList<Sprite> col_list = checkCollisionList(player, enemy); 
ArrayList<Sprite> col_list2 = checkCollisionList(player, enemy2);
ArrayList<Sprite> col_list3 = checkCollisionList(player, enemy4);
if(col_list.size() > 0||col_list2.size() > 0||col_list3.size() > 0){
collideEnemy = true;}
else
{collideEnemy = false;}
boolean fallOffCliff= player.getBottom()>GROUND_LEVEL;
if(collideEnemy||fallOffCliff&&Prizes.size()!=0){
  player.lives=player.lives-1;
  if(collideEnemy&&Prizes.size()!=0)
  player.lives=0;
if(player.lives==0)
   {isGameOver=true;
   if(fallOffCliff)
 lossmusic();
 else
  enemylossmusic();
 
 }
else 
{player.center_x=old_x-7;
player.setBottom(old_y+(SPRITE_SIZE/2.0));}

}
}

void scroll(){
if(level!=1){
  float right_boundary = view_x + width - RIGHT_MARGIN;

if(player.getRight() > right_boundary)
   {float old=view_x;
   view_x +=player.getRight() - right_boundary;
 if(view_x>HEIGHT+150)
 view_x=old;}

float left_boundary = view_x + LEFT_MARGIN;

if(player.getRight() < left_boundary)
   {view_x -=left_boundary - player.getLeft();}
}
float top_boundary = view_y + VERTICAL_MARGIN;
if(player.getTop() < top_boundary)
   {view_y -=top_boundary - player.getTop();}


GROUND_LEVEL=view_y+HEIGHT- ((HEIGHT/2)*no_Maps);
translate(-view_x,-view_y);

}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  s.center_y+=5;
  ArrayList<Sprite> col_list=checkCollisionList(s, walls);
  s.center_y-=5;
  if(col_list.size() > 0)
        {return true;}
  else
       return false;
}

public void resolveCoinsCollisions(){
 ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if(collision_list.size() > 0){
     for(Sprite coin: collision_list)
          {coins.remove(coin);
          coinmusic();
            score++;
          }
     }
   //if(coins.size() == 0){
   //         isGameOver=true;
   // }
}
public void resolvePrizeCollisions(){
 ArrayList<Sprite> collision_list = checkCollisionList(player, Prizes);
  if(collision_list.size() > 0){
     for(Sprite prize: collision_list)
          {Prizes.remove(prize);}
     }
   if(Prizes.size() == 0){
            isGameOver=true;
            winmusic();
    }
}

//-------------------------------------------------------------------------
public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0){
      Sprite collided = col_list.get(0);
      if(s.change_y > 0)
         {s.setBottom(collided.getTop());
         old_x=collided.center_x;
         old_y=collided.center_y +SPRITE_SIZE;
     }
       else if(s.change_y < 0)
         {s.setTop(collided.getBottom());}
       s.change_y = 0;
   }
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0){
     Sprite collided = col_list.get(0);
     if(s.change_x > 0)
       {s.setRight(collided.getLeft());}
     else if(s.change_x < 0)
       {s.setLeft(collided.getRight());}
   }
  if(s.getLeft()<0)
      s.setLeft(0);

}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


void createPlatforms(){
  String filename="map.csv";
  if(level==1){ filename="map1.csv";}
  
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("1")){
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
       else if(values[col].equals("5")){
        Coin c = new Coin(gold, SPRITE_SCALE);
        c.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(c);
      }
         else if(values[col].equals("6")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 4 * SPRITE_SIZE;
            Enemy e= new Enemy(spider, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy.add(e);
            
      }
          else if(values[col].equals("7")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 6 * SPRITE_SIZE;
            Enemy2 e= new Enemy2(bee, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy2.add(e);
            
      }
            else if(values[col].equals("8")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 5 * SPRITE_SIZE;
            Enemy2 e= new Enemy2(bee, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy2.add(e);
            
      }
        else if(values[col].equals("9")){
        Prize p = new Prize(trophy, SPRITE_SCALE);
        p.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        p.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        Prizes.add(p);
      }
        else if(values[col].equals("10")){
        Sprite s = new Sprite(grass, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
            else if(values[col].equals("11")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 4 * SPRITE_SIZE;
            Enemy4 e= new Enemy4(razor, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy4.add(e);
            
      }
            else if(values[col].equals("12")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 2 * SPRITE_SIZE;
            Enemy e= new Enemy(spider, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy.add(e);
            
      }
            else if(values[col].equals("13")){
            float bLeft = col * SPRITE_SIZE;
            // 4 because it is the end of brick
            float bRight = bLeft + 3 * SPRITE_SIZE;
            Enemy2 e= new Enemy2(bee, 50/72.0,bLeft,bRight);
            e.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
            e.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
            enemy2.add(e);
            
      }
     
    }
  }
}

void keyPressed(){
  if(keyCode == RIGHT)
     {player.change_x = MOVE_SPEED;}
  else if(keyCode == LEFT)
     {player.change_x = -MOVE_SPEED;}
  else if(keyCode == UP && isOnPlatforms(player,platforms))
     {temp= player.center_y;
       player.change_y= -JUMP_SPEED;
     jump = new SoundFile(this, "mixkit-player-jumping-in-a-video-game-2043-_1_.mp3");
     jump.play();
     if(jump.isPlaying()==false)
     file.play();
   }
   else if(isGameOver&&key==' '){
    if(player.lives!=0)
     {this.level+=1;}
     if(this.level==2)
     this.level=0;
     
     if(loss.isPlaying())
     loss.stop();
  
   setup();}
}

void keyReleased(){
  if(keyCode == RIGHT)
     {player.change_x = 0;}
  else if(keyCode == LEFT)
     {player.change_x = 0;} 
}
