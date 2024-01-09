/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * finDiffEvalAndChkErr.c
 *
 * Code generation for function 'finDiffEvalAndChkErr'
 *
 */

/* Include files */
#include "finDiffEvalAndChkErr.h"
#include "brute_force_validation_data.h"
#include "brute_force_validation_internal_types.h"
#include "compute_delta.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo md_emlrtRSI = {
    1,                      /* lineNo */
    "finDiffEvalAndChkErr", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2023b\\toolbox\\shared\\optimlib\\+optim\\+coder\\+"
    "utils\\+FiniteDifferences\\+internal\\finDiffEval"
    "AndChkErr.p" /* pathName */
};

/* Function Definitions */
boolean_T finDiffEvalAndChkErr(const emlrtStack *sp,
                               const struct_T c_obj_nonlin_workspace_fun_work,
                               const c_struct_T d_obj_nonlin_workspace_fun_work,
                               real_T e_obj_nonlin_workspace_fun_work,
                               real_T delta, const real_T *xk, real_T *fplus,
                               real_T *cEqPlus)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  int32_T idx;
  boolean_T evalOK;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  *fplus = 0.0;
  evalOK = true;
  st.site = &md_emlrtRSI;
  b_st.site = &cd_emlrtRSI;
  c_st.site = &bd_emlrtRSI;
  d_st.site = &cd_emlrtRSI;
  *cEqPlus =
      compute_delta_anonFcn6(&d_st, c_obj_nonlin_workspace_fun_work.v_minus,
                             d_obj_nonlin_workspace_fun_work.v_plus,
                             e_obj_nonlin_workspace_fun_work, *xk + delta);
  idx = 1;
  while (evalOK && (idx <= 1)) {
    evalOK =
        ((!muDoubleScalarIsInf(*cEqPlus)) && (!muDoubleScalarIsNaN(*cEqPlus)));
    idx = 2;
  }
  return evalOK;
}

/* End of code generation (finDiffEvalAndChkErr.c) */
