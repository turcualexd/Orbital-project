/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_brute_force_validation_mex.c
 *
 * Code generation for function '_coder_brute_force_validation_mex'
 *
 */

/* Include files */
#include "_coder_brute_force_validation_mex.h"
#include "_coder_brute_force_validation_api.h"
#include "brute_force_validation_data.h"
#include "brute_force_validation_initialize.h"
#include "brute_force_validation_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void brute_force_validation_mexFunction(int32_T nlhs, mxArray *plhs[4],
                                        int32_T nrhs, const mxArray *prhs[1])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[4];
  int32_T i;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        22, "brute_force_validation");
  }
  if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 22,
                        "brute_force_validation");
  }
  /* Call the function. */
  brute_force_validation_api(prhs[0], nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    i = 1;
  } else {
    i = nlhs;
  }
  emlrtReturnArrays(i, &plhs[0], &outputs[0]);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&brute_force_validation_atexit);
  /* Module initialization. */
  brute_force_validation_initialize();
  /* Dispatch the entry-point. */
  brute_force_validation_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  brute_force_validation_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_brute_force_validation_mex.c) */
