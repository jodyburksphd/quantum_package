program cisd
  implicit none
  integer                        :: i,k

  
  double precision, allocatable  :: pt2(:), norm_pert(:), H_pert_diag(:)
  integer                        :: N_st, degree
  N_st = N_states
  allocate (pt2(N_st), norm_pert(N_st),H_pert_diag(N_st))
  character*(64)                 :: perturbation
  
  pt2 = 1.d0
  diag_algorithm = "Lapack"
! do while (maxval(abs(pt2(1:N_st))) > 1.d-4)
  do while (N_det < n_det_max_fci.and.maxval(abs(pt2(1:N_st))) > 1.d-4)
    call H_apply_FCI(pt2, norm_pert, H_pert_diag,  N_st)
    call diagonalize_CI
    call save_wavefunction
    print *,  'N_det    = ', N_det
    print *,  'N_states = ', N_states
    print *,  'PT2      = ', pt2
    print *,  'E        = ', CI_energy
    print *,  'E+PT2    = ', CI_energy+pt2
    print *,  '-----'
    if (abort_all) then
      exit
    endif
  enddo
   N_det = min(n_det_max_fci,N_det)
   if(do_pt2_end)then
    threshold_selectors = 1.d0
    threshold_generators = 0.999d0
    touch N_det psi_det psi_coef
    call diagonalize_CI
    call H_apply_FCI_PT2(pt2, norm_pert, H_pert_diag,  N_st)
 
    print *,  'Final step'
!!  call remove_small_contributions
!!  call diagonalize_CI
    print *,  'N_det    = ', N_det
    print *,  'N_states = ', N_states
    print *,  'PT2      = ', pt2
    print *,  'E        = ', CI_energy
    print *,  'E+PT2    = ', CI_energy+pt2
    print *,  '-----'
   endif
  deallocate(pt2,norm_pert)
end
