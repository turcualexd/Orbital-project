/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mjd20002date.c
 *
 * Code generation for function 'mjd20002date'
 *
 */

/* Include files */
#include "mjd20002date.h"
#include "brute_force_validation_data.h"
#include "brute_force_validation_mexutil.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include <math.h>

/* Variable Definitions */
static emlrtRSInfo xd_emlrtRSI = {
    39,             /* lineNo */
    "mjd20002date", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\mjd20002date.m" /* pathName */
};

static emlrtRSInfo yd_emlrtRSI = {
    78,        /* lineNo */
    "jd2date", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\jd2date.m" /* pathName */
};

static emlrtRSInfo ae_emlrtRSI = {
    45,            /* lineNo */
    "fracday2hms", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\time\\fracday2hms.m" /* pathName */
};

/* Function Definitions */
void mjd20002date(const emlrtStack *sp, real_T mjd2000, real_T date[6])
{
  static const int32_T iv[2] = {1, 26};
  static const int32_T iv1[2] = {1, 73};
  static const char_T varargin_2[73] = {
      'T', 'h', 'e', ' ', 'i', 'n', 'p', 'u', 't', ' ', 's', 'h', 'o', 'u', 'l',
      'd', ' ', 'b', 'e', ' ', 'r', 'e', 'a', 'l', ' ', 'g', 'r', 'e', 'a', 't',
      'e', 'r', ' ', 'o', 'r', ' ', 'e', 'q', 'u', 'a', 'l', ' ', 't', 'o', ' ',
      '0', ' ', ',', 'a', 'n', 'd', ' ', 's', 't', 'r', 'i', 'c', 't', 'l', 'y',
      ' ', 'l', 'o', 'w', 'e', 'r', ' ', 't', 'h', 'a', 'n', ' ', '1'};
  static const char_T varargin_1[26] = {
      'F', 'R', 'A', 'C', 'D', 'A', 'Y', '2', 'H', 'M', 'S', ':', 'i',
      'n', 'c', 'o', 'r', 'r', 'e', 'c', 't', 'I', 'n', 'p', 'u', 't'};
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  const mxArray *b_y;
  const mxArray *c_y;
  const mxArray *m;
  real_T a;
  real_T c;
  real_T da;
  real_T dc;
  real_T dg;
  real_T hrs;
  real_T mn;
  real_T r;
  real_T y;
  real_T y_tmp;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  /* MJD20002DATE Gregorian calendar date from modified Julian day 2000 number.
   */
  /*  */
  /*  DATE = MJD20002DATE(MJD2000) returns the Gregorian calendar date */
  /*  (year, month, day, hour, minute, and second) corresponding to the */
  /*  modified Julian day 2000 number. */
  /*  */
  /*  Note: Since this function calls jd2date, MJD2000 cannot be less than */
  /*        -2451545, that is 24 November -4713, 12:00 noon, Gregorian */
  /*        proleptic calendar. */
  /*  */
  /*  INPUT */
  /* 	mjd2000     Date in MJD 2000. MJD2000 is defined as the number of days
   */
  /*                since 01-01-2000, 12:00 noon. It must be a real greater or
   */
  /*                equal than -2451545. */
  /*  */
  /*  OUTPUT */
  /*    date        Date in the Gregorian calendar, as a 6-element vector */
  /*                [year, month, day, hour, minute, second]. For dates before
   */
  /*                1582, the resulting date components are valid only in the */
  /*                Gregorian proleptic calendar. This is based on the */
  /*                Gregorian calendar but extended to cover dates before its */
  /*                introduction. */
  /*  */
  /*  See also DATE2MJD2000. */
  /*  */
  /*  FUNCTIONS CALLED */
  /*    MJD20002JD */
  /*    JD2DATE */
  /*  */
  /*  - Nicolas Croisard - 16/02/2008 */
  /*  - Revised by Matteo Ceriotti - 21/02/2008 */
  /*  */
  /*  ------------------------- - SpaceART Toolbox - --------------------------
   */
  /*  Compute the year month and day */
  /* MJD20002JD Julian day number from Modified Julian day 2000 number. */
  /*  */
  /*  JD = MJD20002JD(MJD2000) returns the Julian day number corresponding to */
  /*  the given modified Julian day 2000 number. */
  /*  */
  /*  INPUT */
  /* 	mjd2000     Date in MJD 2000. MJD2000 is defined as the number of days
   */
  /*                since 01-01-2000, 12:00 noon.  */
  /*  */
  /*  OUTPUT */
  /*    jd          Date in Julian Day. The JD (Julian day) count is from 0 at
   */
  /*                12:00 noon, 1 January -4712 (4713 BC), Julian proleptic */
  /*                calendar. The corresponding date in Gregorian calendar is */
  /*                12:00 noon, 24 November -4713. */
  /*  */
  /*  See also JD2MJD2000. */
  /*  */
  /*  FUNCTIONS CALLED */
  /*    none */
  /*  */
  /*  - Nicolas Croisard - 16/02/2008 */
  /*  - Revised by Matteo Ceriotti - 20/02/2008 */
  /*  */
  /*  ------------------------- - SpaceART Toolbox - --------------------------
   */
  st.site = &xd_emlrtRSI;
  /* JD2DATE Gregorian calendar date from Julian day number. */
  /*  */
  /*  DATE = JD2DATE(JD) returns the Gregorian calendar date (year, month, day,
   */
  /*  hour, minute, and second) corresponding to the Julian day number JD. */
  /*  */
  /*  Note: jd must be a non-negative real. This means that the function is */
  /*        valid for the whole range of dates since 12:00 noon 24 November */
  /*        -4713, Gregorian calendar. (This bound is due to the function */
  /*        FRACDAY2HMS that does not work for negative inputs) */
  /*  */
  /*  INPUT */
  /*    jd          Date in Julian Day. The JD (Julian day) count is from 0 at
   */
  /*                12:00 noon, 1 January -4712 (4713 BC), Julian proleptic */
  /*                calendar. The corresponding date in Gregorian calendar is */
  /*                12:00 noon, 24 November -4713. It must be a non-negative */
  /*                real. */
  /*  */
  /*  OUTPUT */
  /* 	date        Date in the Gregorian calendar, as a 6-element vector */
  /*                [year, month, day, hour, minute, second]. For dates before
   */
  /*                1582, the resulting date components are valid only in the */
  /*                Gregorian proleptic calendar. This is based on the */
  /*                Gregorian calendar but extended to cover dates before its */
  /*                introduction. */
  /*  */
  /*  REFERENCES */
  /*    Formula from http://en.wikipedia.org/wiki/Julian_day */
  /*    (last visited 16/02/2008) */
  /*    Compared to http://pdc.ro.nu/mjd.cgi for a few dates, the same results
   */
  /*    were found */
  /*  */
  /*  See also DATE2JD. */
  /*  */
  /*  FUNCTIONS CALLED */
  /*    FRACDAY2HMS */
  /*  */
  /*  - Nicolas Croisard - 16/02/2008 */
  /*  - Revised by Matteo Ceriotti - 21/02/2008 - Validated with: */
  /*    - Fliegel, Van Flandern "A machine Algorithm for Processing Calendar */
  /*      Dates", Communications of the ACM, 1968. Also on Wertz, "Space */
  /*      Mission Analysis and Design". */
  /*    - A revised version of the algorithm on Vallado, "Fundamentals of */
  /*      Astrodynamics and Applications", third edition, for dates from year */
  /*      1900 to year 2100. */
  /*  */
  /*  ------------------------- - SpaceART Toolbox - --------------------------
   */
  /*  Check the input */
  /*  if jd < 0 */
  /*      error('JD2DATE:jdLessThanZero','The input jd value cannot be
   * negative'); */
  /*  end */
  /*  Adding 0.5 to JD and taking FLOOR ensures that the date is correct. */
  y_tmp = muDoubleScalarFloor(((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5);
  if (muDoubleScalarIsNaN(y_tmp + 32044.0) ||
      muDoubleScalarIsInf(y_tmp + 32044.0)) {
    dg = rtNaN;
  } else if (y_tmp + 32044.0 == 0.0) {
    dg = 0.0;
  } else {
    dg = muDoubleScalarRem(y_tmp + 32044.0, 146097.0);
    if (dg == 0.0) {
      dg = 0.0;
    } else if (y_tmp + 32044.0 < 0.0) {
      dg += 146097.0;
    }
  }
  c = muDoubleScalarFloor((muDoubleScalarFloor(dg / 36524.0) + 1.0) * 3.0 /
                          4.0);
  dc = dg - c * 36524.0;
  if (muDoubleScalarIsNaN(dc)) {
    dg = rtNaN;
  } else if (dc == 0.0) {
    dg = 0.0;
  } else {
    dg = muDoubleScalarRem(dc, 1461.0);
    if (dg == 0.0) {
      dg = 0.0;
    } else if (dc < 0.0) {
      dg += 1461.0;
    }
  }
  a = muDoubleScalarFloor((muDoubleScalarFloor(dg / 365.0) + 1.0) * 3.0 / 4.0);
  da = dg - a * 365.0;
  y = muDoubleScalarFloor((da * 5.0 + 308.0) / 153.0);
  /*  Year, Month and Day */
  if (muDoubleScalarIsNaN((y - 2.0) + 2.0)) {
    r = rtNaN;
  } else if ((y - 2.0) + 2.0 == 0.0) {
    r = 0.0;
  } else {
    r = muDoubleScalarRem((y - 2.0) + 2.0, 12.0);
    if (r == 0.0) {
      r = 0.0;
    } else if ((y - 2.0) + 2.0 < 0.0) {
      r += 12.0;
    }
  }
  /*  Hour, Minute and Second */
  b_st.site = &yd_emlrtRSI;
  dg = ((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5;
  if (y_tmp == 0.0) {
    if (((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5 == 0.0) {
      dg = y_tmp;
    }
  } else if (muDoubleScalarIsNaN(((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5) ||
             muDoubleScalarIsNaN(y_tmp) ||
             muDoubleScalarIsInf(((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5)) {
    dg = rtNaN;
  } else if (((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5 == 0.0) {
    dg = 0.0 / y_tmp;
  } else if (muDoubleScalarIsInf(y_tmp)) {
    if ((y_tmp < 0.0) != (((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5 < 0.0)) {
      dg = y_tmp;
    }
  } else {
    dg = muDoubleScalarRem(((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5, y_tmp);
    if (dg == 0.0) {
      dg = y_tmp * 0.0;
    } else if ((((mjd2000 + 51544.5) + 2.4000005E+6) + 0.5 < 0.0) !=
               (y_tmp < 0.0)) {
      dg += y_tmp;
    }
  }
  /*  fracday2hms.m - Converts a fraction of day into hours, minutes, and */
  /* 	seconds. */
  /*  */
  /*  PROTPTYPE: */
  /*    [hrs, mn, sec] = fracday2hms(fracDay) */
  /*  */
  /*  DESCRIPTION: */
  /*  	Converts the fraction of day to hours, minutes, and seconds. */
  /*  */
  /*  INPUT: */
  /*     fracDay[1] A single real greater or equal to 0 and strictly lower than
   */
  /*                1. */
  /*  */
  /*  OUTPUT: */
  /*     hrs[1]     Number of hours as integer greater or equal to 0 and lower
   */
  /*                or equal to 23. */
  /*     mn[1]      Number of minutes as integer greater or equal to 0 and */
  /*                lower or equal to 59. */
  /*     sec[1]     Number of seconds as a real greater or equal to 0 and */
  /*                strictly lower than 60. */
  /*  */
  /*  See also hms2fracday. */
  /*  */
  /*  CALLED FUNCTIONS: */
  /*    (none) */
  /*  */
  /*  AUTHOR: */
  /* 	Nicolas Croisard, 16/02/2008, MATLAB, fracday2hms.m */
  /*  */
  /*  CHANGELOG: */
  /*    21/02/2008, REVISION, Matteo Ceriotti */
  /*    22/04/2010, Camilla Colombo: Header and function name in accordance */
  /*        with guidlines. */
  /*  */
  /*  -------------------------------------------------------------------------
   */
  /*  Check the input */
  if ((dg < 0.0) || (dg >= 1.0)) {
    c_st.site = &ae_emlrtRSI;
    b_y = NULL;
    m = emlrtCreateCharArray(2, &iv[0]);
    emlrtInitCharArrayR2013a(&c_st, 26, m, &varargin_1[0]);
    emlrtAssign(&b_y, m);
    c_y = NULL;
    m = emlrtCreateCharArray(2, &iv1[0]);
    emlrtInitCharArrayR2013a(&c_st, 73, m, &varargin_2[0]);
    emlrtAssign(&c_y, m);
    d_st.site = &be_emlrtRSI;
    b_error(&d_st, b_y, c_y, &emlrtMCI);
  }
  dg *= 24.0;
  hrs = trunc(dg);
  dg -= hrs;
  mn = trunc(dg * 60.0);
  /*  Prepare output */
  date[0] = ((((muDoubleScalarFloor((y_tmp + 32044.0) / 146097.0) * 400.0 +
                c * 100.0) +
               muDoubleScalarFloor(dc / 1461.0) * 4.0) +
              a) -
             4800.0) +
            muDoubleScalarFloor(((y - 2.0) + 2.0) / 12.0);
  date[1] = r + 1.0;
  date[2] =
      ((da - muDoubleScalarFloor(((y - 2.0) + 4.0) * 153.0 / 5.0)) + 122.0) +
      1.0;
  date[3] = hrs;
  date[4] = mn;
  date[5] = (dg - mn / 60.0) * 3600.0;
}

/* End of code generation (mjd20002date.c) */
