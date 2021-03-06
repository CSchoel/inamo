within InaMo.Examples.ComponentTests;
model SteadyStatesCellML "same as SteadyStates, but with initial values from CellML implementation"

  extends SteadyStates(
    param_all_ca_cq_k = 5.34E+02, // probably flipped digit from 5.43e2

    init_an_v = -0.071554,
    init_an_na_act = 0.0104794,
    init_an_na_inact_slow = 0.788348,
    init_an_na_inact_fast = 0.792211,
    init_an_cal_act = 3.23E-05,
    init_an_cal_inact_fast = 0.998816,
    init_an_cal_inact_slow = 0.998822,
    init_an_to_act = 0.00802881,
    init_an_to_inact_fast = 0.995494,
    init_an_to_inact_slow = 0.547967,
    init_an_kr_act_slow = 0.00289901,
    init_an_kr_act_fast = 0.000907827,
    init_an_kr_inact = 0.98789,
    init_an_ca_cyto = 3.1043E-05,
    init_an_ca_sub = 2.86963E-05,
    init_an_ca_jsr = 0.557459,
    init_an_ca_nsr = 0.667221,
    init_an_ca_f_tc = 0.00615578,
    init_an_ca_f_tmc = 0.112201,
    init_an_ca_f_tmm = 0.78431,
    init_an_ca_f_cmi = 0.0128957,
    init_an_ca_f_cms = 0.0119202,
    init_an_ca_f_cq = 0.400684,
    init_an_ca_f_csl = 8.91124E-06,

    init_n_v = -4.97094E-02,
    init_n_cal_act = 1.7925E-03,
    init_n_cal_inact_fast = 0.97555,
    init_n_cal_inact_slow = 0.774394,
    init_n_kr_act_slow = 0.0797183,
    init_n_kr_act_fast = 0.192515,
    init_n_kr_inact = 0.949023,
    init_n_f_act = 0.0462303,
    init_n_st_act = 0.476405,
    init_n_st_inact = 0.542304,
    init_n_ca_cyto = 1.8497E-04,
    init_n_ca_sub = 1.60311E-04,
    init_n_ca_jsr = 0.29625,
    init_n_ca_nsr = 1.11093,
    init_n_ca_f_tc = 0.0356473,
    init_n_ca_f_tmc = 0.443317,
    init_n_ca_f_tmm = 0.391719,
    init_n_ca_f_cmi = 0.0723008,
    init_n_ca_f_cms = 0.0630771,
    init_n_ca_f_cq = 0.261431,
    init_n_ca_f_csl = 4.1498E-05,

    init_nh_v = -6.97603E-02,
    init_nh_na_act = 0.01322,
    init_nh_na_inact_slow = 0.701627,
    init_nh_na_inact_fast = 0.706623,
    init_nh_cal_act = 4.2350E-05,
    init_nh_cal_inact_fast = 0.998435,
    init_nh_cal_inact_slow = 0.998424,
    init_nh_to_act = 0.00894826,
    init_nh_to_inact_fast = 0.994837,
    init_nh_to_inact_slow = 0.427382,
    init_nh_kr_act_slow = 0.00539772,
    init_nh_kr_act_fast = 0.00141763,
    init_nh_kr_inact = 0.986382,
    init_nh_ca_cyto = 3.73317E-05,
    init_nh_ca_sub = 3.27336E-05,
    init_nh_ca_jsr = 0.682159,
    init_nh_ca_nsr = 0.818672,
    init_nh_ca_f_tc = 0.00739583,
    init_nh_ca_f_tmc = 0.133734,
    init_nh_ca_f_tmm = 0.765246,
    init_nh_ca_f_cmi = 0.0154714,
    init_nh_ca_f_cms = 0.0135768,
    init_nh_ca_f_cq = 0.449992,
    init_nh_ca_f_csl = 1.21722E-05
  );
end SteadyStatesCellML;
