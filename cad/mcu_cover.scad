include <params.scad>

length = 41.0;
width = 20.0;
thickness = 3.0;
rscrew = 2.5;
rscrew_hole = 1.1;
screw_xoffset = width/2 - rscrew;

module mcu_cover() {
  difference() {
    cube([width + kerf, length + kerf, thickness]);
    translate([kerf/2, kerf/2, 0]) {
      translate([width/2 - screw_xoffset, rscrew, thickness/2])
        cylinder(h=thickness + 2*cut_delta, r=rscrew_hole, center=true);
      translate([width/2 + screw_xoffset, rscrew, thickness/2])
        cylinder(h=thickness + 2*cut_delta, r=rscrew_hole, center=true);
    }
  }
}

projection() {
  mcu_cover();
}
