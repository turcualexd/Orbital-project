clear; close all; clc;

earl_dep_date   = [2028 01 01 00 00 00];
late_arr_date   = [2028 + 13 01 01 00 00 00];

dep_mjd2000     = linspace(date2mjd2000(earl_dep_date), date2mjd2000(late_arr_date), 343);
fb_mjd2000      = dep_mjd2000;
TOF1            = fb_mjd2000  - dep_mjd2000(1);
TOF2            = TOF1;

[dv_min, dep_date, fb_date, arr_date] = brute_force(dep_mjd2000, TOF1, TOF2);

date_dep = mjd20002date(dep_date);
date_fb = mjd20002date(fb_date);
date_arr = mjd20002date(arr_date);