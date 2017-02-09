/*

Code by Alessio Erioli

(c) Co-de-iT 2017

Just as day_03_06_agents_stig but rewritten for the Toxi libraries for the same reason
as other sketches were: compatibility with the rest of the Toxi libraries

*/



import peasy.*;
import controlP5.*;
import toxi.geom.*;


Agent a;
ArrayList<Agent> agents;
int nAgents = 200;
// Attractor t; // not used here, the class is here because Agent uses it
ArrayList<Vec3D> allTrails;

Vec3D world;
float wX = 800;
float wY = 600;
float wZ = 200;
PeasyCam cam;
ControlP5 c5;
boolean tCount=true;
boolean trailMode=true;
boolean rec = false;
float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity


void setup() {
  size(1400, 900, P3D); 
  //fullScreen(P3D,2);
  //surface.setSize(displayWidth-20, displayHeight-50);

  cam = new PeasyCam(this, 800); 

  rectMode(CENTER);
  world = new Vec3D(wX, wY, wZ);

  sR = 5;
  sI = .2;
  cR= 80; //200
  cI= 0.5;
  aR= 20;
  aI = 0.1;

  agents = new ArrayList<Agent>();
  for (int i=0; i< nAgents; i++) {
    a = new Agent(new Vec3D(random(-world.x*0.5, world.x*0.5 ), random(-world.y*0.5, world.y*0.5 ), 
      random(-world.z*0.5, world.z*0.5 )), Vec3D.randomVector().scale(random(3)), world);

    //a=new Agent(new PVector(), PVector.random3D(), world);
    agents.add(a);
  }
  
  allTrails = new ArrayList<Vec3D>();

  // t = new Attractor (new Vec3D(10, 30, -20), 200, .05);

  c5 = new ControlP5(this);
  initGui();
}

void draw() {
  background(248);
  checkOverlap();

  // collect trail points from all agents
  for (Agent ag : agents) {
    allTrails.addAll(ag.trail);
  }

  for (Agent ag : agents) {

    //ag.update();
    ag.pointsCohesion(allTrails, 100, 1);
    ag.wrap();
    ag.updateTrail(10);
    ag.move();
    ag.display();
    if (tCount) {
      if (trailMode) ag.dispTrailCurve();
      else ag.dispTrailV(3);
    }
  } // end for (Agent ag : agents)

  allTrails.clear();

  //noStroke();
  noFill();
  stroke(0, 60);
  strokeWeight(0.5);
  box(world.x, world.y, world.z);

  if (keyPressed && key == 'i') saveFrame("img/flock_####.png");
  if (rec) {
    saveFrame("video/flock_stig_####.jpg");
  }

  //dispGUI();
} // end draw

void keyPressed() {
  //if (key == 'i') saveFrame("img/flock_####.png");
  if (key == 'r') rec = !rec;
  if (key == 'T') tCount = !tCount;
  if (key == 't') trailMode = !trailMode;
}