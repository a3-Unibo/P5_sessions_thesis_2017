float x, y, dx, dy, rnd;
float rad = 300;
PVector pos, vel, acc;
color c;
Ball b;
int nBalls = 50;
ArrayList <Ball>balls;


void setup() {
  size(800, 800);
  //fullscreen(JAVA2D);
  ellipseMode(CENTER);

  balls = new ArrayList<Ball>(); // costruttore, arraylist è sempre una classe, non ha bisogno di parametri
  for (int i=0; i<nBalls; i++) {// loop
    //x = width*0.5+random(rad)*cos(random(TWO_PI));
    //y = height*0.5+random(rad)*sin(random(TWO_PI));
    dx=0.5; // unità è equivalente a un pixel, velocità, spazio in unità di tempo
    dy=-0.01;
    //pos = new PVector(x, y); // PVector classe di processing tridimensionali
    pos = PVector.random2D(); // PVector classe di processing tridimensionali
    pos.mult(random(rad));
    pos.add(new PVector(width*.5, height*.5));
    vel = new PVector(dx, dy);
    acc = new PVector(0, -0.005); // definisco anche direzione del vettore
    rnd = random(255);
    c = color(0,rnd*0.5, rnd); 
    b = new Ball(pos, vel, acc, random(20, 50), c);
    balls.add(b);
  }
}




void draw() {
  /*
  ellipse(pos.x, pos.y, 10, 10); // dot operator
   vel.add(acc);
   pos.add(vel); // add è un metodo di PVector, significa aggiungi a pos il vettore vel, aggiungi a te stesso
   acc = PVector.random2D ();
   vel.limit(3);
   */

  for (int i=0; i<balls.size(); i++) { //.size vede quanti elementi sono dentro alla arraylist
    b = balls.get(i); // funzione per leggere l'elemento
    b.update();
    b.display();
  }
  println(frameCount);
}