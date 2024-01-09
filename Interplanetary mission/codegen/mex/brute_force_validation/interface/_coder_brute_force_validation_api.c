/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_brute_force_validation_api.c
 *
 * Code generation for function '_coder_brute_force_validation_api'
 *
 */

/* Include files */
#include "_coder_brute_force_validation_api.h"
#include "brute_force_validation.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static const mxArray *b_emlrt_marshallOut(const real_T u[6]);

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *nullptr,
                               const char_T *identifier);

static const mxArray *emlrt_marshallOut(const real_T u);

/* Function Definitions */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const real_T u[6])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 6};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *nullptr,
                               const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(nullptr), &thisId);
  emlrtDestroyArray(&nullptr);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m);
  return y;
}

void brute_force_validation_api(const mxArray *prhs, int32_T nlhs,
                                const mxArray *plhs[4])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T(*date_arr)[6];
  real_T(*date_dep)[6];
  real_T(*date_fb)[6];
  real_T dv_min;
  real_T n;
  st.tls = emlrtRootTLSGlobal;
  date_dep = (real_T(*)[6])mxMalloc(sizeof(real_T[6]));
  date_fb = (real_T(*)[6])mxMalloc(sizeof(real_T[6]));
  date_arr = (real_T(*)[6])mxMalloc(sizeof(real_T[6]));
  /* Marshall function inputs */
  n = emlrt_marshallIn(&st, emlrtAliasP(prhs), "n");
  /* Invoke the target function */
  brute_force_validation(&st, n, &dv_min, *date_dep, *date_fb, *date_arr);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(dv_min);
  if (nlhs > 1) {
    plhs[1] = b_emlrt_marshallOut(*date_dep);
  }
  if (nlhs > 2) {
    plhs[2] = b_emlrt_marshallOut(*date_fb);
  }
  if (nlhs > 3) {
    plhs[3] = b_emlrt_marshallOut(*date_arr);
  }
}

/* End of code generation (_coder_brute_force_validation_api.c) */
