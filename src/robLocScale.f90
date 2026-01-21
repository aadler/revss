!-------------------------------------------------------------------------------
!
! MODULE: robLocScale
!
! AUTHOR: Avraham Adler <Avraham.Adler@gmail.com>
!
! DESCRIPTION: Calculation engine for the revss package
!
! HISTORY:
!          Version 1.0: 2026-01-07
!                       Ported from C
! LICENSE:
!   Copyright (c) 2026, Avraham Adler
!   All rights reserved.
!
!   Redistribution and use in source and binary forms, with or without
!   modification, are permitted provided that the following conditions are met:
!       1. Redistributions of source code must retain the above copyright
!          notice, this list of conditions and the following disclaimer.
!       2. Redistributions in binary form must reproduce the above copyright
!          notice, this list of conditions and the following disclaimer in the
!          documentation and/or other materials provided with the distribution.
!
!   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
!   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
!   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
!   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
!   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
!   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
!   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
!   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
!   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
!   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
!   POSSIBILITY OF SUCH DAMAGE.
!-------------------------------------------------------------------------------

module robLocScale
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
    implicit none
    private
    public         :: robLoc_f, robScale_f

    real(kind = c_double), parameter :: HALF = 0.5_c_double
    real(kind = c_double), parameter :: ZERO = 0._c_double
    real(kind = c_double), parameter :: ONE = 1._c_double
    real(kind = c_double), parameter :: TWO = 2._c_double
    real(kind = c_double), parameter :: FORTY = 40._c_double

contains

!-------------------------------------------------------------------------------
! FUNCTION: psi
!
! DESCRIPTION: Psi function of Rousseeuw & Verboven (2002)
!-------------------------------------------------------------------------------

    pure elemental function psi(x) result(y)

    real(kind = c_double), intent(in)                   :: x
    real(kind = c_double)                               :: y

        y = tanh(x * HALF)

    end function psi

!-------------------------------------------------------------------------------
! SUBROUTINE: robLoc_f
!
! DESCRIPTION: Calculation for robust location of Rousseeuw & Verboven (2002)
!-------------------------------------------------------------------------------

    pure subroutine robLoc_f(x, nx, t, s, maxit, tol, ret) &
                    bind(C, name="robLoc_f_")

    integer(kind = c_int), intent(in), value :: nx
    real(kind = c_double), intent(in)        :: x(nx), s, tol
    integer(kind = c_int), intent(in)        :: maxit
    real(kind = c_double), intent(inout)     :: t
    real(kind = c_double), intent(out)       :: ret
    real(kind = c_double), parameter         :: bt = 0.413241928283814_c_double
    real(kind = c_double)                    :: v, nxr, recips, a
    integer                                  :: i, k

        v = TWO * tol
        recips = ONE / s
        k = 0
        nxr = real(nx, c_double)

        do while (abs(v) > tol .and. k < maxit)
            k = k + 1
            a = ZERO

            do i = 1, nx
                a = a + psi((x(i) - t) * recips)
            end do

            v = (s * a) / (bt * nxr)
            t = t + v
        end do

        ret = t

    end subroutine robLoc_f

!-------------------------------------------------------------------------------
! SUBROUTINE: robScale_f
!
! DESCRIPTION: Calculation for robust scale of Rousseeuw & Verboven (2002)
!-------------------------------------------------------------------------------

    pure subroutine robScale_f(x, nx, t, s, maxit, tol, ret) &
                    bind(C, name="robScale_f_")

    integer(kind = c_int), intent(in), value:: nx
    real(kind = c_double), intent(in)       :: x(nx), t, tol
    integer(kind = c_int), intent(in)       :: maxit
    real(kind = c_double), intent(inout)    :: s
    real(kind = c_double), intent(out)      :: ret
    real(kind = c_double), parameter        :: bt = 0.37394112142347236_c_double
    real(kind = c_double)                   :: v, nxr, recipsbt, a, z
    integer                                 :: i, k

        v = TWO + tol
        k = 0
        nxr = real(nx, c_double)

        do while (abs(v - ONE) > tol .and. k < maxit)
            k = k + 1
            recipsbt = ONE / (s * bt)
            a = ZERO

            do i = 1, nx
                z = psi((x(i) - t) * recipsbt)
                a = a + z * z
            end do

            v = sqrt(TWO * a / nxr)
            s = s * v
        end do

        ret = s

    end subroutine robScale_f

end module robLocScale ! # nocov covr often misses the last line, apparently.
