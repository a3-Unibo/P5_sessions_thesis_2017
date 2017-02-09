// .................................. import functions from TXT



Vec3D[] importPtsArray(String fileName) {

  // load file and split lines into separate strings
  String[] txtLines = loadStrings(dataPath(fileName));

  Vec3D[] pts = new Vec3D[txtLines.length];

  // loop thru them
  for (int i = 0; i < txtLines.length; ++i) {

    //separates coords
    String[] arrToks = split(txtLines[i], ',');
    float xx = Float.valueOf(arrToks[0]);
    float yy = Float.valueOf(arrToks[1]);
    float zz = Float.valueOf(arrToks[2]);

    //add pt to pts array

    pts[i]= new Vec3D(xx, yy, zz);
  }

  return pts;
}

ArrayList<Vec3D> importPtsList(String fileName, String cs) {

  ArrayList <Vec3D> pts = new ArrayList<Vec3D>();
  // load file and split lines into separate strings
  String[] txtLines = loadStrings(dataPath(fileName));

  // loop thru them
  for (int i = 0; i < txtLines.length; ++i) {

    //separates coords
    String[] arrToks = split(txtLines[i], ',');
    float xx = Float.valueOf(arrToks[0]);
    float yy = Float.valueOf(arrToks[1]);
    float zz = Float.valueOf(arrToks[2]);

    //add pt to pts array

    pts.add(new Vec3D(xx, yy, zz));
  }

  return pts;
}

/*

 for this one, the data format should be:
 
 xS,yS,zS_xE,yE,zE
 
 obviously.... S: start point E: end point
 
 */

ArrayList<Vec3D> importVectorsFromLines(String fileName, String cs, String ps) {

  ArrayList <Vec3D> vecs = new ArrayList<Vec3D>();
  Vec3D start, end;

  // load file and split lines into separate strings
  String[] txtLines = loadStrings(dataPath(fileName));

  // loop thru them
  for (int i = 0; i < txtLines.length; ++i) {

    //find lines end points
    String[] arrCoords = split(txtLines[i], '_');
    String[] startC = split(arrCoords[0], ',');
    String[] endC = split(arrCoords[1], ',');

    start = new Vec3D(Float.valueOf(startC[0]), Float.valueOf(startC[1]), 
      Float.valueOf(startC[2]));
    end = new Vec3D(Float.valueOf(endC[0]), Float.valueOf(endC[1]), 
      Float.valueOf(endC[2]));
    
    vecs.add(end.sub(start));

  }

  return vecs;
}

// ___________________________________ polylines ___________________________________

/*
the usual format for polylines in text files has all points of a single polyline 
 written in the same text line, with a different separator between coordinates and between points
 
 cs is the coordinate separator character
 ps is the point separator character
 
 EXAMPLE:
 
 0,0,0_5.4,-3.7,0_10,-3.86,-1
 
 the polyline has 3 points, cs is "," and ps is "_"
 
 the function returns an ArrayList of ArrayList <Vec3D> - that's right, it requires toxi.geom.* in imports
 
 */

ArrayList importCurves(String fileName, String cs, String ps) {
  //load text
  ArrayList crvs = new ArrayList();
  ArrayList <Vec3D> pts;
  // load file and split lines into separate strings
  String[] txtLines = loadStrings(dataPath(fileName));

  // loop thru them
  for (int i = 0; i < txtLines.length; ++i) {

    //splits strand points
    String[] arrCoords = split(txtLines[i], '_');
    pts = new ArrayList<Vec3D>();

    for (int j = 0; j < arrCoords.length; ++j) {

      //separates coords
      String[] arrToks = split(arrCoords[j], ',');
      float xx = Float.valueOf(arrToks[0]);
      float yy = Float.valueOf(arrToks[1]);
      float zz = Float.valueOf(arrToks[2]);

      //add pt to pts array

      pts.add(new Vec3D(xx, yy, zz));
    }
    crvs.add(pts);
  }

  return crvs;
}