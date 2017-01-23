// .................................. import functions from TXT

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
  String[] txtLines = loadStrings(fileName);

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
