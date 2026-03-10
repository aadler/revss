!-------------------------------------------------------------------------------
!
! MODULE: Sorting
!
! AUTHOR: Avraham Adler <Avraham.Adler@gmail.com>
!
! DESCRIPTION: Stripped down fast median for doubles-only based on quicksort
!
! HISTORY:
!          Version 1.0: 2026-01-11
!                       Initial Commit
!          Version 2.0: 2026-01-20
!                       After research, rewrite simple quicksort to use an
!                       insertion sort for length <= 16 and recurse on the
!                       smaller piece first.
!                       Make this module purely for sorting and move median to
!                       the calculation module.
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

module sorting
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env

    implicit none
    private
    public         :: OQS

    integer(kind = c_int), parameter                       :: shortV = 16_c_int

contains

!-------------------------------------------------------------------------------
! SUBROUTINE: NBIS (No-Branch Insertion Sort)
!
! DESCRIPTION: Insertion Sort for small vectors (length <= 16)
!              Branchless. Interestingly, the extra call saves time because
!              merge can be implemented much more efficiently than the branching
!              on v(j) > test. Testing shows almost no difference between this
!              and a version which uses sentinals, cycles, and exits.
!-------------------------------------------------------------------------------

    pure subroutine NBIS(v, l, r)
    real(kind = c_double), intent(inout)                   :: v(:)
    integer(kind = c_int), intent(in)                      :: l, r
    integer(kind = c_int)                                  :: i, j
    real(kind = c_double)                                  :: test, tmp

        do i = l + 1, r
            test = v(i)
            j = i - 1
            do while (j >= l)
                tmp = v(j)
                v(j + 1) = merge(tmp, test, tmp > test)
                test = merge(test, tmp, tmp > test)
                j = j - 1
            end do
            v(l) = test
        end do

    end subroutine NBIS

!-------------------------------------------------------------------------------
! SUBROUTINE: OQS
!
! DESCRIPTION: Semi-Optimized Quicksort. Uses branchless insertion sort for 16
!              or fewer elements and uses median-of-three to select pivot.
!              Three-way Dutch Partitioning did not help even in the presence
!              of duplicates for reasonable sized inputs.
!-------------------------------------------------------------------------------

    pure recursive subroutine OQS(v, l, r)
    real(kind = c_double), intent(inout)                   :: v(:)
    integer(kind = c_int), intent(in)                      :: l, r
    integer(kind = c_int)                                  :: i, j, mid
    real(kind = c_double)                                  :: pivot, tmp

        if ((r - l) <= shortV) then
            call NBIS(v, l, r)
            return
        end if

        ! Median-of-three with inlined swaps
        mid = (l + r) / 2
        if (v(l) > v(mid)) then
            tmp = v(l)
            v(l) = v(mid)
            v(mid) = tmp
        end if
        if (v(mid) > v(r)) then
            tmp = v(mid)
            v(mid) = v(r)
            v(r) = tmp
        end if
        if (v(l) > v(mid)) then
            tmp = v(l)
            v(l) = v(mid)
            v(mid) = tmp
        end if

        pivot = v(mid)
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

        ! Recurse on smaller piece first to prevent stack explosion. Also put
        ! the check for length-one arrays BEFORE the call instead of returning
        ! inside.

        if ((j - l) < (r - i)) then
            if (l < j) call OQS(v, l, j)
            if (i < r) call OQS(v, i, r)
        else
            if (i < r) call OQS(v, i, r)
            if (l < j) call OQS(v, l, j)
        end if

    end subroutine OQS

end module sorting ! # nocov covr often misses the last line, apparently.
