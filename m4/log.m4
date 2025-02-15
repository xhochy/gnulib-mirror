# log.m4
# serial 14
dnl Copyright (C) 2011-2025 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.
dnl This file is offered as-is, without any warranty.

AC_DEFUN([gl_FUNC_LOG],
[
  m4_divert_text([DEFAULTS], [gl_log_required=plain])
  AC_REQUIRE([gl_MATH_H_DEFAULTS])

  dnl Determine LOG_LIBM.
  gl_COMMON_DOUBLE_MATHFUNC([log])

  saved_LIBS="$LIBS"
  LIBS="$LIBS $LOG_LIBM"
  gl_FUNC_LOG_WORKS
  LIBS="$saved_LIBS"
  case "$gl_cv_func_log_works" in
    *yes) ;;
    *) REPLACE_LOG=1 ;;
  esac

  m4_ifdef([gl_FUNC_LOG_IEEE], [
    if test $gl_log_required = ieee && test $REPLACE_LOG = 0; then
      AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
      AC_CACHE_CHECK([whether log works according to ISO C 99 with IEC 60559],
        [gl_cv_func_log_ieee],
        [
          saved_LIBS="$LIBS"
          LIBS="$LIBS $LOG_LIBM"
          AC_RUN_IFELSE(
            [AC_LANG_SOURCE([[
#ifndef __NO_MATH_INLINES
# define __NO_MATH_INLINES 1 /* for glibc */
#endif
#include <math.h>
/* Compare two numbers with ==.
   This is a separate function because IRIX 6.5 "cc -O" miscompiles an
   'x == x' test.  */
static int
numeric_equal (double x, double y)
{
  return x == y;
}
static double dummy (double x) { return 0; }
int main (int argc, char *argv[])
{
  double (* volatile my_log) (double) = argc ? log : dummy;
  /* Test log(negative).
     This test fails on NetBSD 5.1, Solaris 11.4.  */
  double y = my_log (-1.0);
  if (numeric_equal (y, y))
    return 1;
  return 0;
}
            ]])],
            [gl_cv_func_log_ieee=yes],
            [gl_cv_func_log_ieee=no],
            [case "$host_os" in
                                   # Guess yes on glibc systems.
               *-gnu* | gnu*)      gl_cv_func_log_ieee="guessing yes" ;;
                                   # Guess yes on musl systems.
               *-musl* | midipix*) gl_cv_func_log_ieee="guessing yes" ;;
                                   # Guess yes on native Windows.
               mingw* | windows*)  gl_cv_func_log_ieee="guessing yes" ;;
                                   # If we don't know, obey --enable-cross-guesses.
               *)                  gl_cv_func_log_ieee="$gl_cross_guess_normal" ;;
             esac
            ])
          LIBS="$saved_LIBS"
        ])
      case "$gl_cv_func_log_ieee" in
        *yes) ;;
        *) REPLACE_LOG=1 ;;
      esac
    fi
  ])
])

dnl Test whether log() works.
dnl On OSF/1 5.1, log(-0.0) is NaN.
AC_DEFUN([gl_FUNC_LOG_WORKS],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST]) dnl for cross-compiles
  AC_CACHE_CHECK([whether log works], [gl_cv_func_log_works],
    [
      AC_RUN_IFELSE(
        [AC_LANG_SOURCE([[
#include <math.h>
volatile double x;
double y;
int main ()
{
  x = -0.0;
  y = log (x);
  if (!(y + y == y))
    return 1;
  return 0;
}
]])],
        [gl_cv_func_log_works=yes],
        [gl_cv_func_log_works=no],
        [case "$host_os" in
           osf*)              gl_cv_func_log_works="guessing no" ;;
                              # Guess yes on native Windows.
           mingw* | windows*) gl_cv_func_log_works="guessing yes" ;;
           *)                 gl_cv_func_log_works="guessing yes" ;;
         esac
        ])
    ])
])
