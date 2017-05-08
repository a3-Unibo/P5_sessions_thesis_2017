
ArrayList<Connection> connectTrails(PointOctree trails, ArrayList <Agent> agents, float range, float ang) {

  ArrayList<Connection> conns = new ArrayList<Connection>();
  ArrayList <Vec3D> pts = (ArrayList <Vec3D>)trails.getPoints();
  ArrayList <Vec3D> neigh;
  Vec3D pt, dir;

  // check each agent
  for (Agent a : agents) {
    // for each agent, check trail
    for (int i=0; i< a.trail.size(); i++) {
      pt = a.trail.get(i);
      // get neighbors from octree
      neigh = (ArrayList <Vec3D>)trails.getPointsWithinSphere(pt, range);
      // if neighbors not null
      if (neigh!=null && neigh.size()>0) {
        for (Vec3D n : neigh) {
          dir = n.sub(pt);
          if (dir.angleBetween(a.trailV.get(i), true)< ang) {
            conns.add(new Connection(pt, n));
          }
        }
      }
    }
  }

  return conns;
}


class Connection {
  Vec3D a, b;

  Connection(Vec3D a, Vec3D b) {
    this.a = a;
    this.b = b;
  }

  void display() {
    stroke(0, 120);
    strokeWeight(1);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
}