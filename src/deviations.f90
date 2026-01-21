!-------------------------------------------------------------------------------
!
! MODULE: deviations
!
! AUTHOR: Avraham Adler <Avraham.Adler@gmail.com>
!
! DESCRIPTION: Calculations for adm/n and madn
!
! HISTORY:
!          Version 1.0: 2026-01-11
!                       Ported from C
!          Version 2.0: 2026-01-20
!                       Move median here and clean up code a bit
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

module deviations
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
    use sorting

    implicit none
    private
    public         :: median_f, adm_f, mad_f

contains

!-------------------------------------------------------------------------------
! SUBROUTINE: median_f
!
! DESCRIPTION: Find the median of a 1-D vector
!-------------------------------------------------------------------------------

    pure subroutine median_f(x, nx, ret) bind(C, name="median_f_")

    integer(kind = c_int), intent(in), value :: nx
    real(kind = c_double), intent(inout)     :: x(nx)
    real(kind = c_double), intent(out)       :: ret

        call OQS(x, 1, nx)
        ret = x(nx / 2 + 1)
        if (mod(nx, 2) == 0) then
            ret = (ret + x(nx / 2)) / 2._c_double
        end if

    end subroutine median_f

!-------------------------------------------------------------------------------
! SUBROUTINE: adm_f
!
! DESCRIPTION: Mean Absolute Deviation from Center
!-------------------------------------------------------------------------------

    pure subroutine adm_f(x, nx, ct, co, ret) bind(C, name="adm_f_")

    integer(kind = c_int), intent(in), value :: nx
    real(kind = c_double), intent(in)        :: x(nx), ct, co
    real(kind = c_double), intent(out)       :: ret

        ret = co * sum(abs(x - ct)) / real(nx, c_double)

    end subroutine adm_f

!-------------------------------------------------------------------------------
! SUBROUTINE: mad_f
!
! DESCRIPTION: Median Absolute Deviation from Center
!-------------------------------------------------------------------------------

    pure subroutine mad_f(x, nx, ct, co, ret) bind(C, name="mad_f_")

    integer(kind = c_int), intent(in), value :: nx
    real(kind = c_double), intent(in)        :: x(nx), ct, co
    real(kind = c_double), intent(out)       :: ret
    real(kind = c_double)                    :: v(nx)

        v = abs(x - ct)
        call median_f(v, nx, ret)
        ret = co * ret

    end subroutine mad_f

end module deviations ! # nocov covr often misses the last line, apparently.
