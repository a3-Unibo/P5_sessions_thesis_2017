/*
Field class implementation with diffusion and Laplacian
 Also rewritten for Toxi classes
 
 */

import toxi.geom.*;

float res = 10.0;
float ns = 0.0045; // 0.0035
float diffRate = 0.05;
int nX, nY, count;
Field2D field;

boolean discrete = false;
boolean lines = true;
boolean update = false;
PImage fIm;

PGraphics pg;

void setup() {
  size(1400, 700, P2D);
  //fullScreen(P2D);
  pg = createGraphics(width, height);
  nX = int(width/res);
  nY = int(height/res);
  noiseSeed(10);
  noiseDetail(3);
  field = new Field2D(res, res, ns, true);
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
    field.diffusion(1, diffRate);
    //field.updateNoiseField(count*ns*1.5);
  }
  if (discrete) {
    field.dispTilesDiscrete();
  } else {
    field.dispTiles();
    //field.dispImage();
    if (lines)field.dispLines(res*1.5);
  }


  if (mousePressed) field.setScalarValue(new Vec3D(mouseX, mouseY, 0), 
    mouseButton==LEFT?0:1);

  image(field.pgS, 0, 0); // tiles


  //fIm = field.image.get();
  //fIm.resize(width, height);
  //image(fIm, 0, 0); // gets the raster image of the field

  //fill(field.evalScalar(new Vec3D(mouseX, mouseY,0))*255);
  //ellipse(mouseX, mouseY, 30,30);
}

void keyPressed() {
  if (key=='d') discrete = !discrete;
  if (key=='l') lines = !lines;
  if (key ==' ') update = !update;
  if (key=='i') saveFrame("imgs/field_####.png");
}