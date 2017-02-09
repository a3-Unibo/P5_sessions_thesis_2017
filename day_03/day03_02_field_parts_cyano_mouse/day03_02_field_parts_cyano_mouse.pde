import controlP5.*;

float res = 10.0;
float ns = 0.008;
int nX, nY, count;
Field field;
Particle p;
boolean discrete = false;
boolean lines = true;
boolean update = false;

PVector world;
ArrayList<Particle> particles;
int nParticles = 200;

PGraphics pg;



void setup() {
  size(1400, 600, P2D);
  //fullScreen(P2D);
  pg = createGraphics(width, height);
  nX = int(width/res);
  nY = int(height/res);
  noiseSeed(10);
  noiseDetail(1);
  field = new Field(res, res, ns);
  //field = new Field(90,160,ns);
  ellipseMode(CENTER);

  //p= new Particle(new PVector(200, 200), PVector.random2D().mult(3), field, random(0.01*PI,0.2*PI));

  //noStroke();
  strokeWeight(.5);
  stroke(255);

  particles = new ArrayList<Particle>();


  /*
  for (int i=0; i< nParticles; i++) {
   p = new Particle(new PVector(random(width), height*.5), new PVector(0, random(-1,1)).setMag(1.5), field, random(0.01*PI, 0.2*PI),200);
   
   //a=new Agent(new PVector(), PVector.random3D(), world);
   particles.add(p);
   }
   +/
  /*
   if (discrete) {
   field.dispTilesDiscrete();
   } else {
   field.dispTiles();
   if (lines)field.dispLines(res*0.5);
   }
   */

  field.dispTiles();
  count = 0;
  background(0);

  //image(field.pgS, 0, 0); // tiles
}


void draw() {

  if (update) {
    count++;
    field.updateField(count*ns*1.5);
  }

  if (mousePressed && mouseButton == LEFT) {

    p = new Particle(new PVector(mouseX, mouseY), new PVector(0, random(-1, 1)).setMag(1.5), field, random(0.01*PI, 0.2*PI), 200);
    particles.add(p);
  }

  if (mousePressed && mouseButton == RIGHT) {
    saveFrame("img/cyanobacteria_####.png");
    background(0);
    particles.clear();
  }

  for (Particle p : particles) {

    if (frameCount%2==0) //visualizza la particella solo ogni 3 frames
      p.display(); 

    p.setOpacity();
    p.move();
  }
}


int states=0; // states range 0-3

void keyPressed() {  
  //if(key=="s") states = (states+1)%4; // % modulo rende una lista circolare
  //if (key=='d') discrete = !discrete;
  if (key=='l') lines = !lines;
  if (key ==' ') update = !update;
}