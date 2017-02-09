import peasy.*;
import controlP5.*;
import toxi.geom.*;
import toxi.geom.mesh.*;


Agent a;
ArrayList<Agent> agents;
int nAgents = 2000;
Attractor t;

Vec3D world;
float wX = 800;
float wY = 600;
float wZ = 200;
PeasyCam cam;
ControlP5 c5;
boolean trailDisp=false;
boolean trailMode=false;
boolean attract = false;
float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity


void setup() {
  size(1660, 1000, P3D); // motore di render 3D
  //surface.setSize(displayWidth-20, displayHeight-50);

  cam = new PeasyCam(this, 1000); // camera in 3D // this fa riferimento al contesto generale su cui io sto operando. primo parametro è il p-applet


  rectMode(CENTER);
  world = new Vec3D(wX, wY, wZ);

  sR = 5;
  sI = 1;
  cR= 80; //200
  cI= 0.05;
  aR= 20;
  aI = 0.05;

  agents = new ArrayList<Agent>();
  for (int i=0; i< nAgents; i++) {
    a = new Agent(new Vec3D(random(-wX*0.5, wX*0.5 ), random(-wY*0.5, wY*0.5 ), random(-wZ*0.5, wZ*0.5 )), 
      Vec3D.randomVector().scale(3), world);
    agents.add(a);
  }
  c5 = new ControlP5(this);
  initGui();
  t = new Attractor (new Vec3D(10, 30, -20), 200, .05);
}

void draw() {
  background(248);
  checkOverlap();

  for (Agent ag : agents) {// < altro modo di iterare 
    if (attract) {
      ag.seek(t);
      t.display(); //per visualizzare l'attrattore
      t.displayRad();
    }
    ag.update(agents);
    ag.display();
    if (trailDisp) {
      if (trailMode) ag.dispTrailCurve();
      else ag.dispTrail();
    }
  } // end for (Agent ag : agents)

  //noStroke();
  noFill();
  stroke(0);
  strokeWeight(1);
  //rect(0, 0, wX, wY);
  box(wX, wY, wZ);

  dispGUI();
} // end draw

void keyPressed() {
  if (key == 'i') saveFrame("img/flock_####.png");
  if (key == 'T') trailDisp = !trailDisp;
  if (key == 't') trailMode = !trailMode;
  if (key=='a') attract = !attract;
}