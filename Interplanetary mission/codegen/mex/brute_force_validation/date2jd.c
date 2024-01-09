/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * date2jd.c
 *
 * Code generation for function 'date2jd'
 *
 */

/* Include files */
#include "date2jd.h"
#include "brute_force_validation_data.h"
#include "brute_force_validation_mexutil.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo g_emlrtRSI = {
    80,        /* lineNo */
    "date2jd", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\date2jd.m" /* pathName */
};

static emlrtRSInfo h_emlrtRSI = {
    55,            /* lineNo */
    "hms2fracday", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\hms2fracday.m" /* pathName */
};

static emlrtRSInfo i_emlrtRSI = {
    45,            /* lineNo */
    "hms2fracday", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\hms2fracday.m" /* pathName */
};

/* Function Definitions */
real_T date2jd(const emlrtStack *sp, const real_T date[6])
{
  static const int32_T iv[2] = {1, 26};
  static const int32_T iv1[2] = {1, 26};
  static const int32_T iv2[2] = {1, 84};
  static const int32_T iv3[2] = {1, 86};
  static const char_T b_varargin_2[86] = {
      'T', 'h', 'e', ' ', 'm', 'i', 'n', 'u', 't', 'e', 's', ' ', 'm', 'u', 's',
      't', ' ', 'b', 'e', ' ', 'g', 'i', 'v', 'e', 'n', ' ', 'a', 's', ' ', 'a',
      'n', ' ', 'i', 'n', 't', 'e', 'g', 'e', 'r', ' ', 'g', 'r', 'e', 'a', 't',
      'e', 'r', ' ', 'o', 'r', ' ', 'e', 'q', 'u', 'a', 'l', ' ', 't', 'o', ' ',
      '0', ' ', 'a', 'n', 'd', ' ', 'l', 'o', 'w', 'e', 'r', ' ', 'o', 'r', ' ',
      'e', 'q', 'u', 'a', 'l', ' ', 't', 'o', ' ', '5', '9'};
  static const char_T varargin_2[84] = {
      'T', 'h', 'e', ' ', 'h', 'o', 'u', 'r', 's', ' ', 'm', 'u', 's', 't',
      ' ', 'b', 'e', ' ', 'g', 'i', 'v', 'e', 'n', ' ', 'a', 's', ' ', 'a',
      'n', ' ', 'i', 'n', 't', 'e', 'g', 'e', 'r', ' ', 'g', 'r', 'e', 'a',
      't', 'e', 'r', ' ', 'o', 'r', ' ', 'e', 'q', 'u', 'a', 'l', ' ', 't',
      'o', ' ', '0', ' ', 'a', 'n', 'd', ' ', 'l', 'o', 'w', 'e', 'r', ' ',
      'o', 'r', ' ', 'e', 'q', 'u', 'a', 'l', ' ', 't', 'o', ' ', '2', '3'};
  static const char_T varargin_1[26] = {
      'H', 'M', 'S', '2', 'F', 'R', 'A', 'C', 'D', 'A', 'Y', ':', 'i',
      'n', 'c', 'o', 'r', 'r', 'e', 'c', 't', 'I', 'n', 'p', 'u', 't'};
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  const mxArray *b_y;
  const mxArray *c_y;
  const mxArray *d_y;
  const mxArray *m;
  const mxArray *y;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  /*  date2jd.m - Julian day number from Gregorian date. */
  /*  */
  /*  PROTOTYPE: */
  /*    jd = date2jd(date) */
  /*  */
  /*  DESCRIPTION: */
  /*    Returns the Julian day number of the given date (Gregorian calendar) */
  /*    plus a fractional part depending on the time of day. */
  /*    Note: The function is valid for the whole range of dates since 12:00 */
  /*        noon 24 November -4713, Gregorian calendar. (This bound is set in */
  /*        order to have symmetry with the inverse function jd2date.m) */
  /*    Note: The inputs must be feasible (i.e. the date must exist!). If an */
  /*        unfeasible date is inputed, wrong results are given because no */
  /*        check is done on that. */
  /*  */
  /*  INPUT: */
  /* 	date[6]     Date in the Gregorian calendar, as a 6-elements vector */
  /*                [year, month, day, hour, minute, second]. For dates before
   */
  /*                1582, the resulting date components are valid only in the */
  /*                Gregorian proleptic calendar. This is based on the */
  /*                Gregorian calendar but extended to cover dates before its */
  /*                introduction. Date must be after 12:00 noon, 24 November */
  /*                -4713. */
  /*  */
  /*  OUTPUT: */
  /*    jd[1]       Date in Julian Day. The JD (Julian day) count is from 0 at
   */
  /*                12:00 noon, 1 January -4712 (4713 BC), Julian proleptic */
  /*                calendar. The corresponding date in Gregorian calendar is */
  /*                12:00 noon, 24 November -4713. */
  /*  */
  /*  REFERENCES: */
  /*    Formula from http://scienceworld.wolfram.com/astronomy/JulianDate.html
   */
  /*    (last visited 15/02/2008) */
  /*    Compared to http://pdc.ro.nu/mjd.cgi for a few dates, the same results
   */
  /*    were found */
  /*  */
  /*  See also JD2DATE. */
  /*  */
  /*  CALLED FUNCTIONS */
  /*    hms2fracday */
  /*  */
  /*  AUTHOR: */
  /*    Nicolas Croisard, 16/02/2008, MATLAB, date2jd.m */
  /*  */
  /*  CHANGELOG: */
  /*    03/03/2008, REVISION: Camilla Colombo */
  /*    22/04/2010, Camilla Colombo: Header and function name in accordance */
  /*        with guidlines. */
  /*  */
  /*  -------------------------------------------------------------------------
   */
  /*  Check the input */
  /*  Manage the input */
  /*  Check the inputs */
  /*  Formula converting Gregorian date into JD */
  st.site = &g_emlrtRSI;
  /* HMS2FRACDAY Convert hours, minutes, and seconds into a fraction of day. */
  /*  */
  /*  FRACDAY = HMS2FRACDAY(HRS, MN, SEC) converts the fraction of day to */
  /*  hours, minutes, and seconds. */
  /*  */
  /*  INPUT */
  /*     hrs        Number of hours as integer greater or equal to 0 and lower
   */
  /*                or equal to 23. */
  /*     mn         Number of minutes as integer greater or equal to 0 and */
  /*                lower or equal to 59. */
  /*     sec        Number of seconds as a real greater or equal to 0 and */
  /*                strictly lower than 60. */
  /*  */
  /*  OUTPUT */
  /*     fracDay    A single real greater or equal to 0 and strictly lower than
   */
  /*                1. */
  /*  */
  /*  See also FRACDAY2HMS. */
  /*  */
  /*  FUNCTIONS CALLED */
  /*    none */
  /*  */
  /*  - Nicolas Croisard - 16/02/2008 */
  /*  - Revised by Camilla Colombo - 29/02/2008 */
  /*  */
  /*  ------------------------- - SpaceART Toolbox - --------------------------
   */
  /*  Check the inputs */
  /* ------------------ */
  /*  Number of inputs */
  /*  Check the hours */
  if (muDoubleScalarFloor(date[3]) != date[3]) {
    b_st.site = &i_emlrtRSI;
    y = NULL;
    m = emlrtCreateCharArray(2, &iv[0]);
    emlrtInitCharArrayR2013a(&b_st, 26, m, &varargin_1[0]);
    emlrtAssign(&y, m);
    c_y = NULL;
    m = emlrtCreateCharArray(2, &iv2[0]);
    emlrtInitCharArrayR2013a(&b_st, 84, m, &varargin_2[0]);
    emlrtAssign(&c_y, m);
    c_st.site = &be_emlrtRSI;
    b_error(&c_st, y, c_y, &emlrtMCI);
  }
  /*  Check the minutes */
  if (muDoubleScalarFloor(date[4]) != date[4]) {
    b_st.site = &h_emlrtRSI;
    b_y = NULL;
    m = emlrtCreateCharArray(2, &iv1[0]);
    emlrtInitCharArrayR2013a(&b_st, 26, m, &varargin_1[0]);
    emlrtAssign(&b_y, m);
    d_y = NULL;
    m = emlrtCreateCharArray(2, &iv3[0]);
    emlrtInitCharArrayR2013a(&b_st, 86, m, &b_varargin_2[0]);
    emlrtAssign(&d_y, m);
    c_st.site = &be_emlrtRSI;
    b_error(&c_st, b_y, d_y, &emlrtMCI);
  }
  /*  Check the minutes */
  /*  Compute the fraction of day */
  /* ----------------------------- */
  return (((((367.0 * date[0] -
              muDoubleScalarFloor(
                  7.0 *
                  (date[0] + muDoubleScalarFloor((date[1] + 9.0) / 12.0)) /
                  4.0)) -
             muDoubleScalarFloor(
                 3.0 *
                 muDoubleScalarFloor((date[0] + (date[1] - 9.0) / 7.0) / 100.0 +
                                     1.0) /
                 4.0)) +
            muDoubleScalarFloor(275.0 * date[1] / 9.0)) +
           date[2]) +
          1.7210285E+6) +
         (date[3] + (date[4] + date[5] / 60.0) / 60.0) / 24.0;
  /*  Equivalent formula: */
  /*  a = floor((14 - M)/12); */
  /*  y = Y + 4800 - a; */
  /*  m = M + 12*a - 3; */
  /*  jd = D + floor((153*m + 2)/5) +... */
  /*         + y*365 + floor(y/4) - floor(y/100) + floor(y/400) - 32045.5 +...
   */
  /*         + hms2fracday(hrs,mn,sec); */
}

/* End of code generation (date2jd.c) */
