import peasy.*;
import controlP5.*;
import toxi.geom.*;


Agent a;
ArrayList<Agent> agents;
int nAgents = 500;
Attractor t;
ArrayList<PVector> trails;
ArrayList trails2;

PVector world;
float wX = 800;
float wY = 600;
float wZ = 200;
PeasyCam cam;
ControlP5 c5;
boolean tCount=true;
boolean trailMode=true;
float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity


void setup() {
  size(1000, 700, P3D); // motore di render 3D
  //surface.setSize(displayWidth-20, displayHeight-50);
  print(width + " " + height);
  cam = new PeasyCam(this, 800); // camera in 3D // this fa riferimento al contesto generale su cui io sto operando. primo parametro è il p-applet


  rectMode(CENTER);
  world = new PVector(wX, wY, wZ);

  sR = 5;
  sI = .2;
  cR= 80; //200
  cI= 0.5;
  aR= 20;
  aI = 0.1;

  agents = new ArrayList<Agent>();
  for (int i=0; i< nAgents; i++) {
    a = new Agent(new PVector(random(-world.x*0.5, world.x*0.5 ), random(-world.y*0.5, world.y*0.5 ),
    random(-world.z*0.5, world.z*0.5 )), PVector.random3D().mult(random(3)), world);

    //a=new Agent(new PVector(), PVector.random3D(), world);
    agents.add(a);
  }
  trails = new ArrayList<PVector>();
  trails2 = new ArrayList();
  
  c5 = new ControlP5(this);
  initGui();
  t = new Attractor (new PVector(10, 30, -20), 200, .05);
}

void draw() {
  background(248);
  checkOverlap();
  
  for (Agent ag:agents){
   // trails2.add(ag.trail);
   trails.addAll(ag.trail);
  }

  // ArrayList<PVector> tr = (ArrayList<PVector>)trails2.get(0);

  for (Agent ag : agents) {// < altro modo di iterare 
    // if (mousePressed)ag.seek(t);
    //ag.update();
    ag.trailCohesion(trails, 100,1);
    ag.wrap();
    ag.updateTrail(10);
    ag.move();
    ag.display();
    if (tCount) {
      if (trailMode) ag.dispTrailCurve();
      else ag.dispTrail();
    }
  } // end for (Agent ag : agents)
  
  trails.clear();

  t.display(); //per visualizzare l'attrattore
  //noStroke();
  noFill();
  stroke(0);
  strokeWeight(1);
 
  box(world.x, world.y, world.z);

  dispGUI();
} // end draw

void keyPressed() {
  if (key == 'i') saveFrame("img/flock_####.png");
  if (key == 'T') tCount = !tCount;
  if (key == 't') trailMode = !trailMode;
}