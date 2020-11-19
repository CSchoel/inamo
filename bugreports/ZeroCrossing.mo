model ZeroCrossing
  Real r(nominal=1e-12) = sin(time) * 1e-12;
  //Boolean crossing(start=false, fixed=true) = r > 0; // does not work
  Boolean crossing(start=false, fixed=true) = r * 1e12 > 0; // does work
end ZeroCrossing;