/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * kep2car.h
 *
 * Code generation for function 'kep2car'
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
void kep2car(const emlrtStack *sp, real_T a, real_T e, real_T i, real_T OM,
             real_T om, real_T th, real_T rr[3], real_T vv[3]);

/* End of code generation (kep2car.h) */
