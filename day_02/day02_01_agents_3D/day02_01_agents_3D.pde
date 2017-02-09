import peasy.*;

Agent a;
ArrayList<Agent> agents;
int nAgents = 1000;
PVector t, world;
float wX = 800;
float wY = 600;
float wZ = 200;
boolean tCount=false;
boolean trailMode=false;

PeasyCam cam;

void setup() {
  size(1660, 1000, P3D); // motore di render 3D
  //surface.setSize(displayWidth-20, displayHeight-50);
  print(width + " " + height);
  cam = new PeasyCam(this, 1000); // camera in 3D // this fa riferimento al contesto generale su cui io sto operando. primo parametro è il p-applet
  rectMode(CENTER);


  world = new PVector(wX, wY, wZ);

  agents = new ArrayList<Agent>();
  for (int i=0; i< nAgents; i++) {
    a = new Agent(new PVector(random(-wX*0.5, wX*0.5 ), random(-wY*0.5, wY*0.5 ), random(-wZ*0.5, wZ*0.5 )), 
      PVector.random3D().mult(random(3)), world);

    //a=new Agent(new PVector(), PVector.random3D(), world);
    agents.add(a);
  }
  t = new PVector(10, 10);
}

void draw() {
  background(248);
  t = new PVector(mouseX, mouseY);
  for (Agent ag : agents) {// < altro modo di iterare 
    if (mousePressed)ag.seek(t);
    ag.update();
    ag.display();
    if (tCount) {
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
  
  cam.beginHUD();
  textSize(10);
  fill(255,0,0);
  text(frameCount,10,height-10);
  cam.endHUD();
} // end draw

void keyPressed() {
  if (key == 'i') saveFrame("img/flock_####.png");
  if (key == 'T') tCount = !tCount;
  if (key == 't') trailMode = !trailMode;
}