/*

 curve import function from txt
 
 imports curves (as Vec3D ArrayLists) from .txt files
 
 
 */

import toxi.geom.*;
import peasy.*;

PeasyCam cam;
ArrayList curves;
ArrayList <Vec3D> pts;
Vec3D v;
String fileName = "curves.txt";
String cs = ",";
String ps = "_";


void setup() {

  //.....
  size(800, 800, P3D);
  cam = new PeasyCam(this, -180, 180, 0, 800);

  // init curves
  curves = importCurves(fileName, cs, ps);

  noFill();
}


void draw() {
  background(221);



  displayCrvs(curves);
}


// .........................  display curves function ........................

void displayCrvs(ArrayList curves) {
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