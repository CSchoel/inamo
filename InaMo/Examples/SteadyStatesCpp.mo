within InaMo.Examples;
model SteadyStatesCpp
  extends SteadyStates(
    init_an_v = -7.02E-02,
    init_an_na_act = 0.012459,
    init_an_na_inact_slow = 0.63777,
    init_an_na_inact_fast = 0.72733,
    init_an_cal_act = 3.95E-05,
    init_an_cal_inact_fast = 0.99854,
    init_an_cal_inact_slow = 0.99111,
    init_an_to_act = 0.0087042,
    init_an_to_inact_fast = 0.8847,
    init_an_to_inact_slow = 0.20263,
    init_an_kr_act_slow = 0.034731,
    init_an_kr_act_fast = 0.034731,
    init_an_kr_inact = 0.98678,
    init_an_ca_cyto = 1.08E-04,
    init_an_ca_sub = 5.86E-05,
    init_an_ca_jsr = 4.00E-01,
    init_an_ca_nsr = 9.60E-01,
    init_an_ca_f_tc = 0.021203,
    init_an_ca_f_tmc = 0.33949,
    init_an_ca_f_tmm = 0.58343,
    init_an_ca_f_cmi = 0.043662,
    init_an_ca_f_cms = 0.024102,
    init_an_ca_f_cq = 0.32345,
    init_an_ca_f_csl = 3.09E-05,

    init_n_v = -6.21E-02,
    init_n_cal_act = 1.53E-04,
    init_n_cal_inact_fast = 0.68093,
    init_n_cal_inact_slow = 0.33202,
    init_n_kr_act_slow = 0.12876,
    init_n_kr_act_fast = 0.60607,
    init_n_kr_inact = 0.97752,
    init_n_f_act = 0.038225,
    init_n_st_act = 0.19362,
    init_n_st_inact = 0.4885,
    init_n_ca_cyto = 3.63E-04,
    init_n_ca_sub = 2.30E-04,
    init_n_ca_jsr = 8.18E-02,
    init_n_ca_nsr = 1.15E+00,
    init_n_ca_f_tc = 0.068561,
    init_n_ca_f_tmc = 0.61949,
    init_n_ca_f_tmm = 0.33603,
    init_n_ca_f_cmi = 0.13393,
    init_n_ca_f_cms = 0.089149,
    init_n_ca_f_cq = 0.086939,
    init_n_ca_f_csl = 4.67E-05,

    init_nh_v = -6.87E-02,
    init_nh_na_act = 0.015215,
    init_nh_na_inact_slow = 0.56383,
    init_nh_na_inact_fast = 0.64629,
    init_nh_cal_act = 5.00E-05,
    init_nh_cal_inact_fast = 0.99814,
    init_nh_cal_inact_slow = 0.98513,
    init_nh_to_act = 0.0095587,
    init_nh_to_inact_fast = 0.8708,
    init_nh_to_inact_slow = 0.13435,
    init_nh_kr_act_slow = 0.067693,
    init_nh_kr_act_fast = 0.093329,
    init_nh_kr_inact = 0.98537,
    init_nh_ca_cyto = 1.34E-04,
    init_nh_ca_sub = 7.12E-05,
    init_nh_ca_jsr = 4.48E-01,
    init_nh_ca_nsr = 1.16E+00,
    init_nh_ca_f_tc = 0.026148,
    init_nh_ca_f_tmc = 0.39299,
    init_nh_ca_f_tmm = 0.53615,
    init_nh_ca_f_cmi = 0.05355,
    init_nh_ca_f_cms = 0.029115,
    init_nh_ca_f_cq = 0.34828,
    init_nh_ca_f_csl = 4.45E-05
  );
end SteadyStatesCpp;
