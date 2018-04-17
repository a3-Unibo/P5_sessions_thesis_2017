class Field {
  float[][] scalar;
  PVector[][] vector;
  float resX, resY, ns;
  int cols, rows;
  boolean sy;
  PGraphics pgS, pgV;

  Field(int w, int h, float resX, float resY, float ns, boolean sy) {
    this.resX = resX;
    this.resY = resY;
    this.ns = ns;
    this.sy = sy;
    cols = int(w/resX);
    rows = int(h/resY);

    scalar = new float[cols][rows];
    vector = new PVector[cols][rows];
    pgS = createGraphics(sy?w*2:w, h, P2D);
    pgV = createGraphics(sy?w*2:w, h, JAVA2D);

    initField();
  }

  Field(int w, int h, int rows, int cols, float ns, boolean sy) {
    this.rows = rows;
    this.cols = cols;
    this.ns = ns;
    this.sy = sy;
    resX = w/(float)cols;
    resY = h/(float)rows;

    scalar = new float[cols][rows];
    vector = new PVector[cols][rows];
    pgS = createGraphics(sy?w*2:w, h, P2D);
    pgV = createGraphics(sy?w*2:w, h, JAVA2D);

    initField();
  }

  Field(int w, int h, float[][] scalar, PVector[][] vector, boolean sy) {
    this.scalar = scalar;
    this.vector = vector;
    this.rows = scalar.length;
    this.cols = scalar[0].length;
    this.sy = sy;
    this.resX = sy?w*2:w/this.cols;
    this.resY = h/this.rows;
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
    if (sy) {
      for (int i=0; i< cols; i++) {
        for (int j=0; j< rows; j++) {
          pgS.fill(color(255*scalar[i][j]));
          pgS.rect((2*cols-1-i)*resX, j*resY, resX, resY);
        }
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
    if (sy) {
      int ind;
      for (int i=0; i< cols; i++) {
        for (int j=0; j< rows; j++) {
          s = int(scalar[i][j]*7);
          ind = (2*cols-1-i);
          if (s>0 && s<=1) {
            pgS.point(ind*resX+resX*0.5, j*resY+resY*0.5); // point
          } else if (s>1 && s<=2) {
            pgS.line(ind*resX+resX*0.3, j*resY+resY*0.7, ind*resX+resX*0.7, j*resY+resY*0.3); // first diag
          } else if (s>2 && s<=3) {
            pgS.line(ind*resX+resX*0.3, j*resY+resY*0.7, ind*resX+resX*0.7, j*resY+resY*0.3); // first diag
            pgS.line(ind*resX+resX*0.3, j*resY+resY*0.3, ind*resX+resX*0.7, j*resY+resY*0.7); // second diag
          } else if (s>3) {
            pgS.rect(ind*resX+resX*0.5, j*resY+resY*0.5, resX*0.85, resY*0.85); // square
          }
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

    if (sy) {
      for (int i=0; i< cols; i++) {
        for (int j=0; j< rows; j++) {
          x = (2*cols-1-i)*resX + resX*0.5;
          y = j*resY + resY*0.5;
          p = PVector.mult(vector[i][j], len);
          pgV.line(x, y, x+p.x, y+p.y);
        }
      }
    }
    pgV.endDraw();
  }
} // end class Field
