class Particle {
  float maxForce;
  Vec3D pos, vel;
  Plane plane;

  Particle(Vec3D pos, Vec3D vel) {
    this.pos = pos;
    this.vel = vel;
    plane = new Plane(pos, vel);
    maxForce = 0.05;
  }

  void displayPos() {
    stroke(0);
    strokeWeight(3);
    point(pos.x, pos.y, pos.z);
  }

  void displayVel(float scale) {
    Vec3D p = pos.add(vel.scale(scale));
    stroke(255, 0, 0);
    strokeWeight(1);
    line(pos.x, pos.y, pos.z, p.x, p.y, p.z);
  }

  void alignWithNeighbors(Particle[] parts, float aR) {
    Vec3D steer = new Vec3D();
    int aC=0;

    for (int i=0; i< parts.length; i++) {
      if (parts[i] != this) {
        if (pos.distanceTo(parts[i].pos)<aR) {
          aC++;
          steer.addSelf(parts[i].vel.sub(vel));
        }
      }
    }
    if (aC >0) {
      steer.scaleSelf(1/(float)aC);
      steer.scaleSelf(maxForce);
    }
    vel.addSelf(steer);
    vel.normalize();
    plane = new Plane(pos, vel);
  }

  void alignWithNeighbor(Particle[] parts) {
    Vec3D steer = new Vec3D();
    Particle neigh = closestNeigh(parts);
    if (neigh!=null) {
      steer = neigh.vel.sub(vel);
      steer.scaleSelf(maxForce);
    }
    vel.addSelf(steer);
    vel.normalize();
    plane = new Plane(pos, vel);
  }

  Particle closestNeigh (Particle[] parts) {
    int neigh=-1;
    float distSq, minDist = Float.MAX_VALUE;

    // find closest neighbor
    for (int i=0; i< parts.length; i++) {
      if (parts[i] != this) {
        distSq = pos.distanceToSquared(parts[i].pos);
        if (distSq < minDist) {
          neigh = i;
          minDist = distSq;
        }
      }
    }
    return neigh!=-1?parts[neigh]:null;
  }
}