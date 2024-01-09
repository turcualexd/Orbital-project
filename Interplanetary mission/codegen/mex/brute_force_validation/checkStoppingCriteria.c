/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkStoppingCriteria.c
 *
 * Code generation for function 'checkStoppingCriteria'
 *
 */

/* Include files */
#include "checkStoppingCriteria.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
int32_T checkStoppingCriteria(real_T gradf, real_T relFactor, real_T funDiff,
                              real_T x, real_T dx, int32_T funcCount,
                              boolean_T stepSuccessful, int32_T *iter,
                              real_T projSteepestDescentInfNorm)
{
  real_T absx;
  real_T normGradF;
  int32_T exitflag;
  normGradF = 0.0;
  absx = muDoubleScalarAbs(gradf);
  if (muDoubleScalarIsNaN(absx) || (absx > 0.0)) {
    normGradF = absx;
  }
  if (projSteepestDescentInfNorm * projSteepestDescentInfNorm <=
      1.0E-10 * normGradF * relFactor) {
    exitflag = 1;
  } else if (funcCount >= 200) {
    exitflag = 0;
  } else if (*iter >= 400) {
    exitflag = 0;
  } else if (muDoubleScalarAbs(dx) <
             1.0E-6 * (muDoubleScalarAbs(x) + 1.4901161193847656E-8)) {
    exitflag = 4;
    if (!stepSuccessful) {
      (*iter)++;
    }
  } else if (funDiff <= 1.0E-6) {
    exitflag = 3;
  } else {
    exitflag = -5;
  }
  return exitflag;
}

/* End of code generation (checkStoppingCriteria.c) */
