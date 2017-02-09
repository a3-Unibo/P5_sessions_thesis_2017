/*

 import points and vectors from .txt files
 
 
 */

import toxi.geom.*;
import peasy.*;

PeasyCam cam;
ArrayList lines;
Vec3D[]pts, vecs;
Vec3D v;
String fileName = "curves.txt";
String cs = ",";
String ps = "_";


void setup() {

  //.....
  size(800, 800, P3D);
  cam = new PeasyCam(this, 400);

  // init curves
  //curves = importCurves(fileName, cs, ps);

  pts = importPtsArray("points.txt");
  vecs = importPtsArray("vectors.txt");

  lines = new ArrayList();

  findConnections(pts, vecs, 30, PI*.2);

  noFill();
}


void draw() {
  background(248);

  for (int i=0; i<pts.length; i++) {
    stroke(0);
    strokeWeight(2);
    point(pts[i].x, pts[i].y, pts[i].z);
    strokeWeight(1);
    stroke(180, 200);
    v = pts[i].add(vecs[i].scale(20));
    //line(pts[i].x, pts[i].y, pts[i].z, v.x, v.y, v.z);
  }



  if (lines.size()>0) {
    // display connection lines
    dispConnections();
  }

  //displayCrvs(curves);
}


// .........................  display curves function ........................

void displayCrvs(ArrayList curves) {
  ArrayList<Vec3D> pts;
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
      stroke(color(lerpColor(color(0, 220, 10), color(255), float(j)/pts.size())));
      point(vc.x, vc.y, vc.z);
    }
    stroke(0);
    strokeWeight(1);
  }
}

void findConnections(Vec3D[] pts, Vec3D[] vecs, float rad, float ang) {
  float rr = rad*rad;

  Vec3D dir;
  int cCount;
  for (int i=0; i< pts.length; i++) {
    cCount=0;
    for (int j=0; j< pts.length; j++) {
      if (i!=j ) { // not incestuous
        if (pts[i].distanceToSquared(pts[j])<rr) {// if within distance
          dir = pts[j].sub(pts[i]); // direction vector to target
          if (cCount<1+random(2) && vecs[i].angleBetween(dir, true)<ang) {
            Vec3D[] line = {pts[i].copy(), pts[j].copy()};
            lines.add(line);
            cCount++;
          }
        }
      }
    }
  }
}

void dispConnections() {
  stroke(255,0,0);
  strokeWeight(1);
  for (int i=0; i<lines.size(); i++) {
    Vec3D[] line = (Vec3D[]) lines.get(i);
    line(line[0].x, line[0].y, line[0].z, line[1].x, line[1].y, line[1].z);
  }
}

void keyPressed(){
if (key=='e') exportCurvesAsTxt(lines,"lines",new Vec3D(), new Vec3D(1,1,1),",","_");
}