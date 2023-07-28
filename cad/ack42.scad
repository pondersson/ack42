// ** IMPORTS **
include <params.scad>
use <util/bezier_curve.scad>
use <util/util.scad>
use <util/spline.scad>

// ** TOGGLES **
draw_caps = false;
// Extras: {0-2: fill slabs, 3: mcu cover, 4: mcu cutout}
draw_extra = [true, true, true, false, true];
// Bezier elements going around the edge
draw_bezier = [true, true, true, true];

// ** PARAMETERS **
// Top plate
pad = 3.0;            // switch unit pad (outline border width)
su = u + 2*pad;       // switch unit side length (the chunks that make up the top plate)
p_mw = 16.0;          // plate mid-width
split_angle = 16.5;   // angle between halves, 16.5
bezier_t_step = 0.05; // smoothness of Bezier curves

// ** MATRIX SETUP **
// These are now fixed parameters
n_cols = 6;
n_rows = 3;
col_stagger = [-2, 0, 5.5, 1, -8.5, -8.5];

// Generate coordinates for matrix key positions
// Matrix index [0, 0] corresponds to the bottom inner key
m_offset = [20, 45];
m_x = [ for (r = [ 0 : n_rows - 1 ]) [ for (c = [ 0 : n_cols - 1 ])
    m_offset[0] + c*u ] ];
m_y = [ for (r = [ 0 : n_rows - 1 ]) [ for (c = [ 0 : n_cols - 1 ])
    m_offset[1] + r*u + col_stagger[c] ] ];

// ** THUMB CLUSTER **
// Generate coordinates for the thumb key positions
// Thumb key index runs inward, i.e. 0 is the straight one
t_w = 1.25; // keycap size in units of the middle thumb key
t_a = 25; tc_x = -4; tc_y = 0; // thumb cluster angle, x- and y-offset
t0_x = 0.5*(m_x[0][1] + m_x[0][2]) + tc_x;
t0_y = m_y[0][1] - u + tc_y;
t1_x = t0_x - t_w*u*cos(t_a);
t1_y = t0_y - t_w*u*sin(t_a);
t2_x = t1_x - u*cos(2*t_a);
t2_y = t1_y - u*sin(2*t_a);
t_x = [t0_x, t1_x, t2_x];
t_y = [t0_y, t1_y, t2_y];

// Thumb slabs, how far to extend the thumb switch units left/right/down/up
ts = [[5, 0, 0, 0],
      [1, 2, 0, 0],
      [0, 40, 0, 0]];
tw = [1, t_w, 1];

// ** EXTRA SLABS **
// Extra slabs to fill certain gaps
es_0 = [0, 0, 10, 0]; // left, right, down, up
es_1 = [0, 0, col_stagger[2] - col_stagger[3], 0]; // left, right, down, up
es_20 = [m_x[2][0] - pad, m_y[2][0] + u + pad + 3];
es_2_vec = rot2([-1, 0], -split_angle);
es_21 = es_20 + p_mw/2*es_2_vec;
es_23 = [t2_x, t2_y] + rot2([-pad, u + pad], 2*t_a);
es_2_proj = (es_23 - es_21)*es_2_vec; // vector dot product
es_22 = (es_2_proj < 0) ? es_23 - es_2_proj*es_2_vec : es_23;
es_24 = [m_x[0][0], m_y[0][0]];
es_2_pts = (es_2_proj < 0) ? [es_20, es_21, es_22, es_23, es_24, es_20] : [es_20, es_21, es_23, es_24, es_20];

// Microcontroller cutout
mcu_pad = 1;
mcu_width = 18 + 2*mcu_pad;
mcu_length = 33 + 2*mcu_pad;

// Microcontroller cover
mcov_rscrew = 2.5;
mcov_rscrew_hole = 1.1;
mcov_offset = mcu_length + 2*mcov_rscrew;
mcov_length = mcov_offset + 1.0;
mcov_width = mcu_width;
mcov_height = su_t + 2;
mcov_thickness = 3;
mcov_screw_xoffset = mcov_width/2 - mcov_rscrew;

// Translation vector to align with the y-axis for mirroring
shift_vec = rot2(es_22, split_angle);

// ** KEYCAPS **
c_col = [0.0, 0.0, 0.0, 0.8]; // color
c_w = 18.3;                   // width
c_h = 5;                      // height
c_z = 7.00;                   // height above plate

// ** BEZIER EDGES **
// Defined in XY-plane and then extruded into Z
module symmetric_bezier_element(p1, p2, weight, angle, extra_points=[], height=1) {
  diff = p2 - p1;
  b1 = p1 + weight*rot2(diff, angle);
  b2 = p2 - weight*rot2(diff, -angle);
  pts = [p1, b1, b2, p2];
  curve = bezier_curve(bezier_t_step, pts);
  poly = concat(curve, extra_points, [p1]);
  linear_extrude(height) {polygon(points=poly);}
}

// Bezier 0
b0_w = 0.365;
b0_a = 17.5;
b0_p1 = es_20;
b0_p2 = [m_x[2][5] + u + pad, m_y[2][5] + u + pad];
b0_p3 = [m_x[2][5] + u + pad, m_y[2][5] - pad];
b0_p4 = [m_x[2][0] - pad, m_y[2][0] - pad];
b0_extra = [b0_p3, b0_p4];

// Bezier 1
b1_w = 0.45;
b1_p1 = [m_x[0][4] - pad, m_y[0][4] - pad];
b1_p2 = [t0_x + u + pad, t0_y - pad];
b1_diff = b1_p2 - b1_p1;
b1_a = -atan(abs(b1_diff[1]/b1_diff[0]));
b1_p3 = [t0_x + u + pad, t0_y + u + pad];
b1_p4 = [m_x[0][3] + u + pad, m_y[0][3] - pad];
b1_extra = [b1_p3, b1_p4];

// Bezier 2
b2_w = 0.45;
b2_p1 = [t0_x + u + pad, t0_y - pad];
b2_p2 = [t2_x, t2_y] + rot2([-pad, -pad], 2*t_a);
b2_diff = b2_p2 - b2_p1;
b2_a = -atan(abs(b2_diff[1]/b2_diff[0]));
b2_p3 = [t1_x, t1_y] + rot2([t_w*u, u], 2*t_a);
b2_extra = [b2_p3];

// Bezier 3, asymmetric to get horizontal tangent at the bottom where the two halves meet
b3_w1 = 0.45;
b3_w2 = 0.35;
b3_drop = 1;
b3_p1 = [t2_x, t2_y] + rot2([-pad, -pad], 2*t_a);
b3_p2 = es_22 + rot2([0, -b3_drop], -split_angle);
b3_diff = b3_p2 - b3_p1;
b3_a1 = -((90 - 2*t_a) - atan(abs(b3_diff[1]/b3_diff[0])));
b3_b1 = b3_p1 + b3_w1*rot2(b3_diff, b3_a1);
// b3_p2 is the special point, its tangent vector should be [1, 0]
b3_vec2 = rot2([1, 0], -split_angle);
b3_vec2_full = (b3_diff*b3_vec2)*b3_vec2;
b3_b2 = b3_p2 - b3_w2*b3_vec2_full;
b3_pts = [b3_p1, b3_b1, b3_b2, b3_p2];
b3_curve = bezier_curve(bezier_t_step, b3_pts);
b3_p3 = es_22;
b3_p4 = [t2_x, t2_y] + rot2([u, u], 2*t_a);
b3_poly = concat(b3_curve, [b3_p3, b3_p4, b3_p1]);

// ** MOUNTING HOLES **
mh_min_radius = (3.0 + 0.2)/2; // assuming M3
mh_max_radius = 6.4/2;
mh1 = [m_x[2][1] - mh_max_radius - 1, m_y[2][0] + u + mh_max_radius + 1];
mh2 = [m_x[2][5], m_y[2][5] + u + mh_max_radius + 1];
mh3 = [t1_x, t1_y] + rot2([-0.22*u, u], t_a);
mh4 = [m_x[0][4] - mh_max_radius - 1, m_y[0][3] - mh_max_radius - 1];
mh_points = [mh1, mh2, mh3, mh4];

// ** BUILD **
// The only difference between top and bottom plates are the cutouts
module ack42(top, col) {
  difference() {
    union() {
      color (col) {
        // Render matrix switch units
        for(r = [0 : n_rows - 1]) {
          for(c = [0 : n_cols - 1]) {
            translate([m_x[r][c] - pad, m_y[r][c] - pad, 0])
              if(r==2 && c==2) {
                cube([su, su - pad, su_t]);
              }
              else {
                cube([su, su, su_t]);
              }
          }
        }
        // Render thumb switch units
        for(i = [0 : 2]) {
          translate([t_x[i], t_y[i], 0])
            rotate([0, 0, i*t_a])
            translate([-ts[i][0] - pad, -ts[i][2] - pad, 0])
            cube([tw[i]*su + ts[i][0] + ts[i][1], su + ts[i][2] + ts[i][3], su_t]);
        }
        // Render extra slabs
        if(draw_extra[0]) {
          translate([m_x[0][0], m_y[0][0], 0])
            translate([-es_0[0], -es_0[2], 0])
            cube([su + es_0[0] + es_0[1], su + es_0[2] + es_0[3], su_t]);
        }
        if(draw_extra[1]) {
          translate([m_x[0][2], m_y[0][2], 0])
            translate([-es_1[0], -es_1[2], 0])
            cube([su + es_1[0] + es_1[1], su + es_1[2] + es_1[3], su_t]);
        }
        if(draw_extra[2]) {
          linear_extrude(height=su_t) {polygon(points=es_2_pts);}
        }
        // Render Bezier elements
        if(draw_bezier[0])
          symmetric_bezier_element(b0_p1, b0_p2, b0_w, b0_a, b0_extra, su_t);
        if(draw_bezier[1])
          symmetric_bezier_element(b1_p1, b1_p2, b1_w, b1_a, b1_extra, su_t);
        if(draw_bezier[2])
          symmetric_bezier_element(b2_p1, b2_p2, b2_w, b2_a, b2_extra, su_t);
        if(draw_bezier[3])
          linear_extrude(height=su_t) {polygon(points=b3_poly);}

      }
      // Render microcontroller cover
      if (top && draw_extra[3]) {
        translate(es_21)
          rotate([0, 0, -split_angle])
          translate([0, -mcov_offset, mcov_height])
          difference() {
          color([0.2, 0.2, 0.2, 0.80])
            cube([mcov_width/2, mcov_length, mcov_thickness]);
          translate([mcov_screw_xoffset, mcov_rscrew, mcov_thickness/2])
            cylinder(h=mcov_thickness + 2*cut_delta, r=mcov_rscrew_hole, center=true);
        }
      }
    }

    // Top plate cutouts
    if (top) {
      // Cut out matrix switch holes
      for(r = [0 : n_rows - 1]) {
        for(c = [0 : n_cols - 1]) {
          translate([m_x[r][c] + (u - sh)/2, m_y[r][c] + (u - sh)/2, -cut_delta]) {
            cube([sh, sh, su_t + 2*cut_delta]);
          }
        }
      }
      // Cut out thumb switch holes
      for(i = [0 : 2]) {
        translate([t_x[i], t_y[i], -cut_delta])
          rotate([0, 0, i*t_a])
          translate([(tw[i]*u - sh)/2, (u - sh)/2, 0]) {
          cube([sh, sh, su_t + 2*cut_delta]);
        }
      }
      // Microcontroller cutout
      if (top && draw_extra[4]) {
        translate(es_21)
          rotate([0, 0, -split_angle])
          translate([-cut_delta, -mcov_offset + kerf/2, -cut_delta])
          cube([mcu_width/2 - kerf/2 + cut_delta, mcu_length - kerf/2 + 10, su_t + 2*cut_delta]); // add 10 to height to cut through the Bezier element
      }
    }

    // Bottom plate (PCB) cutouts
    else {
      // Cut out matrix switch markers
      for(r = [0 : n_rows - 1]) {
        for(c = [0 : n_cols - 1]) {
          translate([m_x[r][c] + u/2, m_y[r][c] + u/2, 0.5*su_t])
            rotate([0, 0, -split_angle])
            cube([1, 1, su_t + 2*cut_delta], center=true);
        }
      }
      // Cut out thumb switch markers
      for(i = [0 : 2]) {
        translate([t_x[i], t_y[i], 0.5*su_t])
          rotate([0, 0, i*t_a])
          translate([tw[i]*u/2, u/2, 0])
          rotate([0, 0, -i*t_a - split_angle]) {
          cube([1, 1, su_t + 2*cut_delta], center=true);
        }
      }
      // Microcontroller cover mounting holes
      translate(es_21)
        rotate([0, 0, -split_angle])
        translate([mcov_screw_xoffset, -mcov_offset + mcov_rscrew, su_t/2])
        cube([1, 1, su_t + 2*cut_delta], center=true);
    }
    // Plate mounting holes
    for(i = [0 : len(mh_points) - 1]) {
      p = mh_points[i];
      translate([p[0], p[1], 0.5*su_t])
        rotate([0, 0, -split_angle])
        if(top)
          cylinder(h=su_t + 2*cut_delta, r=mh_min_radius - kerf/2, center=true);
        else
          cube([1, 1, su_t + 2*cut_delta], center=true);
    }
  }

  // Render keycaps
  if (top && $preview && draw_caps) {
    color(c_col) {
      // Render matrix switch units
      for(r = [0 : n_rows - 1]) {
        for(c = [0 : n_cols - 1]) {
          translate([m_x[r][c] + (u - c_w)/2, m_y[r][c] + (u - c_w)/2, 0])
            translate([0, 0, c_z])
            cube([c_w, c_w, c_h]);
        }
      }
      // Render thumb switch units
      for(i = [0 : 2]) {
        translate([t_x[i], t_y[i], 0])
          rotate([0, 0, i*t_a])
          translate([tw[i]*(u - c_w)/2, (u - c_w)/2, c_z])
          cube([tw[i]*c_w, c_w, c_h]);
      }
    }
  }
}

draw_top = true;
top_color = [0.2, 0.2, 0.2, 1.0];
draw_pcb = false;
pcb_color = "#296e01";

projection()
{
translate([-shift_vec[0], 0, 0])
rotate([0, 0, split_angle]) {
  if(draw_top) {
    translate([0, 0, su_t + 2])
      ack42(top=true, col=top_color);
  }
  if(draw_pcb)
    ack42(top=false, col=pcb_color);
}
mirror([1, 0, 0]) {
  translate([-shift_vec[0], 0, 0])
    rotate([0, 0, split_angle]) {
    if(draw_top) {
      translate([0, 0, su_t + 2])
        ack42(top=true, col=top_color);
    }
    if(draw_pcb)
      ack42(top=false, col=pcb_color);
  }
}
}
