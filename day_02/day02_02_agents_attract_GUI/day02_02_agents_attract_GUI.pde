import peasy.*;
import controlP5.*;


Agent a;
ArrayList<Agent> agents;
int nAgents = 1000;
Attractor t;

PVector world;
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
  print(width + " " + height);
  cam = new PeasyCam(this, 1000); // camera in 3D // this fa riferimento al contesto generale su cui io sto operando. primo parametro è il p-applet


  rectMode(CENTER);
  world = new PVector(wX, wY, wZ);

  sR = 5;
  sI = 1;
  cR= 80; //200
  cI=0.05;
  aR= 40;
  aI = 0.1;

  agents = new ArrayList<Agent>();
  for (int i=0; i< nAgents; i++) {
    a = new Agent(new PVector(random(-wX*0.5, wX*0.5 ), random(-wY*0.5, wY*0.5 ), random(-wZ*0.5, wZ*0.5 )), 
      PVector.random3D().mult(random(3)), world);

    //a=new Agent(new PVector(), PVector.random3D(), world);
    agents.add(a);
  }

  t = new Attractor (new PVector(10, 30, -20), 100, .1);

  c5 = new ControlP5(this);
  initGui();
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
    ag.update();
    ag.display();
    if (trailDisp) {
      if (trailMode) ag.dispTrailCurve();
      else ag.dispTrail();
    }
  } // end for (Agent ag : agents)


  noFill();
  stroke(0);
  strokeWeight(1);
  box(wX, wY, wZ);

  dispGUI();
} // end draw

void keyPressed() {
  if (key == 'i') saveFrame("img/flock_####.png");
  if (key == 'T') trailDisp = !trailDisp;
  if (key == 't') trailMode = !trailMode;
  if (key=='a') attract = !attract;
}