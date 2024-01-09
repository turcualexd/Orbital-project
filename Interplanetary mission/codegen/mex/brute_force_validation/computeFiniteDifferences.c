/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFiniteDifferences.c
 *
 * Code generation for function 'computeFiniteDifferences'
 *
 */

/* Include files */
#include "computeFiniteDifferences.h"
#include "brute_force_validation_internal_types.h"
#include "finDiffEvalAndChkErr.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo kd_emlrtRSI = {
    1,                          /* lineNo */
    "computeFiniteDifferences", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\+optim\\+coder\\+"
    "utils\\+FiniteDifferences\\computeFiniteDifferenc"
    "es.p" /* pathName */
};

static emlrtRSInfo ld_emlrtRSI = {
    1,                           /* lineNo */
    "computeForwardDifferences", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\+optim\\+coder\\+"
    "utils\\+FiniteDifferences\\+internal\\computeForw"
    "ardDifferences.p" /* pathName */
};

/* Function Definitions */
boolean_T computeFiniteDifferences(const emlrtStack *sp, h_struct_T *obj,
                                   real_T cEqCurrent, const real_T *xk,
                                   real_T *JacCeqTrans)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T b_deltaX;
  real_T d;
  real_T deltaX;
  boolean_T evalOK;
  boolean_T guard1;
  boolean_T modifiedStep;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &kd_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  obj->numEvals = 0;
  deltaX = 1.4901161193847656E-8 * (1.0 - 2.0 * (real_T)(*xk < 0.0)) *
           muDoubleScalarMax(muDoubleScalarAbs(*xk), 1.0);
  modifiedStep = false;
  if ((*xk >= 0.0) && (*xk <= 1.0E+10)) {
    d = *xk + deltaX;
    if ((d > 1.0E+10) || (d < 0.0)) {
      deltaX = -deltaX;
      modifiedStep = true;
      d = *xk + deltaX;
      if ((d > 1.0E+10) || (d < 0.0)) {
        if (*xk <= 1.0E+10 - *xk) {
          deltaX = -*xk;
        } else {
          deltaX = 1.0E+10 - *xk;
        }
      }
    }
  }
  b_deltaX = deltaX;
  b_st.site = &ld_emlrtRSI;
  evalOK = finDiffEvalAndChkErr(
      &b_st,
      obj->nonlin.workspace.fun.workspace.Delta.workspace.delta_m.workspace.e_m
          .workspace,
      obj->nonlin.workspace.fun.workspace.Delta.workspace.delta_p.workspace.e_p
          .workspace,
      obj->nonlin.workspace.fun.workspace.Delta.workspace.delta, deltaX, xk, &d,
      &obj->cEq_1);
  obj->numEvals++;
  guard1 = false;
  if (!evalOK) {
    if (!modifiedStep) {
      b_deltaX = -deltaX;
      d = *xk - deltaX;
      if ((d >= 0.0) && (d <= 1.0E+10)) {
        modifiedStep = true;
      } else {
        modifiedStep = false;
      }
      if ((!obj->hasBounds) || modifiedStep) {
        b_st.site = &ld_emlrtRSI;
        evalOK = finDiffEvalAndChkErr(
            &b_st,
            obj->nonlin.workspace.fun.workspace.Delta.workspace.delta_m
                .workspace.e_m.workspace,
            obj->nonlin.workspace.fun.workspace.Delta.workspace.delta_p
                .workspace.e_p.workspace,
            obj->nonlin.workspace.fun.workspace.Delta.workspace.delta, -deltaX,
            xk, &d, &obj->cEq_1);
        obj->numEvals++;
      }
    }
    if (evalOK) {
      guard1 = true;
    }
  } else {
    guard1 = true;
  }
  if (guard1) {
    *JacCeqTrans = (obj->cEq_1 - cEqCurrent) / b_deltaX;
  }
  return evalOK;
}

/* End of code generation (computeFiniteDifferences.c) */
