import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.geom.*; 
import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CurvesExportTo_OBJ extends PApplet {

/*

 OBJ export function
 
 comes from Stigmergy_mesh sketch in @P5 Genova 2014 folder
 
 written for the Strand class, need to be adapted for Vec3D or PVector arrays
 
 */

 
 

 PeasyCam cam;
 ArrayList <Vec3D> crv;
 Vec3D v;
 float sc=0.01f;
 float speed;
 int count,i;

 public void setup() {

  //.....
  size(600,600, P3D);
  cam = new PeasyCam(this,500);
  crv = new ArrayList<Vec3D>();
  frameRate(30);
  v = new Vec3D();
  crv.add(v);
  count =0;
  noFill();
  i = PApplet.parseInt(random(100));
  noiseDetail(8,0.5f);
  speed = random(10,50);
}

public void draw() {
  background(221);
  if (count < 200){
  Vec3D v1 = new Vec3D(v);
    v1.x+=(noise(i,v.x*sc,v.y*sc)-.5f)*speed;
    v1.y+=(noise(i+2,v.x*sc,v.z*sc)-.5f)*speed;
    v1.z+=(noise(i+3,v.x*sc,v.y*sc)-.5f)*speed;
  crv.add(v1);
  v=new Vec3D(v1);
  count++;
  }

  beginShape();
  for(int i=0; i< crv.size(); i++){
  Vec3D vc = crv.get(i);
  vertex(vc.x, vc.y, vc.z);
  }
  endShape();
  //.....

  
  strokeWeight(3);
  for(int i=0; i< crv.size(); i++){
    Vec3D vc = crv.get(i);
    //stroke(color(map(i,0,crv.size()-1, 0,255),0,0));
    stroke(color(lerpColor(color(255,0,0),color(255), PApplet.parseFloat(i)/crv.size())));
    point(vc.x, vc.y, vc.z);
  }
  stroke(0);
  strokeWeight(1);

}

public void keyPressed(){

  if (key=='e') exportVecsAsObj(crv,"curve", new Vec3D(), new Vec3D(1,1,1));
}

// export single curve as Vec3D ArrayList

public void exportVecsAsObj(ArrayList <Vec3D> crv, String fileName, Vec3D trans, Vec3D expScale) {

  String dir = "export_data/"+nf(frameCount, 4)+ fileName +".obj";


  // export trails

  PrintWriter output = createWriter(dir); 

  println("creating", fileName+".obj file");
  output.println("# exported from Processing");
  output.println("# code (c) Co-de-iT 2014");


  output.println("o Curve_0");
  for (Vec3D v : crv) {
    if (v != null) {
      Vec3D v1=v.scale(expScale);
      v1.addSelf(trans);
      output.println("v " + v1.x + " " + v1.y + " " + v1.z);
    }
  }

  for (int i=0; i< crv.size()-1; i++) {
    output.println("l "+ (i+1)+ " " + (i+2));
  }

  output.flush();
  output.close();

  println(dir + " created.");
}

// written for Strand class

/*

void exportStrandsAsObj(ArrayList <Strand> strands, String fileName, Vec3D trans, Vec3D expScale) {

  String dir = "export_data/"+nf(frameCount, 4)+ fileName +".obj";


  // export trails

  PrintWriter output = createWriter(dir); 

  println("creating", fileName+".obj file");
  output.println("# exported from Processing");
  output.println("# code (c) Co-de-iT 2014");

  int count = 0;
  int count2 = 1;

  for (Strand s : strands) {
    output.println("o Curve_"+nf(count, 3));
    for (Vec3D v : s.points) {
      if (v != null) {
        Vec3D v1=v.scale(expScale);
        v1.addSelf(trans);
        output.println("v " + v1.x + " " + v1.y + " " + v1.z);
      }
    }

    for (int i=0; i< s.points.size ()-1; i++) {
      output.println("l "+ (i+count2)+ " " + (i+count2+1));
    }
    count2+= s.points.size();
    count ++;
  }

  output.flush();
  output.close();

  println(dir + " created.");
}

*/

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "CurvesExportTo_OBJ" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
