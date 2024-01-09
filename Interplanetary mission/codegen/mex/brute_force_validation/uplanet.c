/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * uplanet.c
 *
 * Code generation for function 'uplanet'
 *
 */

/* Include files */
#include "uplanet.h"
#include "brute_force_validation_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include <emmintrin.h>

/* Variable Definitions */
static emlrtRSInfo n_emlrtRSI = {
    226,       /* lineNo */
    "uplanet", /* fcnName */
    "C:\\Users\\turcu\\Desktop\\Progetti\\Orbital-project\\MATLAB "
    "functions\\uplanet.m" /* pathName */
};

/* Function Definitions */
void uplanet(const emlrtStack *sp, real_T mjd2000, real_T ibody, real_T kep[6])
{
  __m128d r;
  __m128d r1;
  emlrtStack st;
  real_T T;
  real_T TT;
  real_T TTT;
  int32_T i;
  st.prev = sp;
  st.tls = sp->tls;
  /*  uplanet.m - Analytical ephemerides for planets */
  /*  */
  /*  PROTOTYPE: */
  /*   [kep, ksun] = uplanet (mjd2000, ibody); */
  /*  */
  /*  DESCRIPTION: */
  /*    Planetary orbital elements are restituited in a Sun-centred ecliptic  */
  /*    system. */
  /*    These ephemerides were succesfully compared with JPL/NAIF/SPICE */
  /*    ephemerides using de405.bps. */
  /*  */
  /*   INPUT : */
  /* 	mjd2000[1]  Time, modified Julian day since 01/01/2000, 12:00 noon */
  /*                (MJD2000 = MJD-51544.5) */
  /* 	ibody[1]    Integer number identifying the celestial body (< 11) */
  /*                    1:   Mercury */
  /*                    2:   Venus */
  /*                    3:   Earth */
  /*                    4:   Mars */
  /*                    5:   Jupiter */
  /*                    6:   Saturn */
  /*                    7:   Uranus */
  /*                    8:   Neptune */
  /*                    9:   Pluto */
  /*                    10:  Sun */
  /*  */
  /*   OUTPUT: */
  /* 	kep[6]    	Mean Keplerian elements of date */
  /*                  kep = [a e i Om om theta] [km, rad] */
  /* 	ksun[1]     Gravity constant of the Sun [km^3/s^2] */
  /*  */
  /*    Note: The ephemerides of the Moon are given by EphSS_kep, according to
   */
  /*            to the algorithm in ephMoon.m */
  /*  */
  /*   FUNCTIONS CALLED: */
  /*    (none) */
  /*  */
  /*  AUTHOR: */
  /*    P. Dysli, 1977 */
  /*  */
  /*  PREVIOUS VERSION: */
  /*    P. Dysli, 1977, MATLAB, uplanet.m */
  /*        - Header and function name in accordance with guidlines. */
  /*  */
  /*   CHANGELOG: */
  /*    28/12/06, Camilla Colombo: tidied up */
  /*    10/01/2007, REVISION, Matteo Ceriotti  */
  /*    03/05/2008, Camilla Colombo: Case 11 deleted. */
  /*    11/09/2008, Matteo Ceriotti, Camilla Colombo: */
  /*        - All ephemerides shifted 0.5 days back in time. Now mjd2000 used */
  /*            in this function is referred to 01/01/2000 12:00. In the old */
  /*            version it was referred to 02/01/2000 00:00. */
  /*        - Corrected ephemeris of Pluto. */
  /*    04/10/2010, Camilla Colombo: Header and function name in accordance */
  /*        with guidlines. */
  /*  */
  /*  -------------------------------------------------------------------------
   */
  /*   T = JULIAN CENTURIES SINCE 31/12/1899 at 12:00 */
  T = (mjd2000 + 36525.0) / 36525.0;
  TT = T * T;
  TTT = T * TT;
  /*  */
  /*   CLASSICAL PLANETARY ELEMENTS ESTIMATION IN MEAN ECLIPTIC OF DATE */
  /*  */
  if ((int32_T)ibody == 3) {
    kep[0] = 1.00000023;
    kep[1] = (0.01675104 - 4.18E-5 * T) - 1.26E-7 * TT;
    kep[2] = 0.0;
    kep[3] = 0.0;
    kep[4] =
        ((1.719175 * T + 101.22083333333333) + 0.0004527777777777778 * TT) +
        3.3333333333333333E-6 * TTT;
    kep[5] = ((35999.04975 - 0.00015027777777777777 * T) -
              3.3333333333333333E-6 * TT) *
                 T +
             358.47584444444442;
    /*  */
    /*   MARS */
    /*  */
  } else {
    kep[0] = 1.523688399;
    kep[1] = (9.2064E-5 * T + 0.0933129) - 7.7E-8 * TT;
    kep[2] = (1.8503333333333334 - 0.000675 * T) + 1.2611111111111111E-5 * TT;
    kep[3] = ((0.77099166666666663 * T + 48.786441666666668) -
              1.388888888888889E-6 * TT) -
             5.3333333333333337E-6 * TTT;
    kep[4] = ((1.0697666666666668 * T + 285.43176111111109) + 0.00013125 * TT) +
             4.1388888888888889E-6 * TTT;
    kep[5] = ((0.00018080555555555555 * T + 19139.8585) +
              1.1944444444444443E-6 * TT) *
                 T +
             319.529425;
    /*  */
    /*   JUPITER */
    /*  */
  }
  /*  */
  /*   CONVERSION OF AU INTO KM, DEG INTO RAD AND DEFINITION OF  XMU */
  /*  */
  kep[0] *= 1.4959787066E+8;
  /*  a [km] */
  r = _mm_loadu_pd(&kep[2]);
  r1 = _mm_set1_pd(0.017453292519943295);
  _mm_storeu_pd(&kep[2], _mm_mul_pd(r, r1));
  r = _mm_loadu_pd(&kep[4]);
  _mm_storeu_pd(&kep[4], _mm_mul_pd(r, r1));
  /*  Transform from deg to rad */
  if (muDoubleScalarIsNaN(kep[5])) {
    TT = rtNaN;
  } else if (kep[5] == 0.0) {
    TT = 0.0;
  } else {
    boolean_T rEQ0;
    TT = muDoubleScalarRem(kep[5], 6.2831853071795862);
    rEQ0 = (TT == 0.0);
    if (!rEQ0) {
      T = muDoubleScalarAbs(kep[5] / 6.2831853071795862);
      rEQ0 = !(muDoubleScalarAbs(T - muDoubleScalarFloor(T + 0.5)) >
               2.2204460492503131E-16 * T);
    }
    if (rEQ0) {
      TT = 0.0;
    } else if (kep[5] < 0.0) {
      TT += 6.2831853071795862;
    }
  }
  /*  XMU  = (XM*DEG2RAD/(864000*365250))^2*kep(1)^3; */
  TTT = TT;
  /*  phi is the eccentric anomaly, uses kep(6)=M as a first guess */
  T = kep[1];
  for (i = 0; i < 5; i++) {
    TTT -= (TT - (TTT - T * muDoubleScalarSin(TTT))) /
           (T * muDoubleScalarCos(TTT) - 1.0);
    /*  Computes the eccentric anomaly kep */
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
  st.site = &n_emlrtRSI;
  T = (kep[1] + 1.0) / (1.0 - kep[1]);
  if (T < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &b_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  T = muDoubleScalarSqrt(T);
  kep[5] = 2.0 * muDoubleScalarAtan(T * muDoubleScalarTan(TTT / 2.0));
}

/* End of code generation (uplanet.c) */
