/*

 a field2D class
 code by Alessio Erioli & Alessandro Zomparelli (laplacian, diffusion)
 
 */

class Field2D {
  float[] scalar;
  Vec3D[] vector;
  float resX, resY, ns;
  int nX, nY;
  PGraphics pgS, pgV;
  PImage image;
  boolean isNoise;

  Field2D(float resX, float resY, float ns, boolean isNoise) {
    this.resX = resX;
    this.resY = resY;
    this.ns = ns;
    this.isNoise = isNoise;
    nX = int(width/resX);
    nY = int(height/resY);

    scalar = new float[nX*nY];
    vector = new Vec3D[nX*nY];
    pgS = createGraphics(width, height, P2D);
    pgV = createGraphics(width, height, JAVA2D);
    image = createImage(nX, nY, RGB);

    if (isNoise) initNoiseField();
  }

  Field2D(int nY, int nX, float ns) {
    this.nY = nY;
    this.nX = nX;
    this.ns = ns;
    resX = width/(float)nX;
    resY = height/(float)nY;

    scalar = new float[nX*nY];
    vector = new Vec3D[nX*nY];
    pgS = createGraphics(width, height, P2D);
    pgV = createGraphics(width, height, JAVA2D);

    initNoiseField();
  }

  Field2D(float[] scalar, Vec3D[] vector, int nY) {
    this.scalar = scalar;
    this.vector = vector;
    this.nY = nY;
    this.nX = scalar.length/nY;
    this.resX = width/this.nX;
    this.resY = height/this.nY;
  }

  // _____________________________________________ init methods

  void initNoiseField() {
    float ang;
    int i, j;
    for (int k=0; k< scalar.length; k++) {
      i = singleToTwo(k, nX)[0];
      j = singleToTwo(k, nX)[1];
      scalar[k]= noise(i*resX*ns, j*resY*ns);
      ang = map(scalar[k], 0, 1, 0, TWO_PI);
      vector[k] = new Vec3D(cos(ang), sin(ang), 0);
    }
  }

  void calcGradient(boolean norm) {    
    vector = new Vec3D[scalar.length];
    int k;
    for (int x = 0; x < nX; x++) {
      for (int y = 0; y < nY; y++) {
        float dx = scalar[twoToSingle(xR(x), y, nX)] - scalar[twoToSingle(xL(x), y, nX)];
        float dy = scalar[twoToSingle(x, yD(y), nX)] - scalar[twoToSingle(x, yU(y), nX)];
        k = twoToSingle(x, y, nX);
        vector[k] = new Vec3D(dx, dy, 0);
        if (norm) vector[k].normalize();
      }
    }
  }

  void setScalarField(float[] scalar) {
    this.scalar = scalar;
  }

  void setVectorField(Vec3D[] vector) {
    this.vector = vector;
  }

  void setScalarValue(int k, float val) {
    this.scalar[k] = val;
  }

  void setScalarValue(Vec3D p, float val) {
    int i = int(constrain(p.x/resX, 0, nX-1));
    int j = int(constrain(p.y/resY, 0, nY-1));
    this.scalar[twoToSingle(i, j, nX)]=val;
  }

  void setVectorValue(int k, Vec3D vector) {
    this.vector[k] = vector;
  }

  void setVectorValue(Vec3D p, Vec3D vector) {
    int i = int(constrain(p.x/resX, 0, nX-1));
    int j = int(constrain(p.y/resY, 0, nY-1));
    this.vector[twoToSingle(i, j, nX)]=vector;
  }


  // _____________________________________________ update methods

  void updateNoiseField(float t) {
    float ang;
    int i, j;
    for (int k=0; k< scalar.length; k++) {
      i = singleToTwo(k, nX)[0];
      j = singleToTwo(k, nX)[1];
      scalar[k]= noise(i*resX*ns, j*resY*ns, t);
      ang = map(scalar[k], 0, 1, 0, TWO_PI);
      vector[k] = new Vec3D(cos(ang), sin(ang), 0);
    }
  }

  void diffusion(int nDiff, float diff) {
    float ang;
    for (int n = 0; n < nDiff; n++) {
      float[] lap = laplacian(scalar);
      for (int k = 0; k < scalar.length; k++) {
        float val = scalar[k];    
        scalar[k] = val + diff * lap[k];
        if (isNoise) {
          ang = map(scalar[k], 0, 1, 0, TWO_PI);
          vector[k] = new Vec3D(cos(ang), sin(ang), 0);
        }
      }
      //println("diffusion " + (n+1) + "/" + nDiff);
    }
  }


  void decaySq(float mult) {
    for (int k=0; k< scalar.length; k++) {
      scalar[k]*=mult;
      if (isNoise) {
        float ang = map(scalar[k], 0, 1, 0, TWO_PI);
        vector[k] = new Vec3D(cos(ang), sin(ang), 0);
      }
    }
  }

  void decayLin(float sub) {
    for (int k=0; k< scalar.length; k++) {
      scalar[k]-=sub;
      if (isNoise) {
        float ang = map(scalar[k], 0, 1, 0, TWO_PI);
        vector[k] = new Vec3D(cos(ang), sin(ang), 0);
      }
    }
  }

  float[] laplacian(float[] vals) {

    float dx, dy;
    float[] lap = new float[vals.length];
    for (int x = 0; x < nX; x++) {
      for (int y = 0; y < nY; y++) {
        float value = vals[twoToSingle(x, y, nX)];
        dx = scalar[twoToSingle(xL(x), y, nX)] + scalar[twoToSingle(xR(x), y, nX)] - 2*value;
        dy = scalar[twoToSingle(x, yU(y), nX)] + scalar[twoToSingle(x, yD(y), nX)] - 2*value;
        lap[twoToSingle(x, y, nX)] = dx + dy;
      }
    }  
    return lap;
  }


  // _____________________________________________ evaluation methods

  float evalScalar(Vec3D p) {
    int i = int(constrain(p.x/resX, 0, nX-1));
    int j = int(constrain(p.y/resY, 0, nY-1));
    return scalar[twoToSingle(i, j, nX)];
  }

  Vec3D evalVector(Vec3D p) {
    int i = int(constrain(p.x/resX, 0, nX-1));
    int j = int(constrain(p.y/resY, 0, nY-1));
    return vector[twoToSingle(i, j, nX)];
  }

  // _____________________________________________ display methods

  void dispTiles() {
    pgS.beginDraw();
    pgS.clear();
    //pgS.stroke(0);
    pgS.rectMode(CORNER);
    pgS.noStroke();
    for (int i=0; i< nX; i++) {
      for (int j=0; j< nY; j++) {
        pgS.fill(color(255*scalar[twoToSingle(i, j, nX)]));
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
    for (int i=0; i< nX; i++) {
      for (int j=0; j< nY; j++) {
        s = int(scalar[twoToSingle(i, j, nX)]*7);
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
    Vec3D p;
    pgV.stroke(255);
    pgV.strokeWeight(1);
    for (int i=0; i< nX; i++) {
      for (int j=0; j< nY; j++) {
        x = i*resX + resX*0.5;
        y = j*resY + resY*0.5;
        p = vector[twoToSingle(i, j, nX)].scale(len);
        pgV.line(x, y, x+p.x, y+p.y);
      }
    }
    pgV.endDraw();
  }

  void dispImage() {
    image.loadPixels();
    for (int k=0; k< nX*nY; k++) {
      image.pixels[k] = color(255*scalar[k]);
    }
    image.updatePixels();
  }

  // _____________________________________________ index conversion formulas 

  // 2D arrays/matrices (i,j)
  int twoToSingle(int x, int y, int rowSize) {
    return y*rowSize+x;
  }

  int[] singleToTwo(int ind, int rowSize) {
    int[] ij = new int[2];
    ij[0]= ind/rowSize; // row index (i)
    ij[1] = ind % rowSize; // column index (j)
    return ij;
  }

  // 3D arrays (i,j,k)
  int threeToSingle(int x, int y, int z, int rowSize, int colSize) {
    return rowSize*colSize*z+y*rowSize+x;
  }

  int[] singleToThree(int ind, int rowSize, int colSize) {
    int[] ijk = new int[3];
    ijk[2] = ind / (rowSize*colSize); // stack index (k or z)
    ijk[0]= (ind % (rowSize*colSize))/rowSize; // row index (i or y)
    ijk[1] = (ind % (rowSize*colSize)) % rowSize; // col index (j or x)
    return ijk;
  }

  // indices wrap formulas
  int xL(int x) {
    return (x+nX-1)%nX;
  }
  int xR(int x) {
    return (x+1)%nX;
  }
  int yU(int y) {
    return (y+nY-1)%nY;
  }
  int yD(int y) {
    return (y+1)%nY;
  }
} // end class Field