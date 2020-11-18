model ZeroCrossing
  Real r = sin(time) * 1e-12;
  Boolean crossing = r > 0; // does not work
  //Boolean crossing = r * 1e12 > 0; // does work
  Boolean trigger = change(crossing);
  Boolean result(start=false, fixed=true);
equation
  when trigger then
    result = not(pre(result));
  end when;
end ZeroCrossing;
