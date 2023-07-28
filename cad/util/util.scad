// Compute the 2-norm of the 2-dimensional vector v
function norm2(v) =
  let (length = sqrt(v[0]*v[0] + v[1]*v[1]))
  [v[0] / length, v[1] / length];

// Rotate the 2-dimensional vector v by a degrees
function rot2(v, a) =
  [[cos(a), -sin(a)], [sin(a), cos(a)]]*v;

// Move from p_from along the projection of (p_to - p_from) onto v_dir
function proj_magic(p_from, p_to, v_dir, w=1) =
  let (v = norm2(v_dir))
  p_from + w*((p_to - p_from)*v)*v;
