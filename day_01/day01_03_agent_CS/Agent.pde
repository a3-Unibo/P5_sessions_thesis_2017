class Agent {

  PVector pos, vel, acc; //field
  float maxVel, maxForce;
  float cR, cI, sR, sI, aR, aI; //cohesion & separation radius & intensity

  Agent(PVector pos, PVector vel) { //costruttore
    this.pos = pos; // significa che deve prendere quello della classe e non quello della funzione
    this.vel = vel;
    acc = new PVector();
    maxVel = 1.5;
    maxForce = 0.01;
    sR = 5;
    sI = 1;
    cR = 200;
    cI = 0.05;
    aR = 50;
    aI = 0.05;
  }

  void update() {
    flock(Agents);
    move();
    bounce();
  }

  void flock(ArrayList<Agent>Agents) {
    separate(Agents);
    cohesion(Agents);
  }

  void cohesion(ArrayList<Agent>Agents) {
    int count=0;
    PVector t= new PVector();
    float dist, easing;
    for (Agent other : Agents) {
      dist = (pos.dist(other.pos));
      if (dist>0 && dist<cR) {
        count++;
        t.add(other.pos);
      }
    }
    if (count>0) {
      t.mult(1.0/count);
      PVector des = PVector.sub(t, pos); // sottrazione tra vettori //pos.sub(t) //modalità statica 
      dist = des.mag();
      easing = 1-(cR-dist)/cR; //stronger when far
      des.setMag(maxVel); // positive (cohesion)
      PVector steer = PVector.sub(des, vel);
      steer.setMag(cI*easing); // oppure (cI)
      acc.add(steer);
    }
  }
  
////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

//  void alignment(ArrayList<Agent>Agents) {


  void separate(ArrayList<Agent> Agents) {
    int count=0;
    PVector t= new PVector();
    float dist, easing;
    for (Agent other : Agents) {
      dist = (pos.dist(other.pos));
      if (dist>0 && dist<sR) {
        count++;
        t.add(other.pos);
      }
    }
    if (count>0) {
      t.mult(1.0/count);
      PVector des = PVector.sub(t, pos); // sottrazione tra vettori //pos.sub(t) //modalità statica 
      dist = des.mag();
      easing = (sR-dist)/sR;
      des.setMag(maxVel*-1); // negative
      PVector steer = PVector.sub(des, vel);
      steer.setMag(sI*easing);
      acc.add(steer);
    }
  }

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

  void move() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc = new PVector();
  }

  void seek(PVector t) {
    PVector des = PVector.sub(t, pos); // sottrazione tra vettori //pos.sub(t) //modalità statica 
    des.setMag(maxVel);
    PVector steer = PVector.sub(des, vel);
    steer.setMag(maxForce);
    acc.add(steer);
    // return steer; // return può essere eseguito da un nome di una variabile purchè torni con il tipo di dati indicato nella funzione
  }

  void bounce() {
    if (pos.x > width || pos.x<0) vel.x*=-1;
    if (pos.y > height || pos.y<0) vel.y*=-1;
  }

  void display() {
    float vM = vel.mag()/maxVel;
    stroke(lerpColor(color(255, 0, 0), color(255), vM));
    strokeWeight(0.5);
    //ellipse(pos.x, pos.y, sR, sR);
    strokeWeight(2);
    point(pos.x, pos.y);
  }
}