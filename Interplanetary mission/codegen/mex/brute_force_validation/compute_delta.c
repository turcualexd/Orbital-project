/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * compute_delta.c
 *
 * Code generation for function 'compute_delta'
 *
 */

/* Include files */
#include "compute_delta.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo dd_emlrtRSI = {
    14,               /* lineNo */
    "@(rp)Delta(rp)", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\Interplanetary "
    "mission\\compute_delta.m" /* pathName */
};

static emlrtRSInfo ed_emlrtRSI = {
    12,                                       /* lineNo */
    "@(rp)delta_m(rp)/2+delta_p(rp)/2-delta", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\Interplanetary "
    "mission\\compute_delta.m" /* pathName */
};

static emlrtRSInfo fd_emlrtRSI = {
    6,                         /* lineNo */
    "@(rp)2*asin(1./e_m(rp))", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\Interplanetary "
    "mission\\compute_delta.m" /* pathName */
};

static emlrtRSInfo hd_emlrtRSI = {
    10,                        /* lineNo */
    "@(rp)2*asin(1./e_p(rp))", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\Interplanetary "
    "mission\\compute_delta.m" /* pathName */
};

/* Function Definitions */
real_T compute_delta_anonFcn6(const emlrtStack *sp,
                              real_T c_Delta_workspace_delta_m_works,
                              real_T c_Delta_workspace_delta_p_works,
                              real_T Delta_workspace_delta, real_T rp)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack st;
  real_T b_x;
  real_T x;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &dd_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  b_st.site = &cd_emlrtRSI;
  c_st.site = &ed_emlrtRSI;
  d_st.site = &cd_emlrtRSI;
  e_st.site = &fd_emlrtRSI;
  x = 1.0 /
      (rp *
           (c_Delta_workspace_delta_m_works * c_Delta_workspace_delta_m_works) /
           398600.433 +
       1.0);
  if ((x < -1.0) || (x > 1.0)) {
    emlrtErrorWithMessageIdR2018a(
        &e_st, &f_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
  }
  x = muDoubleScalarAsin(x);
  c_st.site = &ed_emlrtRSI;
  d_st.site = &cd_emlrtRSI;
  e_st.site = &hd_emlrtRSI;
  b_x =
      1.0 /
      (rp *
           (c_Delta_workspace_delta_p_works * c_Delta_workspace_delta_p_works) /
           398600.433 +
       1.0);
  if ((b_x < -1.0) || (b_x > 1.0)) {
    emlrtErrorWithMessageIdR2018a(
        &e_st, &f_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
  }
  b_x = muDoubleScalarAsin(b_x);
  return (2.0 * x / 2.0 + 2.0 * b_x / 2.0) - Delta_workspace_delta;
}

/* End of code generation (compute_delta.c) */
