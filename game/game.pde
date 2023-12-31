//sound
import processing.sound.*;
SoundFile hit;
SoundFile music;
SoundFile lose;
//image
PImage efek;
PImage bg;
PImage lifebar;
PImage bintang;
PImage bgGameover;
PImage bgWin;
PImage button;
PFont font;    //font yang digunakan
boolean game_over=false; //game over jika kondisinya true
boolean menu=true; //halaman menu awal (game mulai saat kondisinya false)
Player basket;  //Declares an object of the type Player
Lifebar life;  //Declares an object of the type Player
Tatasurya bintangs[];  //Kita butuh beberapa bintang. [] menunjukkan bahwa kita menggunakan array objek.
int bintang_no= 4;    //Jumlah bintang yang tampil dilayar
int score= 0;
int lifeScore= 400; //lebar lifebar

//Membuat Class
class Player {
  int posx, posy;  //Posisi player saat ini
  PImage pic;  //player image

  int w, h;  //lebar dan tinggi player
  Player()  //constructor. Fungsi ini dipanggil setiap kali objek baru dari kelas Player dibuat.
  {
    pic=loadImage("roket.png");
    w=85;
    h=65;
    posx=mouseX-w/2;
    posy=height-h;
  }

  void display()  //Menampilkan data
  {
    posx=mouseX-w/2;
    image(pic, posx, posy, w, h);
  }
}

class Tatasurya {
  int posx, posy, rad, speed;
  color c;
  Tatasurya()
  {
    posx=(int)random(50, width-50);
    posy=0;
    rad=20;
    speed=(int)random(3, 6);
    c=color(180, 0, 0);
  }
  void display()
  {
    //fill(c);
    //ellipse(posx, posy, rad, rad);
    image(bintang, posx, posy, rad, rad);
  }
  void update_pos()
  {
    posy+=speed;
  }
  void check_bounds()
  {
    if (posy>=height)  //Cek jika bintang keluar dari layar, setel ulang posisinya dan berikan kecepatan baru.
    {
      reset_pos();
      lifeScore-=20; //Mengurangi lifeScore saat bintang miss
    }
  }
  void reset_pos()
  {
    posy=0;
    posx=(int)random(50, width-50);
    speed=(int)random(3, 6);
  }
}
class Lifebar {
  int posx, posy, h;
  Lifebar()
  {
    posx= width/2 - lifeScore/2;
    posy= 30;
    h= 15;
  }
  void display()
  {
    //fill(c);
    //ellipse(posx, posy, rad, rad);
    image(lifebar, posx, posy, lifeScore, h);
  }
}

void setup()
{
  size(800, 450);
  //load image
  bg = loadImage("background-langit.png");
  bgGameover = loadImage("gameover.png");
  bgWin = loadImage("win.png");
  lifebar = loadImage("lifebar.png");
  bintang = loadImage("bintang.png");
  efek = loadImage("efek-asap.png");
  button= loadImage("play.png");
  // Load the sound file
  music = new SoundFile(this, "Vectorman Ocean.mp3");
  lose = new SoundFile(this, "failsound.mp3");
  hit = new SoundFile(this, "hit.wav");
  
  //background(128);
  smooth();  //Turn on anti-aliasing. Make lines look a lot smoother
  frameRate(30);
  font=loadFont("font.vlw");
  textFont(font, 16);
  basket=new Player();  //Initialize our object.
  life = new Lifebar();
  bintangs=new Tatasurya[bintang_no];  
  for (int i=0;i<bintang_no;i++)  //Initialize each bintang.
  {
    bintangs[i]=new Tatasurya();
  }
}

void draw()
{
   background(bg);
   
  if (menu==true){
    menu();
  } 
  else{
    if (!game_over && music.isPlaying()){
      life.display();              //Displays the lifebar.
      basket.display();              //Displays the basket.
      for (int i=0;i<bintang_no;++i)   //Untuk setiap bintang yang ada, dijalankan fungsi display, update_pos, check_bounds dan check_collision.
        {
        bintangs[i].display();
        bintangs[i].update_pos();
        bintangs[i].check_bounds();
        check_collision(bintangs[i]);
        }
      score_display();
      lifeScore_display();
    }
    else if (game_over){
        gameOver();
    }
    else if(!music.isPlaying()){
        gameWin(); //memang jika musik telah habis/stop
    }
  }
    
}

void menu(){
  image(button, 300, 195,200,60); //menampilkan tombol button
  //jika mouse click pada area tombol button
  if(mouseX>=300 && mouseX<=300+200 && mouseY>=195&&mouseY<=195+60 && mousePressed){
      image(button, 270, 185,240,80);
      //reset posisi semua bintang
      for (int i=0;i<bintang_no;++i){
        bintangs[i].reset_pos();
      }
      lifeScore=400; //reset lifeScore
      score = 0; //reset score point
      menu=false;
      music.play();
  }
}
void gameOver(){
  music.stop();
  image(bgGameover, 0, 0);
  image(button, 300, 195,200,60);
  if(mouseX>=300 && mouseX<=300+200 && mouseY>=195&&mouseY<=195+60 && mousePressed){
    image(button, 270, 185,240,80);
    menu=true;
    game_over=false;
    }
}
void gameWin(){
  image(bgWin, 0, 0);
  //tampil score
  fill(#FAFAFA);
  textAlign(CENTER);
  textSize(40);
  text(" = "+score, 180, 50);
  noFill();
  //tampil tombol
  image(button, 100, 195,200,60);
  if(mouseX>=100 && mouseX<=100+200 && mouseY>=195&&mouseY<=195+60 && mousePressed){
    image(button, 270, 185,240,80);
    menu=true;
    }
}

void check_collision(Tatasurya temp_bintang) 
{
  //cek jika bintang ditangkap player
  if (temp_bintang.posx>basket.posx && temp_bintang.posx < basket.posx+basket.w && temp_bintang.posy>basket.posy-15 && temp_bintang.posy<basket.posy-basket.h/2+30)  
  {
    image(efek, temp_bintang.posx-25, temp_bintang.posy-35, 70, 70);
    hit.play();
    temp_bintang.reset_pos();
    score = score +1; //tambah point
    if(lifeScore>0 && lifeScore<400){
    lifeScore = lifeScore +5; //tambah lifescore
    }
  }
}

void score_display() //menampilkan score
{
  fill(#FAFAFA);
  textAlign(LEFT);
  textSize(18);
  text("bintang Point : "+score, 5, height-5);
  noFill();
}
void lifeScore_display() //menampilkan lifescore
{
  fill(#FAFAFA);
  textAlign(CENTER);
  textSize(18);
  text("Life Score: "+lifeScore, width/2, 25);
  noFill();
  if (lifeScore<=0){
    game_over=true;
    lose.play();
  }
}
