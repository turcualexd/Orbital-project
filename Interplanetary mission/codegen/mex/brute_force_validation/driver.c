/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * driver.c
 *
 * Code generation for function 'driver'
 *
 */

/* Include files */
#include "driver.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
real_T computeFirstOrderOpt(real_T gradf,
                            const real_T *projSteepestDescentInfNorm)
{
  real_T absx;
  real_T b;
  real_T firstOrderOpt;
  b = 0.0;
  absx = muDoubleScalarAbs(gradf);
  if (muDoubleScalarIsNaN(absx) || (absx > 0.0)) {
    b = absx;
  }
  if ((muDoubleScalarAbs(*projSteepestDescentInfNorm - b) <
       2.2204460492503131E-16 *
           muDoubleScalarMax(*projSteepestDescentInfNorm, b)) ||
      (b == 0.0)) {
    firstOrderOpt = *projSteepestDescentInfNorm;
  } else {
    firstOrderOpt =
        *projSteepestDescentInfNorm * *projSteepestDescentInfNorm / b;
  }
  return firstOrderOpt;
}

/* End of code generation (driver.c) */
