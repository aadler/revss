!-------------------------------------------------------------------------------
!
! MODULE: Quicksort
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

module quicksort
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
    implicit none
    private
    public         :: median_f

contains

    recursive subroutine QS(v, l, r)
    real(kind = c_double), intent(inout)                   :: v(:)
    integer(kind = c_int), intent(in)                      :: l, r
    integer(kind = c_int)                                  :: i, j
    real(kind = c_double)                                  :: tmp, pivot

        if (l >= r) return

        pivot = v((l + r) / 2)
        i = l
        j = r

        do
            do while (v(i) < pivot)
                i = i + 1
            end do

            do while (v(j) > pivot)
                j = j - 1
            end do

            if (i <= j) then
                tmp = v(i)
                v(i) = v(j)
                v(j) = tmp
                i = i + 1
                j = j - 1
            end if

            if (i > j) exit
        end do

        call QS(v, l, j)
        call QS(v, i, r)

    end subroutine QS

    subroutine median_f(x, nx, ret) bind(C, name="median_f_")

    integer(kind = c_int), intent(in), value :: nx
    real(kind = c_double), intent(inout)     :: x(nx)
    real(kind = c_double), intent(out)       :: ret

        call QS(x, 1, nx)
        ret = x(nx / 2 + 1)
        if (mod(nx, 2) == 0) then
            ret = (ret + x(nx / 2)) / 2._c_double
        end if

    end subroutine median_f

end module quicksort
