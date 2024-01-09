/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * finDiffEvalAndChkErr.h
 *
 * Code generation for function 'finDiffEvalAndChkErr'
 *
 */

#pragma once

/* Include files */
#include "brute_force_validation_internal_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
boolean_T finDiffEvalAndChkErr(const emlrtStack *sp,
                               const struct_T c_obj_nonlin_workspace_fun_work,
                               const c_struct_T d_obj_nonlin_workspace_fun_work,
                               real_T e_obj_nonlin_workspace_fun_work,
                               real_T delta, const real_T *xk, real_T *fplus,
                               real_T *cEqPlus);

/* End of code generation (finDiffEvalAndChkErr.h) */
