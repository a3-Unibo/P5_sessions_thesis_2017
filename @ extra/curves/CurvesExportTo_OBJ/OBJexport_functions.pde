// .................................. export functions


// export single curve (points as Vec3D ArrayList)

void exportVecsAsObj(ArrayList <Vec3D> crv, String fileName, Vec3D trans, Vec3D expScale) {

  String dir = sketchPath("export_data/"+nf(frameCount, 4)+ fileName +".obj");

  // export trails

  PrintWriter output = createWriter(dir); 

  println("creating", fileName+".obj file");
  output.println("# exported from Processing");
  output.println("# code (c) Co-de-iT 2014");


  output.println("o Curve_0");
  for (Vec3D v : pts) {
    if (v != null) {
      Vec3D v1=v.scale(expScale);
      v1.addSelf(trans);
      output.println("v " + v1.x + " " + v1.y + " " + v1.z);
    }
  }

  for (int i=0; i< pts.size ()-1; i++) {
    output.println("l "+ (i+1)+ " " + (i+2));
  }

  output.flush();
  output.close();

  println(dir + " created.");
}


// export ArrayList of curves (points as Vec3D ArrayList)

void exportCurvesAsObj(ArrayList crvs, String fileName, Vec3D trans, Vec3D expScale) {

  String dir = "export_data/"+nf(frameCount, 4)+ fileName +".obj";
  ArrayList <Vec3D> pts = new ArrayList<Vec3D>();

  // export trails

  PrintWriter output = createWriter(dir); 

  println("creating", fileName+".obj file");
  output.println("# exported from Processing");
  output.println("# code (c) Co-de-iT 2014");
  int count = 0;
  int count2 = 1;
  for (int i=0; i< crvs.size (); i++) {
    pts = (ArrayList<Vec3D>) crvs.get(i);
    output.println("o Curve_"+nf(count, 3));
    for (Vec3D v : pts) {
      if (v != null) {
        Vec3D v1=v.scale(expScale);
        v1.addSelf(trans);
        output.println("v " + v1.x + " " + v1.y + " " + v1.z);
      }
    }

    for (int j=0; j< pts.size ()-1; j++) {
      //output.println("l "+ (j+1)+ " " + (j+2));
      output.println("l "+ (j+count2)+ " " + (j+count2+1));
    }
    count2+= pts.size();
    count++;
  }
  output.flush();
  output.close();

  println(dir + " created.");
}
