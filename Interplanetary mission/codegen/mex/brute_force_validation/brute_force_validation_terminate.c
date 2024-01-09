/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * brute_force_validation_terminate.c
 *
 * Code generation for function 'brute_force_validation_terminate'
 *
 */

/* Include files */
#include "brute_force_validation_terminate.h"
#include "_coder_brute_force_validation_mex.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void brute_force_validation_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void brute_force_validation_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (brute_force_validation_terminate.c) */
