/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * brute_force_validation_internal_types.h
 *
 * Code generation for function 'brute_force_validation'
 *
 */

#pragma once

/* Include files */
#include "brute_force_validation_types.h"
#include "rtwtypes.h"
#include "emlrt.h"

/* Type Definitions */
#ifndef typedef_struct_T
#define typedef_struct_T
typedef struct {
  real_T v_minus;
} struct_T;
#endif /* typedef_struct_T */

#ifndef typedef_anonymous_function
#define typedef_anonymous_function
typedef struct {
  struct_T workspace;
} anonymous_function;
#endif /* typedef_anonymous_function */

#ifndef typedef_b_struct_T
#define typedef_b_struct_T
typedef struct {
  anonymous_function e_m;
} b_struct_T;
#endif /* typedef_b_struct_T */

#ifndef typedef_b_anonymous_function
#define typedef_b_anonymous_function
typedef struct {
  b_struct_T workspace;
} b_anonymous_function;
#endif /* typedef_b_anonymous_function */

#ifndef typedef_c_struct_T
#define typedef_c_struct_T
typedef struct {
  real_T v_plus;
} c_struct_T;
#endif /* typedef_c_struct_T */

#ifndef typedef_c_anonymous_function
#define typedef_c_anonymous_function
typedef struct {
  c_struct_T workspace;
} c_anonymous_function;
#endif /* typedef_c_anonymous_function */

#ifndef typedef_d_struct_T
#define typedef_d_struct_T
typedef struct {
  c_anonymous_function e_p;
} d_struct_T;
#endif /* typedef_d_struct_T */

#ifndef typedef_d_anonymous_function
#define typedef_d_anonymous_function
typedef struct {
  d_struct_T workspace;
} d_anonymous_function;
#endif /* typedef_d_anonymous_function */

#ifndef typedef_e_struct_T
#define typedef_e_struct_T
typedef struct {
  b_anonymous_function delta_m;
  d_anonymous_function delta_p;
  real_T delta;
} e_struct_T;
#endif /* typedef_e_struct_T */

#ifndef typedef_e_anonymous_function
#define typedef_e_anonymous_function
typedef struct {
  e_struct_T workspace;
} e_anonymous_function;
#endif /* typedef_e_anonymous_function */

#ifndef typedef_f_struct_T
#define typedef_f_struct_T
typedef struct {
  e_anonymous_function Delta;
} f_struct_T;
#endif /* typedef_f_struct_T */

#ifndef typedef_f_anonymous_function
#define typedef_f_anonymous_function
typedef struct {
  f_struct_T workspace;
} f_anonymous_function;
#endif /* typedef_f_anonymous_function */

#ifndef typedef_g_struct_T
#define typedef_g_struct_T
typedef struct {
  f_anonymous_function fun;
} g_struct_T;
#endif /* typedef_g_struct_T */

#ifndef typedef_g_anonymous_function
#define typedef_g_anonymous_function
typedef struct {
  g_struct_T workspace;
} g_anonymous_function;
#endif /* typedef_g_anonymous_function */

#ifndef typedef_h_struct_T
#define typedef_h_struct_T
typedef struct {
  g_anonymous_function nonlin;
  real_T cEq_1;
  int32_T numEvals;
  boolean_T hasBounds;
} h_struct_T;
#endif /* typedef_h_struct_T */

#ifndef typedef_rtDesignRangeCheckInfo
#define typedef_rtDesignRangeCheckInfo
typedef struct {
  int32_T lineNo;
  int32_T colNo;
  const char_T *fName;
  const char_T *pName;
} rtDesignRangeCheckInfo;
#endif /* typedef_rtDesignRangeCheckInfo */

#ifndef typedef_rtDoubleCheckInfo
#define typedef_rtDoubleCheckInfo
typedef struct {
  int32_T lineNo;
  int32_T colNo;
  const char_T *fName;
  const char_T *pName;
  int32_T checkKind;
} rtDoubleCheckInfo;
#endif /* typedef_rtDoubleCheckInfo */

#ifndef typedef_rtEqualityCheckInfo
#define typedef_rtEqualityCheckInfo
typedef struct {
  int32_T nDims;
  int32_T lineNo;
  int32_T colNo;
  const char_T *fName;
  const char_T *pName;
} rtEqualityCheckInfo;
#endif /* typedef_rtEqualityCheckInfo */

#ifndef typedef_rtRunTimeErrorInfo
#define typedef_rtRunTimeErrorInfo
typedef struct {
  int32_T lineNo;
  int32_T colNo;
  const char_T *fName;
  const char_T *pName;
} rtRunTimeErrorInfo;
#endif /* typedef_rtRunTimeErrorInfo */

/* End of code generation (brute_force_validation_internal_types.h) */
