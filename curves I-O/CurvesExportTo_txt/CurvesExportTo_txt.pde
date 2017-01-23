/*

 TXT export function
 
 exports curves (as Vec3D ArrayLists) to txt file
 
 
 */

import toxi.geom.*;
import peasy.*;

PeasyCam cam;
ArrayList curves;
ArrayList <Vec3D> pts;
Vec3D v;
float sc=0.005; // scales noise function
float maxSpeed; // max speed for particles
int count, crvLen = 200;
int nCurves = 100;

void setup() {

  //.....
  size(800, 800, P3D);
  cam = new PeasyCam(this, -180, 180, 0, 800);
  //frameRate(30);

  // init curves
  curves = new ArrayList();

  for (int i=0; i< nCurves; i++) {
    pts = new ArrayList<Vec3D>();
    v = new Vec3D(random(-100, 100), random(-100, 100), 0);
    pts.add(v);
    curves.add(pts);
  }

  noFill();

  // sets noise parameters
  noiseDetail(1, 0.1); 
  noiseSeed(140);
  maxSpeed = random(5, 10);
  count =0;
  pts = new ArrayList<Vec3D>();
}


void draw() {
  background(221);

  // .........................  update curves ........................

  if (count < crvLen) {
    for (int i=0; i<curves.size (); i++) {
      pts = (ArrayList<Vec3D>) curves.get(i);
      v = pts.get(pts.size()-1);
      Vec3D v1 = new Vec3D(v);
      v1 = moveNoiseRot(v);
      pts.add(new Vec3D(v1));
    }
    count++;
  }


  // .........................  display curves ........................

  for (int i=0; i<curves.size (); i++) {
    pts = (ArrayList<Vec3D>) curves.get(i);

    // curve
    beginShape();
    for (int j=0; j< pts.size (); j++) {
      Vec3D vc = pts.get(j);
      vertex(vc.x, vc.y, vc.z);
    }
    endShape();
    strokeWeight(3);

    // points
    for (int j=0; j< pts.size (); j++) {
      Vec3D vc = pts.get(j);
      stroke(color(lerpColor(color(0, 200, 255), color(255), float(j)/pts.size())));
      point(vc.x, vc.y, vc.z);
    }
    stroke(0);
    strokeWeight(1);
  }
}

Vec3D moveNoiseRot(Vec3D loc) {
  Vec3D speed = new Vec3D(0, 0, maxSpeed*.5);
  speed = new Vec3D(0, 0, maxSpeed*.5);
  speed.rotateX(noise(0, loc.y*sc, loc.z*sc)*TWO_PI);
  speed.rotateY(noise(1, loc.x*sc, loc.z*sc)*TWO_PI);
  speed.rotateZ(noise(2, loc.x*sc, loc.y*sc)*TWO_PI);
  loc.addSelf(speed);
  return loc;
}

void keyPressed() {

  // export as txt, use '_' as point separator and ',' as coordinates separator
  //
  if (key=='e') exportCurvesAsTxt(curves, "curves", new Vec3D(), new Vec3D(1, 1, 1), ",","_");
}