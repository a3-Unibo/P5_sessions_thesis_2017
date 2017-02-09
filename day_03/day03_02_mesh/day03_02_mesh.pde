import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*; //consente di importare solo mesh triangolate, basta esportare come STL
//scale di -1 nella vista per specchiare la vista in processing, non c'è bisogno di cambiare il sistema di coordinate
//nell'importazione da rhino a processing

import peasy.*;

PeasyCam cam;

PFont font;

TriangleMesh mesh;
ToxiclibsSupport gfx;
int viewMode;
Vec3D norm;
Vec3D vS;
int nVerts, id=0;

void setup() {
  size(1000, 700, P3D);
  viewMode = 0;
  cam = new PeasyCam(this, 200);


  // fine tune the camera settings
  float fov = PI/3.0; // stare tra i 2 e i 4
  float cameraZ = (height/2.0) / tan(fov/2.0);
  // fov, ratio, near clip, far clip
  perspective(fov, float(width)/float(height), cameraZ/100.0, cameraZ*100.0);
  
  // create a font for a better text display - install Open Sans if you haven't already
  // or use "Arial" instead
  font =createFont("Open Sans", 50);
  textFont(font);
  textSize(5);

  gfx = new ToxiclibsSupport(this);
  mesh = new TriangleMesh();

  mesh.addMesh(new STLReader().loadBinary(sketchPath("data/spheres_fused.stl"), 
    STLReader.TRIANGLEMESH)); // STLReader è una classe senza costruttori, è una collezione di funzioni

  mesh.scale(5);
  nVerts = mesh.vertices.size();
  vS = mesh.getVertexForID(id);
}

void draw() {
  background (220);
  lights();
  //scale(1, -1.1); // serve per parificare i sistemi di riferimento, questo con quello di rhino

  switch(viewMode) { //come gate in GH
  case 0:
    pushStyle();
    fill(255);
    stroke(0, 100, 100, 100);
    gfx.mesh(mesh, true);
    popStyle();
    break;
  case 1:
    pushStyle();
    noStroke();
    gfx.meshNormalMapped(mesh, true);
    int i=0;
    stroke(0);
    for (Vertex v : mesh.vertices.values()) {
      norm = v.normal.scale(0.2); // normals are a field of Vertex
      line(v.x, v.y, v.z, v.x+norm.x, v.y+norm.y, v.z+norm.z);
      i++;
    }
    popStyle();
    break;
  case 2:
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(2);
    for (Vertex v : mesh.vertices.values()) {
      point(v.x, v.y, v.z);
    }
    popStyle();
    break;
  }

  noLights();
  pushMatrix();
  pushStyle();
  //translate(vS.x, vS.y, vS.z);
  alignAtPoint(vS, cam);
  stroke(0);
  strokeWeight(5);
  point(0, 0, 0);
  fill(0);
  text(" __________________ this is vertex "+id, 0, 0);
  popStyle();
  popMatrix();
}

void keyPressed() {
  if (key=='m') viewMode = (viewMode+1)%3;
  if (key=='v') {
    id= (id+1)%nVerts;
    vS = mesh.getVertexForID(id);
  }
}