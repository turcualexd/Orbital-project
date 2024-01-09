/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkStoppingCriteria.h
 *
 * Code generation for function 'checkStoppingCriteria'
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
int32_T checkStoppingCriteria(real_T gradf, real_T relFactor, real_T funDiff,
                              real_T x, real_T dx, int32_T funcCount,
                              boolean_T stepSuccessful, int32_T *iter,
                              real_T projSteepestDescentInfNorm);

/* End of code generation (checkStoppingCriteria.h) */
