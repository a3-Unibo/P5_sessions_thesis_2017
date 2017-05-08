/*

 Code by Alessio Erioli
 
 (c) Co-de-iT 2017
 
 Just as day_03_06_agents_stig but rewritten for the Toxi libraries for the same reason
 as other sketches were: compatibility with the rest of the Toxi libraries
 
 */



import peasy.*;
import controlP5.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;


Agent a;
ArrayList<Agent> agents;
int nAgents = 500;
// Attractor t; // not used here, the class is here because Agent uses it
ArrayList<Vec3D> allTrails;
ArrayList<Connection> conns;

Vec3D world;
float wX = 800;
float wY = 600;
float wZ = 200;
PeasyCam cam;
ControlP5 c5;
boolean trailDisp=true;
boolean trailMode=true;
boolean rec = false;
boolean go = false;
boolean phase2 = false;
boolean dispBox = false;
float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity

AABB bBox;
ToxiclibsSupport gfx;
PointOctree trailOctree;


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

  // _____________________   octree for trails

  trailOctree = initOctree(new Vec3D(), new Vec3D(wX, wY, wZ), allTrails);


  conns = new ArrayList<Connection>();
  // t = new Attractor (new Vec3D(10, 30, -20), 200, .05);

  c5 = new ControlP5(this);
  initGui();
}

void draw() {
  background(248);
  checkOverlap();

  if (phase2) {
    for (Agent ag : agents) {
      ag.dispTrail(2);
    }
    for (Connection c : conns) {
      c.display();
    }
  } else {
    if (go) {

      for (Agent ag : agents) {
        //                 octree     cR, aR, sR, cI, aI, sI, use easing
        ag.octPointsFlock(trailOctree, 40, 0, 10, 0.1, 0, 1, false);
        
        // boundary behavior
        //ag.wrap();
        ag.bounce();
        
        ag.updateOcTrail(20, trailOctree);
        ag.move();
        ag.display();
        if (trailDisp) {
          if (trailMode) ag.dispTrailCurve();
          //else ag.dispTrailV(3);
          else ag.dispTrail(2);
        }
      } // end for (Agent ag : agents)
    } else { // just display
      for (Agent ag : agents) {
        ag.display();
        if (trailDisp) {
          if (trailMode) ag.dispTrailCurve();
          //else ag.dispTrailV(3);
          else ag.dispTrailCol(color (0, 180), color(230, 100, 230, 180), 2);
        }
      } // end for (Agent ag : agents)
    }
  }

  //noStroke();
  if (dispBox) {
    noFill();
    stroke(0, 60);
    strokeWeight(0.5);
    box(world.x, world.y, world.z);
  }

  if (keyPressed && key == 'i') saveFrame("img/flock_####.png");
  if (rec) {
    saveFrame("video/flock_stig_####.jpg");
  }

  dispGUI();
} // end draw

void keyPressed() {
  if (key == 'i') saveFrame("img/flockOct_####.png");
  if (key == 'r') rec = !rec;
  if (key == 'T') trailDisp = !trailDisp;
  if (key == 't') trailMode = !trailMode;
  if (key=='b') dispBox = !dispBox;
  if (key == ' ' && !phase2) go = !go;
  if (key == '2') {
    if (!phase2) {
      conns = connectTrails(trailOctree, agents, 15, PI*0.25);
      phase2 = true;
      go = false;
    }
  }
}