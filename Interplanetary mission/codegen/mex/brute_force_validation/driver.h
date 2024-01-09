/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * driver.h
 *
 * Code generation for function 'driver'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
real_T computeFirstOrderOpt(real_T gradf,
                            const real_T *projSteepestDescentInfNorm);

/* End of code generation (driver.h) */
