/*

Code by Alessio Erioli

(c) Co-de-iT 2017

2D particles on stigmergic interaction


*/

float res = 5.0;
float ns = 0.008;
int nX, nY, count;

boolean discrete = false;
boolean go = true;
boolean dispPart = true;

Field field;
Particle p;

ArrayList<Particle> particles;
int nParticles = 200;


void setup() {
  size(1200, 800, P2D);
  //fullScreen(P2D);

  nX = int(width/res);
  nY = int(height/res);
  noiseSeed(10);
  noiseDetail(1);
  field = new Field(res, res, ns);
  ellipseMode(CENTER);

  //noStroke();
  strokeWeight(.5);
  stroke(255);

  particles = new ArrayList<Particle>();


  for (int i=0; i< nParticles; i++) {
    p = new Particle(new PVector(random(width), random(height)), 
      PVector.random2D().setMag(1.5), field, random(0.01*PI, 0.2*PI), 200);

    particles.add(p);
  }

  background(0);
}



void draw() {

  if (go) {
    if (discrete) {
      field.dispTilesDiscrete();
    } else {
      field.dispTiles();
    }
  }

  image(field.pgS, 0, 0);

  if (go) {
    for (Particle p : particles) {
      //p.moveStigSample();
      p.moveStig();
      p.wrap();
      if (dispPart) p.display();
    }

    field.evapLin(0.0007);
    //field.evapLin(0.0005);
  }

}


void keyPressed() {  

  if (key=='d') discrete = !discrete;
  if (key=='p') dispPart = !dispPart;
  if (key=='i') saveFrame("img/stig2D_####.png");
  if (key ==' ') go = !go;
}