/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lsqnonlin.c
 *
 * Code generation for function 'lsqnonlin'
 *
 */

/* Include files */
#include "lsqnonlin.h"
#include "brute_force_validation_data.h"
#include "brute_force_validation_internal_types.h"
#include "checkStoppingCriteria.h"
#include "computeFiniteDifferences.h"
#include "compute_delta.h"
#include "driver.h"
#include "linearLeastSquares.h"
#include "rt_nonfinite.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo ad_emlrtRSI = {
    1,           /* lineNo */
    "lsqnonlin", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\eml\\lsqnonlin.p" /* pathName
                                                                          */
};

static emlrtRSInfo jd_emlrtRSI = {
    1,                          /* lineNo */
    "jacobianFiniteDifference", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\+optim\\+coder\\+"
    "levenbergMarquardt\\jacobianFiniteDifference.p" /* pathName */
};

static emlrtRTEInfo e_emlrtRTEI = {
    1,        /* lineNo */
    1,        /* colNo */
    "driver", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\+optim\\+coder\\+"
    "levenbergMarquardt\\driver.p" /* pName */
};

/* Function Definitions */
real_T lsqnonlin(const emlrtStack *sp, real_T c_fun_workspace_Delta_workspace,
                 real_T d_fun_workspace_Delta_workspace,
                 real_T e_fun_workspace_Delta_workspace)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  h_struct_T FiniteDifferences;
  real_T augJacobian[2];
  real_T rhs[2];
  real_T JacCeqTrans;
  real_T absx;
  real_T b_gamma;
  real_T f_temp;
  real_T funDiff;
  real_T fval;
  real_T gradf;
  real_T jacob;
  real_T projSteepestDescentInfNorm;
  real_T relFactor;
  real_T resnorm;
  real_T xCurrent;
  int32_T exitflag;
  int32_T funcCount;
  int32_T iter;
  boolean_T evalOK;
  boolean_T exitg1;
  boolean_T stepSuccessful;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ad_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  funDiff = rtInf;
  iter = 0;
  xCurrent = 6371.01;
  b_st.site = &bd_emlrtRSI;
  c_st.site = &cd_emlrtRSI;
  f_temp = compute_delta_anonFcn6(&c_st, c_fun_workspace_Delta_workspace,
                                  d_fun_workspace_Delta_workspace,
                                  e_fun_workspace_Delta_workspace, 6371.01);
  resnorm = f_temp * f_temp;
  if (muDoubleScalarIsInf(f_temp) || muDoubleScalarIsNaN(f_temp)) {
    emlrtErrorWithMessageIdR2018a(
        &st, &e_emlrtRTEI, "optimlib_codegen:common:NonFiniteInitialObjective",
        "optimlib_codegen:common:NonFiniteInitialObjective", 0);
  }
  FiniteDifferences.nonlin.workspace.fun.workspace.Delta.workspace.delta_m
      .workspace.e_m.workspace.v_minus = c_fun_workspace_Delta_workspace;
  FiniteDifferences.nonlin.workspace.fun.workspace.Delta.workspace.delta_p
      .workspace.e_p.workspace.v_plus = d_fun_workspace_Delta_workspace;
  FiniteDifferences.nonlin.workspace.fun.workspace.Delta.workspace.delta =
      e_fun_workspace_Delta_workspace;
  b_st.site = &bd_emlrtRSI;
  FiniteDifferences.numEvals = 0;
  FiniteDifferences.hasBounds = true;
  augJacobian[0] = JacCeqTrans;
  JacCeqTrans = 6371.01;
  c_st.site = &jd_emlrtRSI;
  computeFiniteDifferences(&c_st, &FiniteDifferences, f_temp, &JacCeqTrans,
                           &augJacobian[0]);
  fval = f_temp;
  funcCount = FiniteDifferences.numEvals + 1;
  b_st.site = &bd_emlrtRSI;
  LAPACKE_dlacpy_work(102, 'A', (ptrdiff_t)1, (ptrdiff_t)1, &augJacobian[0],
                      (ptrdiff_t)2, &jacob, (ptrdiff_t)1);
  b_gamma = 0.01;
  b_st.site = &bd_emlrtRSI;
  augJacobian[1] = 0.1;
  evalOK = true;
  for (exitflag = 0; exitflag < 2; exitflag++) {
    if (evalOK) {
      JacCeqTrans = augJacobian[exitflag];
      if (muDoubleScalarIsInf(JacCeqTrans) ||
          muDoubleScalarIsNaN(JacCeqTrans)) {
        evalOK = false;
      }
    } else {
      evalOK = false;
    }
  }
  if (!evalOK) {
    emlrtErrorWithMessageIdR2018a(
        &st, &e_emlrtRTEI, "optimlib_codegen:common:NonFiniteInitialJacobian",
        "optimlib_codegen:common:NonFiniteInitialJacobian", 0);
  }
  gradf = jacob * f_temp;
  projSteepestDescentInfNorm = muDoubleScalarAbs(
      muDoubleScalarMin(9.99999362899E+9, muDoubleScalarMax(-6371.01, -gradf)));
  b_st.site = &bd_emlrtRSI;
  JacCeqTrans = computeFirstOrderOpt(gradf, &projSteepestDescentInfNorm);
  relFactor = muDoubleScalarMax(JacCeqTrans, 1.0);
  stepSuccessful = true;
  b_st.site = &bd_emlrtRSI;
  JacCeqTrans = 0.0;
  absx = muDoubleScalarAbs(gradf);
  if (muDoubleScalarIsNaN(absx) || (absx > 0.0)) {
    JacCeqTrans = absx;
  }
  if (projSteepestDescentInfNorm * projSteepestDescentInfNorm <=
      1.0E-10 * JacCeqTrans * relFactor) {
    exitflag = 1;
  } else if (FiniteDifferences.numEvals + 1 >= 200) {
    exitflag = 0;
  } else {
    exitflag = -5;
  }
  exitg1 = false;
  while ((!exitg1) && (exitflag == -5)) {
    real_T dx;
    boolean_T guard1;
    rhs[0] = -fval;
    rhs[1] = 0.0;
    b_st.site = &bd_emlrtRSI;
    absx = -gradf / (b_gamma + 1.0);
    projSteepestDescentInfNorm = muDoubleScalarAbs(muDoubleScalarMin(
        1.0E+10 - xCurrent, muDoubleScalarMax(0.0 - xCurrent, absx)));
    JacCeqTrans = muDoubleScalarMin(projSteepestDescentInfNorm, 5.0E+9);
    if (((xCurrent <= JacCeqTrans) && (gradf > 0.0)) ||
        ((1.0E+10 - xCurrent <= JacCeqTrans) && (gradf < 0.0))) {
      evalOK = true;
    } else {
      evalOK = false;
    }
    if (evalOK) {
      augJacobian[0] = 0.0;
    }
    b_st.site = &bd_emlrtRSI;
    dx = linearLeastSquares(augJacobian, rhs);
    if (evalOK) {
      b_st.site = &bd_emlrtRSI;
      dx = absx;
    }
    JacCeqTrans =
        muDoubleScalarMin(1.0E+10, muDoubleScalarMax(0.0, xCurrent + dx));
    b_st.site = &bd_emlrtRSI;
    c_st.site = &cd_emlrtRSI;
    f_temp = compute_delta_anonFcn6(
        &c_st, c_fun_workspace_Delta_workspace, d_fun_workspace_Delta_workspace,
        e_fun_workspace_Delta_workspace, JacCeqTrans);
    absx = f_temp * f_temp;
    funcCount++;
    guard1 = false;
    if ((absx < resnorm) &&
        ((!muDoubleScalarIsInf(f_temp)) && (!muDoubleScalarIsNaN(f_temp)))) {
      iter++;
      funDiff = muDoubleScalarAbs(absx - resnorm) / resnorm;
      resnorm = absx;
      b_st.site = &bd_emlrtRSI;
      augJacobian[0] = JacCeqTrans;
      c_st.site = &jd_emlrtRSI;
      evalOK = computeFiniteDifferences(&c_st, &FiniteDifferences, f_temp,
                                        &JacCeqTrans, &augJacobian[0]);
      funcCount += FiniteDifferences.numEvals;
      fval = f_temp;
      b_st.site = &bd_emlrtRSI;
      LAPACKE_dlacpy_work(102, 'A', (ptrdiff_t)1, (ptrdiff_t)1, &augJacobian[0],
                          (ptrdiff_t)2, &jacob, (ptrdiff_t)1);
      if (evalOK) {
        xCurrent = JacCeqTrans;
        if (stepSuccessful) {
          b_gamma *= 0.1;
        }
        stepSuccessful = true;
        guard1 = true;
      } else {
        exitg1 = true;
      }
    } else {
      b_gamma *= 10.0;
      stepSuccessful = false;
      b_st.site = &bd_emlrtRSI;
      LAPACKE_dlacpy_work(102, 'A', (ptrdiff_t)1, (ptrdiff_t)1, &jacob,
                          (ptrdiff_t)1, &augJacobian[0], (ptrdiff_t)2);
      guard1 = true;
    }
    if (guard1) {
      b_st.site = &bd_emlrtRSI;
      augJacobian[1] = muDoubleScalarSqrt(b_gamma);
      gradf = jacob * fval;
      projSteepestDescentInfNorm = muDoubleScalarAbs(muDoubleScalarMin(
          1.0E+10 - xCurrent, muDoubleScalarMax(0.0 - xCurrent, -gradf)));
      b_st.site = &bd_emlrtRSI;
      exitflag = checkStoppingCriteria(gradf, relFactor, funDiff, xCurrent, dx,
                                       funcCount, stepSuccessful, &iter,
                                       projSteepestDescentInfNorm);
      if (exitflag != -5) {
        exitg1 = true;
      }
    }
  }
  b_st.site = &bd_emlrtRSI;
  computeFirstOrderOpt(gradf, &projSteepestDescentInfNorm);
  return xCurrent;
}

/* End of code generation (lsqnonlin.c) */
