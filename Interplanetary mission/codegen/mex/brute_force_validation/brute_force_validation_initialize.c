/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * brute_force_validation_initialize.c
 *
 * Code generation for function 'brute_force_validation_initialize'
 *
 */

/* Include files */
#include "brute_force_validation_initialize.h"
#include "_coder_brute_force_validation_mex.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void brute_force_validation_once(void);

/* Function Definitions */
static void brute_force_validation_once(void)
{
  mex_InitInfAndNan();
}

void brute_force_validation_initialize(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtLicenseCheckR2022a(&st, "EMLRT:runTime:MexFunctionNeedsLicense",
                          "optimization_toolbox", 2);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    brute_force_validation_once();
  }
}

/* End of code generation (brute_force_validation_initialize.c) */
