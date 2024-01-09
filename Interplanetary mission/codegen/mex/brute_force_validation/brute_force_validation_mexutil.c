/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * brute_force_validation_mexutil.c
 *
 * Code generation for function 'brute_force_validation_mexutil'
 *
 */

/* Include files */
#include "brute_force_validation_mexutil.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_error(const emlrtStack *sp, const mxArray *m, const mxArray *m1,
             emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = m;
  pArrays[1] = m1;
  emlrtCallMATLABR2012b((emlrtConstCTX)sp, 0, NULL, 2, &pArrays[0], "error",
                        true, location);
}

/* End of code generation (brute_force_validation_mexutil.c) */
