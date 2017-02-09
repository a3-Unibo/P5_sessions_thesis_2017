class Attractor {
  PVector pos;
  float radius, charge, rr;

  Attractor(PVector pos, float radius, float charge) {
    this.pos=pos;
    this.radius=radius;
    this.charge=charge;
    rr= radius*radius;
  }
  
  void display(){ //per visualizzare l'attrattore
  stroke(255,0,0);
  strokeWeight(5);
  point(pos.x, pos.y, pos.z);
  }
}