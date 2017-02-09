/*

 simple use of Toxi planes
 
 */

import toxi.geom.*;
import toxi.processing.*;
import peasy.*;

int nParts = 3000;
float rad = 400, pSize;
Particle[] parts;
ToxiclibsSupport gfx;
PeasyCam cam;

void setup() {

  size(800, 800, P3D);

  cam = new PeasyCam(this, 1000);
  gfx = new ToxiclibsSupport(this);

  parts = new Particle[nParts];


  for (int i=0; i<nParts; i++) {
    parts[i] = new Particle(Vec3D.randomVector().scale(random(rad*0.2, rad)), Vec3D.randomVector());
  }
}

void draw() {
  background(60);
  for (int i=0; i<parts.length; i++) {
    //parts[i].alignWithNeighbor(parts);
    parts[i].alignWithNeighbors(parts,80);
    parts[i].displayPos();
    parts[i].displayVel(10);
    stroke(0);
    strokeWeight(1);
    //pSize = 5+noise((i+frameCount)*.005)*20;
    pSize = 15;
    //gfx.mesh(parts[i].plane.toMesh(pSize));
    noStroke();
    gfx.meshNormalMapped(parts[i].plane.toMesh(pSize), false);
  }
  gfx.origin(20);
}