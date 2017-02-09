/*
A simple field class used with Perlin noise

*/

float res = 10.0;
float ns = 0.0035;
int nX, nY, count;
Field field;
boolean discrete = false;
boolean lines = true;
boolean update = false;

PGraphics pg;

void setup() {
  size(1400, 700, P2D);
  //fullScreen(P2D);
  pg = createGraphics(width, height);
  nX = int(width/res);
  nY = int(height/res);
  noiseSeed(10);
  noiseDetail(3);
  field = new Field(res, res, ns);
  //field = new Field(90,160,ns);
  ellipseMode(CENTER);

  //noStroke();
  strokeWeight(.5);
  stroke(255);
  if (discrete) {
    field.dispTilesDiscrete();
  } else {
    field.dispTiles();
    if (lines)field.dispLines(res*0.5);
  }
  
  count = 0;
}

void draw() {
  background(0);
  if (update) {
    count++;
    field.updateField(count*ns*1.5);
  }
  if (discrete) {
    field.dispTilesDiscrete();
  } else {
    field.dispTiles();
    if (lines)field.dispLines(res*0.5);
  }

  image(field.pgS, 0, 0); // tiles
  if (!discrete && lines)image(field.pgV, 0, 0); // lines
  //fill(field.evalScalar(new PVector(mouseX, mouseY))*255);
  //ellipse(mouseX, mouseY, 30,30);
}

void keyPressed() {
  if (key=='d') discrete = !discrete;
  if (key=='l') lines = !lines;
  if (key ==' ') update = !update;
}