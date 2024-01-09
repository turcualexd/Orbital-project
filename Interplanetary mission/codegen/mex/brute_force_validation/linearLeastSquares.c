/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * linearLeastSquares.c
 *
 * Code generation for function 'linearLeastSquares'
 *
 */

/* Include files */
#include "linearLeastSquares.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
real_T linearLeastSquares(real_T lhs[2], real_T rhs[2])
{
  real_T beta1;
  real_T tau;
  int32_T i;
  int32_T k;
  tau = 0.0;
  for (i = 0; i < 1; i++) {
    real_T atmp;
    real_T d;
    atmp = lhs[0];
    tau = 0.0;
    d = lhs[1];
    beta1 = muDoubleScalarAbs(d);
    if (beta1 != 0.0) {
      beta1 = muDoubleScalarHypot(atmp, beta1);
      if (atmp >= 0.0) {
        beta1 = -beta1;
      }
      if (muDoubleScalarAbs(beta1) < 1.0020841800044864E-292) {
        int32_T knt;
        knt = 0;
        do {
          knt++;
          lhs[1] *= 9.9792015476736E+291;
          beta1 *= 9.9792015476736E+291;
          atmp *= 9.9792015476736E+291;
        } while ((muDoubleScalarAbs(beta1) < 1.0020841800044864E-292) &&
                 (knt < 20));
        d = lhs[1];
        beta1 = muDoubleScalarHypot(atmp, muDoubleScalarAbs(d));
        if (atmp >= 0.0) {
          beta1 = -beta1;
        }
        tau = (beta1 - atmp) / beta1;
        lhs[1] = 1.0 / (atmp - beta1) * d;
        for (k = 0; k < knt; k++) {
          beta1 *= 1.0020841800044864E-292;
        }
        atmp = beta1;
      } else {
        tau = (beta1 - atmp) / beta1;
        lhs[1] = 1.0 / (atmp - beta1) * d;
        atmp = beta1;
      }
    }
    lhs[0] = atmp;
  }
  if (tau != 0.0) {
    beta1 = tau * (rhs[0] + lhs[1] * 0.0);
    if (beta1 != 0.0) {
      rhs[0] -= beta1;
      rhs[1] = 0.0 - lhs[1] * beta1;
    }
  }
  return rhs[0] / lhs[0];
}

/* End of code generation (linearLeastSquares.c) */
