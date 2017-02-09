// .................................. export functions to TXT

/*
the usual format for polylines in text files has all points of a single polyline 
written in the same text line, with a different separator between coordinates and between points

cs is the coordinate separator character
ps is the point separator character

EXAMPLE:

if the polyline has 3 points of x y z:

0 0 0
5.4 -3.7 0
10 -3.86 -1

and if cs is "," and ps is "_", the resulting output will be:

0,0,0_5.4,-3.7,0_10,-3.86,-1

the function writes in an "export_data" folder inside the sketch folder

*/

// with scaleFactor vector

void exportCurvesAsTxt(ArrayList crvs, String fileName, Vec3D trans, Vec3D expScale, String cs, String ps) {
  // String eol = System.getProperty("line.separator"); // line separator character
  String dir = "export_data/"+nf(frameCount, 4)+ fileName +".txt";
  Vec3D[] pts;
  Vec3D v0;

  PrintWriter output = createWriter(dir);   //Create a new PrintWriter object
  println("creating", fileName+".txt file");

  for (int j=0; j< crvs.size (); j++) {

    pts = (Vec3D[]) crvs.get(j);

    for (int i=0; i<pts.length; i++) {
      v0 = pts[i].scale(expScale).addSelf(trans);
      if (v0!=null) {
        //pts+=("{"+v0.x +", " +v0.y+", " +v0.z+ "}");  // x, y, z coordinates in grasshopper format
        output.print(v0.x +cs +v0.y+cs +v0.z);  // x, y, z coordinates in generic format 
        if (i< pts.length-1)  output.print(ps);  // writes end of point except for last point
      }
    }
    if (j<crvs.size()-1) output.println(); // writes end of line except for last line
  }

  output.flush();  //Write the remaining data to the file
  output.close();  //Finishes the files

  println(fileName, "file Saved");
}

void exportCurvesAsTxt_OLD(ArrayList crvs, String fileName, Vec3D trans, Vec3D expScale, String cs, String ps) {
  // String eol = System.getProperty("line.separator"); // line separator character
  String dir = "export_data/"+nf(frameCount, 4)+ fileName +".txt";
  ArrayList <Vec3D> pts;
  Vec3D v0;

  PrintWriter output = createWriter(dir);   //Create a new PrintWriter object
  println("creating", fileName+".txt file");

  for (int j=0; j< crvs.size (); j++) {

    pts = (ArrayList<Vec3D>) crvs.get(j);

    for (int i=0; i<pts.size (); i++) {
      v0 = pts.get(i).scale(expScale).addSelf(trans);
      if (v0!=null) {
        //pts+=("{"+v0.x +", " +v0.y+", " +v0.z+ "}");  // x, y, z coordinates in grasshopper format
        output.print(v0.x +cs +v0.y+cs +v0.z);  // x, y, z coordinates in generic format 
        if (i< pts.size()-1)  output.print(ps);  // writes end of point except for last point
      }
    }
    if (j<crvs.size()-1) output.println(); // writes end of line except for last line
  }

  output.flush();  //Write the remaining data to the file
  output.close();  //Finishes the files

  println(fileName, "file Saved");
}