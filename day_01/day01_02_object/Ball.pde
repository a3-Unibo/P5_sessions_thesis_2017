class Ball {

  // fields
  PVector pos, vel, acc, spin;
  float diam, vMag;
  color col, oldCol = color(128);
  int lifeSpan, lives;
  float age = 1, aging;

  // constructor(s) // dati da elaborare internamente che vengono dall'esterno
  Ball(PVector _pos, PVector _vel, PVector _acc, float _diam, color _col) {
    pos = _pos;
    vel = _vel;
    acc = _acc;
    diam = _diam;
    col = _col;
    spin = PVector.random2D();
    lifeSpan = 300;
    lives = 3;
    aging = 1.0/lifeSpan;
    // println(aging);
    vel.mult(diam*0.4);
    vMag = vel.mag();
  }

  Ball(PVector _pos, PVector _vel, PVector _acc) {
    this(_pos, _vel, _acc, 10, color(c)); // chiamata dei valori*
  }

  // methods or behaviors
  void update() {    
    if (age > 0) {
      //moveRand();
      moveRot();
      age-=aging;
    } else {
      if (lives > 1) {
        lives --;
        respawn(rad);
      }
    }
  }

  void respawn(float rad) {
    age = 1;
    vel.setMag(vMag);
    pos = PVector.random2D();
    pos.mult(random(rad));
    pos.add(new PVector(width*.5, height*.5));
  }

  void moveRand() {
    // spin = PVector.random2D();
    // acc.add(spin);
    // vel.add(acc);
    vel = PVector.random2D();
    vel.mult(1.5);
    vel.limit(3);
    pos.add(vel);
  }

  void moveRot() {
    vel.rotate(random(-PI*0.5, PI*0.5)); //attorno all'asse z
    // vel.mult(1.5);
    vel.limit(5*pow(age,2));
    pos.add(vel);
  }


  void display() {
    stroke(0);
    strokeWeight(0.5);
    fill(lerpColor(oldCol, col, age));
    float d = map(age, 0, 1, 5, diam); // map prende 5 valori, valore della variabile di partenza e il valore della variabile di arrivo, ultimo valore è valore intermedio della variabile di partenza
    ellipse(pos.x, pos.y, d, d);
  }
}