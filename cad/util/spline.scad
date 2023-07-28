// Courtesy of teejaydub https://www.thingiverse.com/thing:1468725/files

// ================================================================================
// Spline functions - mostly convenience calls to lower-level primitives.

// Makes a 2D shape that interpolates between the points on the given path,
// with the given width, in the X-Y plane.
module spline_ribbon(path, width=1, subdivisions=4, loop=false)
{
  ribbon(smooth(path, subdivisions, loop), width, loop);
}

// Extrudes a spline ribbon to the given Z height.
module spline_wall(path, width=1, height=1, subdivisions=4, loop=false)
{
  wall(smooth(path, subdivisions, loop), width, height, loop);
}

// ================================================================================
// Rendering paths and loops
module ribbon(path, width=1, loop=false)
{
  union() {
    for (i = [0 : len(path) - (loop? 1 : 2)]) {
      hull() {
        translate(path[i])
          circle(d=width);
        translate(path[(i + 1) % len(path)])
          circle(d=width);
      }
    }
  }
}

module wall(path, width=1, height=1, loop=false)
{
  linear_extrude(height)
    ribbon(path, width, loop);
}

// ==================================================================
// Interpolation and path smoothing

// Takes a path of points (any dimensionality),
// and inserts additional points between the points to smooth it.
// Repeats that n times, and returns the result.
// If loop is true, connects the end of the path to the beginning.
function smooth(path, n, loop=false) =
  n == 0
    ? path
    : loop
      ? smooth(subdivide_loop(path), n-1, true)
      : smooth(subdivide(path), n-1, false);

// Takes an open-ended path of points (any dimensionality), 
// and subdivides the interval between each pair of points from i to the end.
// Returns the new path.
function subdivide(path) =
  let(n = len(path))
  flatten(concat([for (i = [0 : 1 : n-1])
    i < n-1? 
      // Emit the current point and the one halfway between current and next.
      [path[i], interpolateOpen(path, n, i)]
    :
      // We're at the end, so just emit the last point.
      [path[i]]
  ]));

// Takes a closed loop points (any dimensionality), 
// and subdivides the interval between each pair of points from i to the end.
// Returns the new path.
function subdivide_loop(path, i=0) = 
  let(n = len(path))
  flatten(concat([for (i = [0 : 1 : n-1])
    [path[i], interpolateClosed(path, n, i)]
  ]));

weight = [-1, 8, 8, -1] / 14;
weight0 = [6, 11, -1] / 16;
weight2 = [1, 1] / 2;

// Interpolate on an open-ended path, with discontinuity at start and end.
// Returns a point between points i and i+1, weighted.
function interpolateOpen(path, n, i) =
  i == 0? 
    n == 2?
      path[i]     * weight2[0] +
      path[i + 1] * weight2[1]
    :
      path[i]     * weight0[0] +
      path[i + 1] * weight0[1] +
      path[i + 2] * weight0[2]
  : i < n - 2?
    path[i - 1] * weight[0] +
    path[i]     * weight[1] +
    path[i + 1] * weight[2] +
    path[i + 2] * weight[3]
  : i < n - 1?
    path[i - 1] * weight0[2] +
    path[i]     * weight0[1] +
    path[i + 1] * weight0[0]
  : 
    path[i];

// Use this to interpolate for a closed loop.
function interpolateClosed(path, n, i) =
  path[(i + n - 1) % n] * weight[0] +
  path[i]               * weight[1] +
  path[(i + 1) % n]     * weight[2] +
  path[(i + 2) % n]     * weight[3] ;

// ==================================================================
// Utilities
function flatten(list) = [ for (i = list, v = i) v ]; 
