/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * cost_sum_bb_emxutil.h
 *
 * Code generation for function 'cost_sum_bb_emxutil'
 *
 */

#pragma once

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "cost_sum_bb_types.h"

/* Function Declarations */
void emxEnsureCapacity_real_T(const emlrtStack *sp, emxArray_real_T *emxArray,
  int32_T oldNumel, const emlrtRTEInfo *srcLocation);
void emxFree_real_T(emxArray_real_T **pEmxArray);
void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray, int32_T
                    numDimensions, const emlrtRTEInfo *srcLocation, boolean_T
                    doPush);

/* End of code generation (cost_sum_bb_emxutil.h) */
