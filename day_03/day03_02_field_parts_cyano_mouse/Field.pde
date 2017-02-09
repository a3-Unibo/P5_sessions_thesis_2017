class Field {
  float[][] scalar;
  PVector[][] vector;
  float resX, resY, ns;
  int cols, rows;
  PGraphics pgS, pgV;

  Field(float resX, float resY, float ns) {
    this.resX = resX;
    this.resY = resY;
    this.ns = ns;
    cols = int(width/resX);
    rows = int(height/resY);

    scalar = new float[cols][rows];
    vector = new PVector[cols][rows];
    pgS = createGraphics(width, height, P2D);
    pgV = createGraphics(width, height, JAVA2D);

    initField();
  }

  Field(int rows, int cols, float ns) {
    this.rows = rows;
    this.cols = cols;
    this.ns = ns;
    resX = width/(float)cols;
    resY = height/(float)rows;

    scalar = new float[cols][rows];
    vector = new PVector[cols][rows];
    pgS = createGraphics(width, height, P2D);
    pgV = createGraphics(width, height, JAVA2D);

    initField();
  }

  Field(float[][] scalar, PVector[][] vector) {
    this.scalar = scalar;
    this.vector = vector;
    this.rows = scalar.length;
    this.cols = scalar[0].length;
    this.resX = width/this.cols;
    this.resY = height/this.rows;
  }

  void initField() {
    float ang;
    for (int i=0; i< cols; i++) {
      for (int j=0; j<rows; j++) {
        scalar[i][j]= noise(i*resX*ns, j*resY*ns);
        ang = map(scalar[i][j], 0, 1, 0, TWO_PI);
        vector[i][j] = new PVector(cos(ang), sin(ang));
      }
    }
  }

  void updateField(float t) {
    float ang;
    for (int i=0; i< cols; i++) {
      for (int j=0; j<rows; j++) {
        scalar[i][j]= noise(i*resX*ns, j*resY*ns, t);
        ang = map(scalar[i][j], 0, 1, 0, TWO_PI);
        vector[i][j] = new PVector(cos(ang), sin(ang));
      }
    }
  }

  float evalScalar(PVector p) {
    int i = int(constrain(p.x/resX, 0, cols-1));
    int j = int(constrain(p.y/resY, 0, rows-1));
    return scalar[i][j];
  }

  PVector evalVector(PVector p) {
    int i = int(constrain(p.x/resX, 0, cols-1));
    int j = int(constrain(p.y/resY, 0, rows-1));
    return vector[i][j];
  }


  void dispTiles() {
    pgS.beginDraw();
    pgS.clear();
    //pgS.stroke(0);
    pgS.noStroke();
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        pgS.fill(color(255*scalar[i][j]));
        pgS.rect(i*resX, j*resY, resX, resY);
      }
    }
    pgS.endDraw();
  }

  void dispTilesDiscrete() {
    pgS.beginDraw();
    pgS.clear();
    pgS.rectMode(CENTER);
    pgS.stroke(255);
    pgS.noFill();
    int s;
    //pgS.noStroke();
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        s = int(scalar[i][j]*7);
        if (s>0 && s<=1) {
          pgS.point(i*resX+resX*0.5, j*resY+resY*0.5); // point
        } else if (s>1 && s<=2) {
          pgS.line(i*resX+resX*0.3, j*resY+resY*0.7, i*resX+resX*0.7, j*resY+resY*0.3); // first diag
        } else if (s>2 && s<=3) {
          pgS.line(i*resX+resX*0.3, j*resY+resY*0.7, i*resX+resX*0.7, j*resY+resY*0.3); // first diag
          pgS.line(i*resX+resX*0.3, j*resY+resY*0.3, i*resX+resX*0.7, j*resY+resY*0.7); // second diag
        } else if (s>3) {
          pgS.rect(i*resX+resX*0.5, j*resY+resY*0.5, resX*0.85, resY*0.85); // square
        }
      }
    }
    pgS.endDraw();
  }

  void dispLines(float len) {
    pgV.beginDraw();
    pgV.clear();
    float x, y;
    PVector p;
    pgV.stroke(255);
    pgV.strokeWeight(1);
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        x = i*resX + resX*0.5;
        y = j*resY + resY*0.5;
        p = PVector.mult(vector[i][j], len);
        pgV.line(x, y, x+p.x, y+p.y);
      }
    }
    pgV.endDraw();
  }
} // end class Field