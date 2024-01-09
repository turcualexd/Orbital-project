/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * kep2car.c
 *
 * Code generation for function 'kep2car'
 *
 */

/* Include files */
#include "kep2car.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include <emmintrin.h>

/* Variable Definitions */
static emlrtRSInfo p_emlrtRSI = {
    57,        /* lineNo */
    "kep2car", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\kep2car.m" /* pathName */
};

/* Function Definitions */
void kep2car(const emlrtStack *sp, real_T a, real_T e, real_T i, real_T OM,
             real_T om, real_T th, real_T rr[3], real_T vv[3])
{
  static const int8_T iv[3] = {0, 0, 1};
  __m128d r;
  __m128d r1;
  emlrtStack st;
  real_T T[9];
  real_T c_R_om_tmp[9];
  real_T d_R_om_tmp[9];
  real_T R_OM_tmp;
  real_T R_i_tmp;
  real_T R_om_tmp;
  real_T b_R_OM_tmp;
  real_T b_R_om_tmp;
  real_T d;
  real_T p;
  int32_T b_i;
  int32_T i1;
  int32_T i2;
  st.prev = sp;
  st.tls = sp->tls;
  /*  Trasformation from Keplerian parameters to cartesian coordinates */
  /*   */
  /*  [rr, vv] = kep2car(a, e, i, OM, om, th, mu) */
  /*   */
  /*  -----------------------------------------------------------------------------------
   */
  /*  Input arguments: */
  /*  a             [1x1]       semi-major axis [km] */
  /*  e             [1x1]       eccentricity [-] */
  /*  i             [1x1]       inclination [rad/deg] */
  /*  OM            [1x1]       RAAN (Right Ascension of the Ascending Node)
   * [rad/deg] */
  /*  om            [1x1]       pericenter anomaly [rad/deg] */
  /*  th            [1x1]       true anomaly [rad/deg] */
  /*  mu            [1x1]       gravitational parameter [km^3/s^2] */
  /*   */
  /*  -----------------------------------------------------------------------------------
   */
  /*  Output arguments: */
  /*  rr            [3x1]       position vector [km] */
  /*  vv            [3x1]       velocity vector [km/s] */
  /*   */
  /*  -----------------------------------------------------------------------------------
   */
  /*  If mu is not assigned, the default value is set to Earth */
  /*  ------------------------------------------------------------- */
  /*  Rotation matrixes */
  R_OM_tmp = muDoubleScalarSin(OM);
  b_R_OM_tmp = muDoubleScalarCos(OM);
  R_i_tmp = muDoubleScalarSin(i);
  p = muDoubleScalarCos(i);
  R_om_tmp = muDoubleScalarSin(om);
  b_R_om_tmp = muDoubleScalarCos(om);
  c_R_om_tmp[0] = b_R_om_tmp;
  c_R_om_tmp[3] = R_om_tmp;
  c_R_om_tmp[6] = 0.0;
  c_R_om_tmp[1] = -R_om_tmp;
  c_R_om_tmp[4] = b_R_om_tmp;
  c_R_om_tmp[7] = 0.0;
  c_R_om_tmp[2] = 0.0;
  T[0] = 1.0;
  c_R_om_tmp[5] = 0.0;
  T[3] = 0.0;
  c_R_om_tmp[8] = 1.0;
  T[6] = 0.0;
  T[1] = 0.0;
  T[4] = p;
  T[7] = R_i_tmp;
  T[2] = 0.0;
  T[5] = -R_i_tmp;
  T[8] = p;
  for (b_i = 0; b_i < 3; b_i++) {
    d = c_R_om_tmp[b_i];
    R_i_tmp = c_R_om_tmp[b_i + 3];
    i1 = (int32_T)c_R_om_tmp[b_i + 6];
    for (i2 = 0; i2 < 3; i2++) {
      d_R_om_tmp[b_i + 3 * i2] = (d * T[3 * i2] + R_i_tmp * T[3 * i2 + 1]) +
                                 (real_T)i1 * T[3 * i2 + 2];
    }
  }
  c_R_om_tmp[0] = b_R_OM_tmp;
  c_R_om_tmp[3] = R_OM_tmp;
  c_R_om_tmp[6] = 0.0;
  c_R_om_tmp[1] = -R_OM_tmp;
  c_R_om_tmp[4] = b_R_OM_tmp;
  c_R_om_tmp[7] = 0.0;
  for (b_i = 0; b_i < 3; b_i++) {
    i1 = iv[b_i];
    c_R_om_tmp[3 * b_i + 2] = i1;
    d = c_R_om_tmp[3 * b_i];
    R_i_tmp = c_R_om_tmp[3 * b_i + 1];
    for (i2 = 0; i2 < 3; i2++) {
      T[b_i + 3 * i2] = (d_R_om_tmp[i2] * d + d_R_om_tmp[i2 + 3] * R_i_tmp) +
                        d_R_om_tmp[i2 + 6] * (real_T)i1;
    }
  }
  /*  ------------------------------------------------------------- */
  /*  Finds rr and vv given the input parameters */
  p = a * (1.0 - e * e);
  R_OM_tmp = muDoubleScalarCos(th);
  R_i_tmp = p / (e * R_OM_tmp + 1.0);
  d = muDoubleScalarSin(th);
  R_om_tmp = R_i_tmp * R_OM_tmp;
  b_R_om_tmp = R_i_tmp * d;
  R_i_tmp *= 0.0;
  r = _mm_loadu_pd(&T[0]);
  r = _mm_mul_pd(r, _mm_set1_pd(R_om_tmp));
  r1 = _mm_loadu_pd(&T[3]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(b_R_om_tmp));
  r = _mm_add_pd(r, r1);
  r1 = _mm_loadu_pd(&T[6]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(R_i_tmp));
  r = _mm_add_pd(r, r1);
  _mm_storeu_pd(&rr[0], r);
  rr[2] = (T[2] * R_om_tmp + T[5] * b_R_om_tmp) + T[8] * R_i_tmp;
  st.site = &p_emlrtRSI;
  R_i_tmp = 1.3271244001800002E+11 / p;
  if (R_i_tmp < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &b_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  R_i_tmp = muDoubleScalarSqrt(R_i_tmp);
  R_om_tmp = R_i_tmp * -d;
  b_R_om_tmp = R_i_tmp * (e + R_OM_tmp);
  R_i_tmp *= 0.0;
  r = _mm_loadu_pd(&T[0]);
  r = _mm_mul_pd(r, _mm_set1_pd(R_om_tmp));
  r1 = _mm_loadu_pd(&T[3]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(b_R_om_tmp));
  r = _mm_add_pd(r, r1);
  r1 = _mm_loadu_pd(&T[6]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(R_i_tmp));
  r = _mm_add_pd(r, r1);
  _mm_storeu_pd(&vv[0], r);
  vv[2] = (T[2] * R_om_tmp + T[5] * b_R_om_tmp) + T[8] * R_i_tmp;
}

/* End of code generation (kep2car.c) */
