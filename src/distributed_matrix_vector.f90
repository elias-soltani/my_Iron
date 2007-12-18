!> \file
!> $Id: distributed_matrix_vector.f90 28 2007-07-27 08:35:14Z cpb $
!> \author Chris Bradley
!> \brief This module handles all distributed matrix vector routines.
!>
!> \section LICENSE
!>
!> Version: MPL 1.1/GPL 2.0/LGPL 2.1
!>
!> The contents of this file are subject to the Mozilla Public License
!> Version 1.1 (the "License"); you may not use this file except in
!> compliance with the License. You may obtain a copy of the License at
!> http://www.mozilla.org/MPL/
!>
!> Software distributed under the License is distributed on an "AS IS"
!> basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
!> License for the specific language governing rights and limitations
!> under the License.
!>
!> The Original Code is openCMISS
!>
!> The Initial Developer of the Original Code is University of Auckland,
!> Auckland, New Zealand and University of Oxford, Oxford, United
!> Kingdom. Portions created by the University of Auckland and University
!> of Oxford are Copyright (C) 2007 by the University of Auckland and
!> the University of Oxford. All Rights Reserved.
!>
!> Contributor(s):
!>
!> Alternatively, the contents of this file may be used under the terms of
!> either the GNU General Public License Version 2 or later (the "GPL"), or
!> the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
!> in which case the provisions of the GPL or the LGPL are applicable instead
!> of those above. If you wish to allow use of your version of this file only
!> under the terms of either the GPL or the LGPL, and not to allow others to
!> use your version of this file under the terms of the MPL, indicate your
!> decision by deleting the provisions above and replace them with the notice
!> and other provisions required by the GPL or the LGPL. If you do not delete
!> the provisions above, a recipient may use your version of this file under
!> the terms of any one of the MPL, the GPL or the LGPL.
!>

!> This module handles all distributed matrix vector routines.
MODULE DISTRIBUTED_MATRIX_VECTOR

  USE BASE_ROUTINES
  USE CMISS_MPI
  USE COMP_ENVIRONMENT
  USE INPUT_OUTPUT
  USE ISO_VARYING_STRING
  USE KINDS
  USE MATRIX_VECTOR
  USE MPI
  USE STRINGS
  USE TYPES

  IMPLICIT NONE

  PRIVATE

  !Module parameters

  !> \addtogroup DISTRIBUTED_MATRIX_VECTOR_DataTypes DISTRIBUTED_MATRIX_VECTOR::DataTypes
  !> \brief Distributed matrix-vector data types
  !> \see DISTRIBUTED_MATRIX_VECTOR
  !>@{
  INTEGER(INTG), PARAMETER :: DISTRIBUTED_MATRIX_VECTOR_INTG_TYPE=MATRIX_VECTOR_INTG_TYPE !<Integer distributed matrix-vector data type \see DISTRIBUTED_MATRIX_VECTOR_DataTypes,DISTRIBUTED_MATRIX_VECTOR
  INTEGER(INTG), PARAMETER :: DISTRIBUTED_MATRIX_VECTOR_SP_TYPE=MATRIX_VECTOR_SP_TYPE !<Single precision real distributed matrix-vector data type \see DISTRIBUTED_MATRIX_VECTOR_DataTypes,DISTRIBUTED_MATRIX_VECTOR
  INTEGER(INTG), PARAMETER :: DISTRIBUTED_MATRIX_VECTOR_DP_TYPE=MATRIX_VECTOR_DP_TYPE !<Double precision real distributed matrix-vector data type \see DISTRIBUTED_MATRIX_VECTOR_DataTypes,DISTRIBUTED_MATRIX_VECTOR
  INTEGER(INTG), PARAMETER :: DISTRIBUTED_MATRIX_VECTOR_L_TYPE=MATRIX_VECTOR_L_TYPE !<Logical distributed matrix-vector data type \see DISTRIBUTED_MATRIX_VECTOR_DataTypes,DISTRIBUTED_MATRIX_VECTOR
  !>@}
  
  !Module types

  !Module variables

  INTEGER(INTG), SAVE :: DISTRIBUTED_DATA_ID=100000000

  !Interfaces

  INTERFACE DISTRIBUTED_MATRIX_ALL_VALUES_SET
    MODULE PROCEDURE DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG
    MODULE PROCEDURE DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_ALL_VALUES_SET_L
  END INTERFACE !DISTRIBUTED_MATRIX_ALL_VALUES_SET

  INTERFACE DISTRIBUTED_MATRIX_DATA_GET
    MODULE PROCEDURE DISTRIBUTED_MATRIX_DATA_GET_INTG
    MODULE PROCEDURE DISTRIBUTED_MATRIX_DATA_GET_SP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_DATA_GET_DP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_DATA_GET_L
  END INTERFACE !DISTRIBUTED_MATRIX_DATA_GET

  INTERFACE DISTRIBUTED_MATRIX_VALUES_ADD
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_INTG
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_INTG1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_INTG2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_SP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_SP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_SP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_DP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_DP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_DP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_L
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_L1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_ADD_L2
  END INTERFACE !DISTRIBUTED_MATRIX_VALUES_ADD

  INTERFACE DISTRIBUTED_MATRIX_VALUES_GET
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_INTG
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_INTG1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_INTG2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_SP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_SP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_SP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_DP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_DP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_DP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_L
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_L1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_GET_L2
  END INTERFACE !DISTRIBUTED_MATRIX_VALUES_GET

  INTERFACE DISTRIBUTED_MATRIX_VALUES_SET
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_INTG
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_INTG1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_INTG2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_SP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_SP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_SP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_DP
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_DP1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_DP2
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_L
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_L1
    MODULE PROCEDURE DISTRIBUTED_MATRIX_VALUES_SET_L2
  END INTERFACE !DISTRIBUTED_MATRIX_VALUES_SET

  INTERFACE DISTRIBUTED_VECTOR_ALL_VALUES_SET
    MODULE PROCEDURE DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG
    MODULE PROCEDURE DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_ALL_VALUES_SET_L
  END INTERFACE !DISTRIBUTED_VECTOR_ALL_VALUES_SET

  INTERFACE DISTRIBUTED_VECTOR_DATA_GET
    MODULE PROCEDURE DISTRIBUTED_VECTOR_DATA_GET_INTG
    MODULE PROCEDURE DISTRIBUTED_VECTOR_DATA_GET_SP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_DATA_GET_DP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_DATA_GET_L
  END INTERFACE !DISTRIBUTED_VECTOR_DATA_GET

  INTERFACE DISTRIBUTED_VECTOR_VALUES_ADD
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_INTG
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_INTG1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_SP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_SP1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_DP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_DP1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_L
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_ADD_L1
  END INTERFACE !DISTRIBUTED_VECTOR_VALUES_ADD

  INTERFACE DISTRIBUTED_VECTOR_VALUES_SET
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_INTG
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_INTG1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_SP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_SP1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_DP
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_DP1
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_L
    MODULE PROCEDURE DISTRIBUTED_VECTOR_VALUES_SET_L1
  END INTERFACE !DISTRIBUTED_VECTOR_VALUES_SET

  PUBLIC DISTRIBUTED_MATRIX_ALL_VALUES_SET,DISTRIBUTED_MATRIX_CREATE_FINISH,DISTRIBUTED_MATRIX_CREATE_START, &
    & DISTRIBUTED_MATRIX_DATA_TYPE_SET,DISTRIBUTED_MATRIX_DESTROY,DISTRIBUTED_MATRIX_DUPLICATE, &
    & DISTRIBUTED_MATRIX_OUTPUT,DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET,DISTRIBUTED_MATRIX_STORAGE_TYPE_SET, &
    & DISTRIBUTED_MATRIX_UPDATE_START,DISTRIBUTED_MATRIX_UPDATE_FINISH,DISTRIBUTED_MATRIX_UPDATE_ISFINISHED, &
    & DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED,DISTRIBUTED_MATRIX_VALUES_ADD,DISTRIBUTED_MATRIX_VALUES_GET, &
    & DISTRIBUTED_MATRIX_VALUES_SET
  
  PUBLIC DISTRIBUTED_VECTOR_ALL_VALUES_SET,DISTRIBUTED_VECTOR_CREATE_FINISH,DISTRIBUTED_VECTOR_CREATE_START, &
    & DISTRIBUTED_VECTOR_DATA_GET,DISTRIBUTED_VECTOR_DATA_TYPE_SET,DISTRIBUTED_VECTOR_DESTROY,DISTRIBUTED_VECTOR_DUPLICATE, &
    & DISTRIBUTED_VECTOR_OUTPUT,DISTRIBUTED_VECTOR_VALUES_ADD,DISTRIBUTED_VECTOR_VALUES_SET,DISTRIBUTED_VECTOR_UPDATE_START, &
    & DISTRIBUTED_VECTOR_UPDATE_FINISH,DISTRIBUTED_VECTOR_UPDATE_ISFINISHED,DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED
  
CONTAINS  
  
  !
  !================================================================================================================================
  !

  !>Sets all values in an integer distributed matrix to the specified value.
  SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG(DISTRIBUTED_MATRIX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value to set 
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables

    CALL ENTERS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_ALL_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_INTG

  !
  !================================================================================================================================
  !

  !>Sets all values in a single precision distributed matrix to the specified value.
  SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP(DISTRIBUTED_MATRIX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    REAL(SP), INTENT(IN) :: VALUE !<The value to set 
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables

    CALL ENTERS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_ALL_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_SP

  !
  !================================================================================================================================
  !

  !>Sets all values in a double precision distributed matrix to the specified value.
  SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP(DISTRIBUTED_MATRIX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    REAL(DP), INTENT(IN) :: VALUE !<The value to set 
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables

    CALL ENTERS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_ALL_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_DP

  !
  !================================================================================================================================
  !

  !>Sets all values in a logical distributed matrix to the specified value.
  SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_L(DISTRIBUTED_MATRIX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    LOGICAL, INTENT(IN) :: VALUE !<The value to set 
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables

    CALL ENTERS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_ALL_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_ALL_VALUES_SET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_ALL_VALUES_SET_L

  !
  !================================================================================================================================
  !

  !>Finishes the creation of a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_CREATE_FINISH(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables 
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_CREATE_FINISH",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL FLAG_ERROR("The distributed matrix has been finished",ERR,ERROR,*999)
      ELSE
        DISTRIBUTED_MATRIX%BASE_TAG_NUMBER=DISTRIBUTED_DATA_ID
        IF(DISTRIBUTED_MATRIX%DOMAIN_MAPPING%NUMBER_OF_DOMAINS==1) THEN
          DISTRIBUTED_DATA_ID=DISTRIBUTED_DATA_ID+1
        ELSE
          DISTRIBUTED_DATA_ID=DISTRIBUTED_DATA_ID+DISTRIBUTED_MATRIX%DOMAIN_MAPPING%ADJACENT_DOMAINS_LIST(DISTRIBUTED_MATRIX% &
            & DOMAIN_MAPPING%NUMBER_OF_DOMAINS)-1
        ENDIF
        CALL MATRIX_CREATE_FINISH(DISTRIBUTED_MATRIX%MATRIX,ERR,ERROR,*999)
        DISTRIBUTED_MATRIX%MATRIX_FINISHED=.TRUE.
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_CREATE_FINISH")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_CREATE_FINISH",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_CREATE_FINISH")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_CREATE_FINISH

  !
  !================================================================================================================================
  !

  !>Starts the creation of a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_CREATE_START(DOMAIN_MAPPING,DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DOMAIN_MAPPING_TYPE), POINTER :: DOMAIN_MAPPING !<A pointer to the domain mapping to be used for the distribution
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<On return a pointer to the distributed matrix being created
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_CREATE_START",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      CALL FLAG_ERROR("Distributed matrix is already associated",ERR,ERROR,*999)
    ELSE
      IF(ASSOCIATED(DOMAIN_MAPPING)) THEN        
        ALLOCATE(DISTRIBUTED_MATRIX,STAT=ERR)
        IF(ERR/=0) CALL FLAG_ERROR("Could not allocated the distributed matrix",ERR,ERROR,*999)
        CALL DISTRIBUTED_MATRIX_INITIALISE(DISTRIBUTED_MATRIX,ERR,ERROR,*999)
        !Set the defaults
        DISTRIBUTED_MATRIX%DOMAIN_MAPPING=>DOMAIN_MAPPING
        CALL MATRIX_CREATE_START(DISTRIBUTED_MATRIX%MATRIX,ERR,ERROR,*999)
        CALL MATRIX_DATA_TYPE_SET(DISTRIBUTED_MATRIX%MATRIX,MATRIX_VECTOR_DP_TYPE,ERR,ERROR,*999)
        CALL MATRIX_STORAGE_TYPE_SET(DISTRIBUTED_MATRIX%MATRIX,MATRIX_BLOCK_STORAGE_TYPE,ERR,ERROR,*999)
        CALL MATRIX_SIZE_SET(DISTRIBUTED_MATRIX%MATRIX,DOMAIN_MAPPING%TOTAL_NUMBER_OF_LOCAL,DOMAIN_MAPPING%NUMBER_OF_GLOBAL, &
          & ERR,ERROR,*999)
       ELSE
        CALL FLAG_ERROR("Domain mapping is not associated",ERR,ERROR,*999)
      ENDIF
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_CREATE_START")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_CREATE_START",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_CREATE_START")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_CREATE_START

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of an integer distributed matrix. Note: the values can be used for read operations but a DISTRIBUTED_MATRIX_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_INTG(DISTRIBUTED_MATRIX,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), POINTER :: DATA(:) !<On return a pointer to the distributed matrix data for this computational node
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_MATRIX_DATA_GET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
          CALL MATRIX_DATA_GET(DISTRIBUTED_MATRIX%MATRIX,DATA,ERR,ERROR,*999)
        ELSE
          CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DATA_GET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_INTG

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of a single precision distributed matrix. Note: the values can be used for read operations but a DISTRIBUTED_MATRIX_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_SP(DISTRIBUTED_MATRIX,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    REAL(SP), POINTER :: DATA(:) !<On return a pointer to the distributed matrix data for this computational node
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_MATRIX_DATA_GET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
          CALL MATRIX_DATA_GET(DISTRIBUTED_MATRIX%MATRIX,DATA,ERR,ERROR,*999)
        ELSE
          CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DATA_GET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_SP

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of a double precision distributed matrix. Note: the values can be used for read operations but a DISTRIBUTED_MATRIX_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_DP(DISTRIBUTED_MATRIX,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    REAL(DP), POINTER :: DATA(:) !<On return a pointer to the distributed matrix data for this computational node
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_MATRIX_DATA_GET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
          CALL MATRIX_DATA_GET(DISTRIBUTED_MATRIX%MATRIX,DATA,ERR,ERROR,*999)
        ELSE
          CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DATA_GET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_DP

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of a logical distributed matrix. Note: the values can be used for read operations but a DISTRIBUTED_MATRIX_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_L(DISTRIBUTED_MATRIX,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    LOGICAL, POINTER :: DATA(:) !<On return a pointer to the distributed matrix data for this computational node
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
 
    CALL ENTERS("DISTRIBUTED_MATRIX_DATA_GET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
          CALL MATRIX_DATA_GET(DISTRIBUTED_MATRIX%MATRIX,DATA,ERR,ERROR,*999)
        ELSE
          CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DATA_GET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_GET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DATA_GET_L

  !
  !================================================================================================================================
  !

  !>Sets/changes the data type of a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_DATA_TYPE_SET(DISTRIBUTED_MATRIX,DATA_TYPE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: DATA_TYPE !<The data type to set. \see MATRIX_VECTOR_DataTypes,MATRIX_VECTOR
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_DATA_TYPE_SET",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL FLAG_ERROR("The distributed matrix has been finished",ERR,ERROR,*999)
      ELSE
        CALL MATRIX_DATA_TYPE_SET(DISTRIBUTED_MATRIX%MATRIX,DATA_TYPE,ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_TYPE_SET")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DATA_TYPE_SET",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DATA_TYPE_SET")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DATA_TYPE_SET

  !
  !================================================================================================================================
  !

  !>Destroys a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_DESTROY(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_MATRIX_DESTROY",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      CALL DISTRIBUTED_MATRIX_FINALISE(DISTRIBUTED_MATRIX,ERR,ERROR,*999)
    ELSE
      !??? Error?
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DESTROY")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_DESTROY",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DESTROY")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DESTROY

  !
  !================================================================================================================================
  !

  !>Duplicates the structure of a distributed matrix and returns a pointer to the new matrix in NEW_DISTRIBUTED_MATRIX.
  SUBROUTINE DISTRIBUTED_MATRIX_DUPLICATE(DISTRIBUTED_MATRIX,NEW_DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix to duplicate
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: NEW_DISTRIBUTED_MATRIX !<On return a pointer to the new duplicated distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: DUMMY_ERR
    TYPE(VARYING_STRING) :: DUMMY_ERROR

    CALL ENTERS("DISTRIBUTED_MATRIX_DUPLICATE",ERR,ERROR,*998)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(NEW_DISTRIBUTED_MATRIX)) THEN
        CALL FLAG_ERROR("New distributed matrix is already associated",ERR,ERROR,*998)
      ELSE
        CALL DISTRIBUTED_MATRIX_CREATE_START(DISTRIBUTED_MATRIX%DOMAIN_MAPPING,NEW_DISTRIBUTED_MATRIX,ERR,ERROR,*999)
        CALL MATRIX_DUPLICATE(DISTRIBUTED_MATRIX%MATRIX,NEW_DISTRIBUTED_MATRIX%MATRIX,ERR,ERROR,*999)
        CALL DISTRIBUTED_MATRIX_CREATE_FINISH(NEW_DISTRIBUTED_MATRIX,ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*998)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_DUPLICATE")
    RETURN
999 CALL DISTRIBUTED_MATRIX_FINALISE(NEW_DISTRIBUTED_MATRIX,DUMMY_ERR,DUMMY_ERROR,*999)
998 CALL ERRORS("DISTRIBUTED_MATRIX_DUPLICATE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_DUPLICATE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_DUPLICATE

  !
  !================================================================================================================================
  !

  !>Finalises a distributed matrix and deallocates all memory.
  SUBROUTINE DISTRIBUTED_MATRIX_FINALISE(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_MATRIX_FINALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(ASSOCIATED(DISTRIBUTED_MATRIX%MATRIX)) CALL MATRIX_DESTROY(DISTRIBUTED_MATRIX%MATRIX,ERR,ERROR,*999)
      DEALLOCATE(DISTRIBUTED_MATRIX)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_FINALISE")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_FINALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_FINALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_FINALISE

  !
  !================================================================================================================================
  !

  !>Intialises a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_INITIALISE(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_INITIALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      DISTRIBUTED_MATRIX%BASE_TAG_NUMBER=0
      DISTRIBUTED_MATRIX%MATRIX_FINISHED=.FALSE.
      NULLIFY(DISTRIBUTED_MATRIX%DOMAIN_MAPPING)
      NULLIFY(DISTRIBUTED_MATRIX%MATRIX)
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_INITIALSE")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_INITIALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_INITIALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_INITIALISE

  !
  !================================================================================================================================
  !

  !>Outputs a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_OUTPUT(ID,DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    INTEGER(INTG), INTENT(IN) :: ID !<The ID of the output stream
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_OUTPUT",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_OUTPUT(ID,DISTRIBUTED_MATRIX%MATRIX,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("Distributed matrix is not finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_OUTPUT")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_OUTPUT",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_OUTPUT")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_OUTPUT

  !
  !================================================================================================================================
  !

  !>Sets/changes the storage type of a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_STORAGE_TYPE_SET(DISTRIBUTED_MATRIX,STORAGE_TYPE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: STORAGE_TYPE !<The storage (sparsity) type to set. \see MATRIX_VECTOR_StorageTypes,MATRIX_VECTOR
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_STORAGE_TYPE_SET",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL FLAG_ERROR("The distributed matrix has been finished",ERR,ERROR,*999)
      ELSE
        CALL MATRIX_STORAGE_TYPE_SET(DISTRIBUTED_MATRIX%MATRIX,STORAGE_TYPE,ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_STORAGE_TYPE_SET")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_STORAGE_TYPE_SET",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_STORAGE_TYPE_SET")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_STORAGE_TYPE_SET

  !
  !================================================================================================================================
  !

  !>Sets the storage locations (sparsity pattern) in a distributed matrix to that specified by the row and column indices.
  SUBROUTINE DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index of the matrix storage locations
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index of the matrix storage locations
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL FLAG_ERROR("The distributed matrix has been finished",ERR,ERROR,*999)
      ELSE
        CALL MATRIX_STORAGE_LOCATIONS_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_STORAGE_LOCATIONS_SET

  !
  !================================================================================================================================
  !

  !>Finishes the update procedure for a distributed matrix. This routine will wait until all transfers have completed!
  SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_FINISH(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
   
    CALL ENTERS("DISTRIBUTED_MATRIX_UPDATE_FINISH",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        !Do nothing for now.
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_FINISH")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_UPDATE_FINISH",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_FINISH")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_FINISH

  !
  !================================================================================================================================
  !

  !>Tests to see if a distributed matrix update has finised.
  SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_ISFINISHED(DISTRIBUTED_MATRIX,ISFINISHED,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    LOGICAL, INTENT(OUT) :: ISFINISHED !<On return ISFINISHED will be .TRUE. if the distributed matrix update has finished or .FALSE. if it has not
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_UPDATE_ISFINISHED",ERR,ERROR,*999)

    ISFINISHED=.FALSE.
    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        !Do nothting for now.
        ISFINISHED=.TRUE.
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_ISFINISHED")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_UPDATE_ISFINISHED",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_ISFINISHED")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_ISFINISHED

  !
  !================================================================================================================================
  !

  !>Waits until a distributed matrix update has finised.
  SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        !Do nothing for now.
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_WAITFINISHED

  !
  !================================================================================================================================
  !

  !>Starts the update procedure for a distributed matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_START(DISTRIBUTED_MATRIX,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_UPDATE_START",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        !Do nothing for now.
     ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_START")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_UPDATE_START",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_UPDATE_START")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_UPDATE_START

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to add
    INTEGER(INTG), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to add a value to 
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to add a value to
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value to add at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG1

  !
  !================================================================================================================================
  !

  !>Adds a matrix of values to a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to add
    INTEGER(INTG), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_INTG2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_INTG2

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to add
    REAL(SP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
   
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to add a value to 
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to add a value to
    REAL(SP), INTENT(IN) :: VALUE !<The value to add at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_SP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_SP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP1

  !
  !================================================================================================================================
  !

  !>Adds a matrix of values to a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to add
    REAL(SP), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
   
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_SP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_SP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_SP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_SP2

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to add
    REAL(DP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to add a value to 
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to add a value to
    REAL(DP), INTENT(IN) :: VALUE !<The value to add at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_DP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_DP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP1

  !
  !================================================================================================================================
  !

  !>Adds a matrix of values to a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to add
    REAL(DP), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_DP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_DP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_DP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_DP2

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to add
    LOGICAL, INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to add a value to 
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to add a value to
    LOGICAL, INTENT(IN) :: VALUE !<The value to add at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_L1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_L1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L1

  !
  !================================================================================================================================
  !

  !>Adds a matrix of values to a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to add
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to add
    LOGICAL, INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_ADD_L2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_ADD(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_ADD_L2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_ADD_L2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_ADD_L2

  !
  !================================================================================================================================
  !

  !>Gets values in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to get
    INTEGER(INTG), INTENT(OUT) :: VALUES(:) !<VALUES(i). On return the i'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG

  !
  !================================================================================================================================
  !

  !>Gets one value in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to get a value from
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to get a value from
    INTEGER(INTG), INTENT(OUT) :: VALUE !<On return the value of the matrix at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_INTG1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_INTG1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG1

  !
  !================================================================================================================================
  !

  !>Gets a matrix of values in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to get
    INTEGER(INTG), INTENT(OUT) :: VALUES(:,:) !<VALUES(i,j). On return the ij'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_INTG2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_INTG2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_INTG2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_INTG2

  !
  !================================================================================================================================
  !

  !>Gets values in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<The row index to get a value from
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<The column index to get a value from
    REAL(SP), INTENT(OUT) :: VALUES(:) !<On return the value of the matrix at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP

  !
  !================================================================================================================================
  !

  !>Gets one value in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to get a value from
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to get a value from
    REAL(SP), INTENT(OUT) :: VALUE !<On return the value of the matrix at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_SP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_SP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP1

  !
  !================================================================================================================================
  !

  !>Gets a matrix of values in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to get
    REAL(SP), INTENT(OUT) :: VALUES(:,:) !<VALUES(i,j). On return the ij'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_SP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_SP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_SP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_SP2

  !
  !================================================================================================================================
  !

  !>Gets values in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to get
    REAL(DP), INTENT(OUT) :: VALUES(:) !<VALUES(i). On return the i'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP

  !
  !================================================================================================================================
  !

  !>Gets one value in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to get a value from
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to get a value from
    REAL(DP), INTENT(OUT) :: VALUE !<On return the value of the matrix at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_DP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_DP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP1

  !
  !
  !================================================================================================================================
  !

  !>Gets a matrix of values in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to get
    REAL(DP), INTENT(OUT) :: VALUES(:,:) !<VALUES(i,j). On return the ij'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_DP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_DP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_DP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_DP2

  !
  !================================================================================================================================
  !

  !>Gets values in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to get
    LOGICAL, INTENT(OUT) :: VALUES(:) !<VALUES(i). On return the i'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L

  !
  !================================================================================================================================
  !

  !>Gets one value in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to get a value from
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to get a value from
    LOGICAL, INTENT(OUT) :: VALUE !<On return the value of the matrix at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_L1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_L1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L1

  !
  !================================================================================================================================
  !

  !>Gets a matrix of values in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to get
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to get
    LOGICAL, INTENT(OUT) :: VALUES(:,:) !<VALUES(i,j). On return the ij'th value to get
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_GET_L2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_GET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_GET_L2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_GET_L2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_GET_L2

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to set
    INTEGER(INTG), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to set a value to
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to set a value to
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value of the matrix to be set at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_INTG1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_INTG1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG1

  !
  !================================================================================================================================
  !

  !>Sets a matrix of values in a distributed integer matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to set
    INTEGER(INTG), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_INTG2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_INTG2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_INTG2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_INTG2

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to set
    REAL(SP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to set a value to
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to set a value to
    REAL(SP), INTENT(IN) :: VALUE !<The value of the matrix to be set at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_SP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_SP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP1

  !
  !================================================================================================================================
  !

  !>Sets a matrix of values in a distributed single precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to set
    REAL(SP), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_SP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_SP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_SP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_SP2

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to set
    REAL(DP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to set a value to
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to set a value to
    REAL(DP), INTENT(IN) :: VALUE !<The value of the matrix to be set at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_DP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_DP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP1

  !
  !================================================================================================================================
  !

  !>Sets a matrix of values in a distributed double precision matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to set
    REAL(DP), INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_DP2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_DP2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_DP2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_DP2

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The i'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(i). The i'th column index to set
    LOGICAL, INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L1(DISTRIBUTED_MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDEX !<The row index to set a value to
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDEX !<The column index to set a value to
    LOGICAL, INTENT(IN) :: VALUE !<The value of the matrix to be set at the specified row and column
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_L1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDEX,COLUMN_INDEX,VALUE,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_L1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L1

  !
  !================================================================================================================================
  !

  !>Sets a matrix of values in a distributed logical matrix.
  SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L2(DISTRIBUTED_MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_MATRIX_TYPE), POINTER :: DISTRIBUTED_MATRIX !<A pointer to the distributed matrix
    INTEGER(INTG), INTENT(IN) :: ROW_INDICES(:) !<ROW_INDICES(i). The ij'th row index to set
    INTEGER(INTG), INTENT(IN) :: COLUMN_INDICES(:) !<COLUMN_INDICES(j). The ij'th column index to set
    LOGICAL, INTENT(IN) :: VALUES(:,:) !<VALUES(i,j). The ij'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_MATRIX_VALUES_SET_L2",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_MATRIX)) THEN
      IF(DISTRIBUTED_MATRIX%MATRIX_FINISHED) THEN
        CALL MATRIX_VALUES_SET(DISTRIBUTED_MATRIX%MATRIX,ROW_INDICES,COLUMN_INDICES,VALUES,ERR,ERROR,*999)
      ELSE
        CALL FLAG_ERROR("The distributed matrix has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed matrix is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L2")
    RETURN
999 CALL ERRORS("DISTRIBUTED_MATRIX_VALUES_SET_L2",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_MATRIX_VALUES_SET_L2")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_MATRIX_VALUES_SET_L2

  !
  !================================================================================================================================
  !

  !>Sets all values in an integer distributed vector to the specified value.
  SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG(DISTRIBUTED_VECTOR,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
          DISTRIBUTED_VECTOR%DATA_INTG=VALUE
        ELSE
          LOCAL_ERROR="The data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the integer data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_INTG

  !
  !================================================================================================================================
  !

  !>Sets all values in a single precision distributed vector to the specified value.
  SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP(DISTRIBUTED_VECTOR,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    REAL(SP), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
          DISTRIBUTED_VECTOR%DATA_SP=VALUE
        ELSE
          LOCAL_ERROR="The data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the single precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_SP

  !
  !================================================================================================================================
  !

  !>Sets all values in a double precision distributed vector to the specified value.
  SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP(DISTRIBUTED_VECTOR,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    REAL(DP), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
          DISTRIBUTED_VECTOR%DATA_DP=VALUE
        ELSE
          LOCAL_ERROR="The data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the double precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_DP

  !
  !================================================================================================================================
  !

  !>Sets all values in a logical distributed_vector to the specified value.
  SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_L(DISTRIBUTED_VECTOR,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    LOGICAL, INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
          DISTRIBUTED_VECTOR%DATA_L=VALUE
        ELSE
          LOCAL_ERROR="The data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the logical data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_ALL_VALUES_SET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_ALL_VALUES_SET_L

  !
  !================================================================================================================================
  !

  !>Finishes the creation a distributed vector
  SUBROUTINE DISTRIBUTED_VECTOR_CREATE_FINISH(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx,domain_idx2,domain_no,DUMMY_ERR,my_computational_node_number
    LOGICAL :: FOUND
    TYPE(VARYING_STRING) :: DUMMY_ERROR,LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_CREATE_FINISH",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        CALL FLAG_ERROR("The distributed vector has already been finished",ERR,ERROR,*999)
      ELSE
        my_computational_node_number=COMPUTATIONAL_NODE_NUMBER_GET(ERR,ERROR)
        IF(ERR/=0) GOTO 999
        DISTRIBUTED_VECTOR%BASE_TAG_NUMBER=DISTRIBUTED_DATA_ID
        IF(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_DOMAINS==1) THEN
          DISTRIBUTED_DATA_ID=DISTRIBUTED_DATA_ID+1
        ELSE
          DISTRIBUTED_DATA_ID=DISTRIBUTED_DATA_ID+DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_LIST( &
            & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_DOMAINS)-1
        ENDIF
        DISTRIBUTED_VECTOR%DATA_SIZE=DISTRIBUTED_VECTOR%DOMAIN_MAPPING%TOTAL_NUMBER_OF_LOCAL
        DISTRIBUTED_VECTOR%N=DISTRIBUTED_VECTOR%DOMAIN_MAPPING%TOTAL_NUMBER_OF_LOCAL
        SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
        CASE(MATRIX_VECTOR_INTG_TYPE)
          ALLOCATE(DISTRIBUTED_VECTOR%DATA_INTG(DISTRIBUTED_VECTOR%DATA_SIZE),STAT=ERR)
          IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector integer data",ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_SP_TYPE)
          ALLOCATE(DISTRIBUTED_VECTOR%DATA_SP(DISTRIBUTED_VECTOR%DATA_SIZE),STAT=ERR)
          IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector single precsion data",ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_DP_TYPE)
          ALLOCATE(DISTRIBUTED_VECTOR%DATA_DP(DISTRIBUTED_VECTOR%DATA_SIZE),STAT=ERR)
          IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector double precsion data",ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_L_TYPE)
          ALLOCATE(DISTRIBUTED_VECTOR%DATA_L(DISTRIBUTED_VECTOR%DATA_SIZE),STAT=ERR)
          IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector logical data",ERR,ERROR,*999)
        CASE DEFAULT
          LOCAL_ERROR="The distributed vector data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        END SELECT
        ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS),STAT=ERR)
        IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector transfer buffers",ERR,ERROR,*999)
        DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
          CALL DISTRIBUTED_VECTOR_TRANSFER_INITIALISE(DISTRIBUTED_VECTOR,domain_idx,ERR,ERROR,*999)
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE= &
            & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_SEND_GHOSTS
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE= &
            & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_RECEIVE_GHOSTS
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%DATA_TYPE=DISTRIBUTED_VECTOR%DATA_TYPE
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER=DISTRIBUTED_VECTOR%BASE_TAG_NUMBER + &
            & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_PTR(my_computational_node_number)+domain_idx-1
          domain_no=DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER
          FOUND=.FALSE.
          DO domain_idx2=DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_PTR(domain_no), &
            & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_PTR(domain_no+1)-1
            IF(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_LIST(domain_idx2)==my_computational_node_number) THEN
              FOUND=.TRUE.
              EXIT
            ENDIF
          ENDDO !domain_idx2
          IF(FOUND) THEN
            domain_idx2=domain_idx2-DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_PTR(domain_no)+1
            DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER=DISTRIBUTED_VECTOR%BASE_TAG_NUMBER + &
              & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS_PTR(domain_no)+domain_idx2-1
          ELSE
            CALL FLAG_ERROR("Could not find domain to set the receive tag number",ERR,ERROR,*999)
          ENDIF
          SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
          CASE(DISTRIBUTED_MATRIX_VECTOR_INTG_TYPE)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_INTG(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector send integer transfer buffer",ERR,ERROR,*999)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_INTG(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector receive integer transfer buffer",ERR,ERROR,*999)
          CASE(DISTRIBUTED_MATRIX_VECTOR_SP_TYPE)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SP(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector send single precision transfer buffer", &
              & ERR,ERROR,*999)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SP(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector receive single precision transfer buffer", &
              & ERR,ERROR,*999)
          CASE(DISTRIBUTED_MATRIX_VECTOR_DP_TYPE)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_DP(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector send double precision transfer buffer", &
              & ERR,ERROR,*999)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_DP(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector receive double precision transfer buffer", &
              & ERR,ERROR,*999)
          CASE(DISTRIBUTED_MATRIX_VECTOR_L_TYPE)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_L(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector send logical transfer buffer",ERR,ERROR,*999)
            ALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_L(DISTRIBUTED_VECTOR% &
              & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE),STAT=ERR)
            IF(ERR/=0) CALL FLAG_ERROR("Could not allocate distributed vector receive logical transfer buffer",ERR,ERROR,*999)
          CASE DEFAULT
            LOCAL_ERROR="The distributed vector data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          END SELECT
        ENDDO !domain_idx
        DISTRIBUTED_VECTOR%VECTOR_FINISHED=.TRUE.
      ENDIF
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_CREATE_FINISH")
    RETURN
999 IF(ASSOCIATED(DISTRIBUTED_VECTOR)) CALL DISTRIBUTED_VECTOR_FINALISE(DISTRIBUTED_VECTOR,DUMMY_ERR,DUMMY_ERROR,*998)
    DEALLOCATE(DISTRIBUTED_VECTOR)
998 CALL ERRORS("DISTRIBUTED_VECTOR_CREATE_FINISH",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_CREATE_FINISH")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_CREATE_FINISH

  !
  !================================================================================================================================
  !

  !>Starts the creation a distributed vector.
  SUBROUTINE DISTRIBUTED_VECTOR_CREATE_START(DOMAIN_MAPPING,DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DOMAIN_MAPPING_TYPE), POINTER :: DOMAIN_MAPPING !<A pointer to the domain mapping used to distribute this vector
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<On return, a pointer to the created distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_VECTOR_CREATE_START",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      CALL FLAG_ERROR("Distributed vector is already associated",ERR,ERROR,*999)
    ELSE
      IF(ASSOCIATED(DOMAIN_MAPPING)) THEN
        ALLOCATE(DISTRIBUTED_VECTOR,STAT=ERR)
        IF(ERR/=0) CALL FLAG_ERROR("Could not allocated the distributed vector",ERR,ERROR,*999)
        CALL DISTRIBUTED_VECTOR_INITIALISE(DISTRIBUTED_VECTOR,ERR,ERROR,*999)
        !Set the default values
        DISTRIBUTED_VECTOR%DOMAIN_MAPPING=>DOMAIN_MAPPING
        DISTRIBUTED_VECTOR%DATA_TYPE=MATRIX_VECTOR_DP_TYPE
      ELSE
        CALL FLAG_ERROR("Domain mapping is not associated",ERR,ERROR,*999)
      ENDIF
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_CREATE_START")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_CREATE_START",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_CREATE_START")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_CREATE_START

  !
  !================================================================================================================================
  !

  !>Sets/changes the data type of a distributed vector.
  SUBROUTINE DISTRIBUTED_VECTOR_DATA_TYPE_SET(DISTRIBUTED_VECTOR,DATA_TYPE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: DATA_TYPE !<The data type to be set \see DISTRIBUTED_MATRIX_VECTOR_DataTypes,DISTRIBUTED_MATRIX_VECTOR
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_DATA_TYPE_SET",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        CALL FLAG_ERROR("The distributed vector has been finished",ERR,ERROR,*999)
      ELSE
        SELECT CASE(DATA_TYPE)
        CASE(MATRIX_VECTOR_INTG_TYPE)
          DISTRIBUTED_VECTOR%DATA_TYPE=MATRIX_VECTOR_INTG_TYPE
        CASE(MATRIX_VECTOR_SP_TYPE)
          DISTRIBUTED_VECTOR%DATA_TYPE=MATRIX_VECTOR_SP_TYPE
        CASE(MATRIX_VECTOR_DP_TYPE)
          DISTRIBUTED_VECTOR%DATA_TYPE=MATRIX_VECTOR_DP_TYPE
        CASE(MATRIX_VECTOR_L_TYPE)
          DISTRIBUTED_VECTOR%DATA_TYPE=MATRIX_VECTOR_L_TYPE
        CASE DEFAULT
          LOCAL_ERROR="The distributed data type of "//TRIM(NUMBER_TO_VSTRING(DATA_TYPE,"*",ERR,ERROR))//" is invalid"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        END SELECT
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_TYPE_SET")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DATA_TYPE_SET",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_TYPE_SET")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DATA_TYPE_SET

  !
  !================================================================================================================================
  !

  !>Destroys a distributed vector.
  SUBROUTINE DISTRIBUTED_VECTOR_DESTROY(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_VECTOR_DESTROY",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      CALL DISTRIBUTED_VECTOR_FINALISE(DISTRIBUTED_VECTOR,ERR,ERROR,*999)
    ELSE
      !??? Error?
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DESTROY")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DESTROY",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DESTROY")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DESTROY

  !
  !================================================================================================================================
  !

  !>Duplicates the structure of a distributed vector and returns a pointer to the new distributed vector in NEW_DISTRIBUTED_VECTOR.
  SUBROUTINE DISTRIBUTED_VECTOR_DUPLICATE(DISTRIBUTED_VECTOR,NEW_DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector to duplicate
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: NEW_DISTRIBUTED_VECTOR !<On return a pointer to the new duplicated distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables

    CALL ENTERS("DISTRIBUTED_VECTOR_DUPLICATE",ERR,ERROR,*998)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ASSOCIATED(NEW_DISTRIBUTED_VECTOR)) THEN
        CALL FLAG_ERROR("New distributed vector is already associated",ERR,ERROR,*998)
      ELSE
        CALL DISTRIBUTED_VECTOR_CREATE_START(DISTRIBUTED_VECTOR%DOMAIN_MAPPING,NEW_DISTRIBUTED_VECTOR,ERR,ERROR,*999)
        CALL DISTRIBUTED_VECTOR_DATA_TYPE_SET(NEW_DISTRIBUTED_VECTOR,DISTRIBUTED_VECTOR%DATA_TYPE,ERR,ERROR,*999)
        CALL DISTRIBUTED_VECTOR_CREATE_FINISH(NEW_DISTRIBUTED_VECTOR,ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*998)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DUPLICATE")
    RETURN
999 CALL DISTRIBUTED_VECTOR_FINALISE(NEW_DISTRIBUTED_VECTOR,ERR,ERROR,*998)
998 CALL ERRORS("DISTRIBUTED_VECTOR_DUPLICATE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DUPLICATE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DUPLICATE

  !
  !================================================================================================================================
  !

  !>Finalises a distributed vector and deallocates all memory.
  SUBROUTINE DISTRIBUTED_VECTOR_FINALISE(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx

    CALL ENTERS("DISTRIBUTED_VECTOR_FINALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ALLOCATED(DISTRIBUTED_VECTOR%DATA_INTG)) DEALLOCATE(DISTRIBUTED_VECTOR%DATA_INTG)
      IF(ALLOCATED(DISTRIBUTED_VECTOR%DATA_SP)) DEALLOCATE(DISTRIBUTED_VECTOR%DATA_SP)
      IF(ALLOCATED(DISTRIBUTED_VECTOR%DATA_DP)) DEALLOCATE(DISTRIBUTED_VECTOR%DATA_DP)
      IF(ALLOCATED(DISTRIBUTED_VECTOR%DATA_L)) DEALLOCATE(DISTRIBUTED_VECTOR%DATA_L)
      IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS)) THEN
        DO domain_idx=1,SIZE(DISTRIBUTED_VECTOR%TRANSFERS)
          CALL DISTRIBUTED_VECTOR_TRANSFER_FINALISE(DISTRIBUTED_VECTOR,domain_idx,ERR,ERROR,*999)
        ENDDO !domain_idx
        DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS)
      ENDIF
      DEALLOCATE(DISTRIBUTED_VECTOR)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_FINALISE")
    RETURN
999 IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS)) DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS)
    CALL ERRORS("DISTRIBUTED_VECTOR_FINALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_FINALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_FINALISE

  !
  !================================================================================================================================
  !

  !>Initialises a distributed vector.
  SUBROUTINE DISTRIBUTED_VECTOR_INITIALISE(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    
    CALL ENTERS("DISTRIBUTED_VECTOR_INITIALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      DISTRIBUTED_VECTOR%BASE_TAG_NUMBER=0
      DISTRIBUTED_VECTOR%VECTOR_FINISHED=.FALSE.
      NULLIFY(DISTRIBUTED_VECTOR%DOMAIN_MAPPING)
      DISTRIBUTED_VECTOR%DATA_TYPE=0
      DISTRIBUTED_VECTOR%DATA_SIZE=0
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_INITIALISE")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_INITIALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_INITIALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_INITIALISE

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of an integer distributed vector. Note: the values can be used for read operations but a DISTRIBUTED_VECTOR_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_INTG(DISTRIBUTED_VECTOR,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), POINTER :: DATA(:) !<On return, a pointer to the data of the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_DATA_GET_INTG",ERR,ERROR,*999)

     IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
            DATA=>DISTRIBUTED_VECTOR%DATA_INTG
          ELSE
            LOCAL_ERROR="The distributed data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the integer data type of the requested values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DATA_GET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_INTG

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of a single precision distributed vector. Note: the values can be used for read operations but a DISTRIBUTED_VECTOR_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_SP(DISTRIBUTED_VECTOR,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    REAL(SP), POINTER :: DATA(:) !<On return, a pointer to the data of the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_DATA_GET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
            DATA=>DISTRIBUTED_VECTOR%DATA_SP
          ELSE
            LOCAL_ERROR="The distributed data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the single precision data type of the requested values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DATA_GET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_SP

  !
  !================================================================================================================================
  !

  !> Returns a pointer to the data of a double precision distributed vector. Note: the values can be used for read operations but a DISTRIBUTED_VECTOR_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_DP(DISTRIBUTED_VECTOR,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    REAL(DP), POINTER :: DATA(:) !<On return, a pointer to the data of the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_DATA_GET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
            DATA=>DISTRIBUTED_VECTOR%DATA_DP
          ELSE
            LOCAL_ERROR="The distributed data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the double precision data type of the requested values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DATA_GET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_DP

  !
  !================================================================================================================================
  !

  !>Returns a pointer to the data of a logical distributed vector. Note: the values can be used for read operations but a DISTRIBUTED_VECTOR_VALUES_SET call must be used to change any values. The pointer should not be deallocated.
  SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_L(DISTRIBUTED_VECTOR,DATA,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    LOGICAL, POINTER :: DATA(:) !<On return, a pointer to the data of the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_DATA_GET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ASSOCIATED(DATA)) THEN
        CALL FLAG_ERROR("Data is already associated",ERR,ERROR,*999)
      ELSE
        NULLIFY(DATA)
        IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
            DATA=>DISTRIBUTED_VECTOR%DATA_L
          ELSE
            LOCAL_ERROR="The distributed data type of "//TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the logical data type of the requested values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
        ENDIF
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_DATA_GET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_DATA_GET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_DATA_GET_L

  !
  !================================================================================================================================
  !

  !>Outputs a distributed vector to the specified output ID.
  SUBROUTINE DISTRIBUTED_VECTOR_OUTPUT(ID,DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    INTEGER(INTG), INTENT(IN) :: ID !<The ID of the output stream
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector to duplicate
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_OUTPUT",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
        CASE(MATRIX_VECTOR_INTG_TYPE)
          CALL WRITE_STRING_VECTOR(ID,1,1,DISTRIBUTED_VECTOR%N,8,8,DISTRIBUTED_VECTOR%DATA_INTG, &
            & '("Vector(:)          :",8(X,I13))','(20X,8(X,I13))',ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_SP_TYPE)
          CALL WRITE_STRING_VECTOR(ID,1,1,DISTRIBUTED_VECTOR%N,8,8,DISTRIBUTED_VECTOR%DATA_SP, &
            & '("Vector(:)          :",8(X,E13.6))','(20X,8(X,E13.6))',ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_DP_TYPE)
          CALL WRITE_STRING_VECTOR(ID,1,1,DISTRIBUTED_VECTOR%N,8,8,DISTRIBUTED_VECTOR%DATA_DP, &
            & '("Vector(:)          :",8(X,E13.6))','(20X,8(X,E13.6))',ERR,ERROR,*999)
        CASE(MATRIX_VECTOR_L_TYPE)            
          CALL WRITE_STRING_VECTOR(ID,1,1,DISTRIBUTED_VECTOR%N,8,8,DISTRIBUTED_VECTOR%DATA_INTG, &
            & '("Vector(:)          :",8(X,L13))','(20X,8(X,L13))',ERR,ERROR,*999)
        CASE DEFAULT
          LOCAL_ERROR="The distributed vector data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        END SELECT
      ELSE
       CALL FLAG_ERROR("Distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_OUTPUT")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_OUTPUT",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_OUTPUT")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_OUTPUT

  !
  !================================================================================================================================
  !

  !>Finalises a distributed vector transfer information and deallocates all memory.
  SUBROUTINE DISTRIBUTED_VECTOR_TRANSFER_FINALISE(DISTRIBUTED_VECTOR,domain_idx,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: domain_idx !<The domain index of the distributed vector to finalise
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_TRANSFER_FINALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS)) THEN
        IF(domain_idx>0.AND.domain_idx<=SIZE(DISTRIBUTED_VECTOR%TRANSFERS,1)) THEN
          NULLIFY(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%DISTRIBUTED_VECTOR)
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%DATA_TYPE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER=-1
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER=-1
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST=MPI_REQUEST_NULL
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST=MPI_REQUEST_NULL
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_INTG)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_INTG)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SP)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SP)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_DP)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_DP)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_L)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_L)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_INTG)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_INTG)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SP)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SP)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_DP)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_DP)
          IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_L)) &
            & DEALLOCATE(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_L)
        ELSE
          LOCAL_ERROR="The domain index of "//TRIM(NUMBER_TO_VSTRING(domain_idx,"*",ERR,ERROR))// &
            & " is invalid. It must be between 1 and "// &
            & TRIM(NUMBER_TO_VSTRING(SIZE(DISTRIBUTED_VECTOR%TRANSFERS,1),"*",ERR,ERROR))
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ENDIF
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_TRANSFER_FINALISE")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_TRANSFER_FINALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_TRANSFER_FINALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_TRANSFER_FINALISE

  !
  !================================================================================================================================
  !

  !>Initialises a distributed vector transfer information.
  SUBROUTINE DISTRIBUTED_VECTOR_TRANSFER_INITIALISE(DISTRIBUTED_VECTOR,domain_idx,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: domain_idx !<The domain index to initialise
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR

    CALL ENTERS("DISTRIBUTED_VECTOR_TRANSFER_INITIALISE",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(ALLOCATED(DISTRIBUTED_VECTOR%TRANSFERS)) THEN
        IF(domain_idx>0.AND.domain_idx<=SIZE(DISTRIBUTED_VECTOR%TRANSFERS,1)) THEN
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%DISTRIBUTED_VECTOR=>DISTRIBUTED_VECTOR
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%DATA_TYPE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE=0
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER=-1
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER=-1
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST=MPI_REQUEST_NULL
          DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST=MPI_REQUEST_NULL
        ELSE
          LOCAL_ERROR="The domain index of "//TRIM(NUMBER_TO_VSTRING(domain_idx,"*",ERR,ERROR))// &
            & " is invalid. It must be between 1 and "// &
            & TRIM(NUMBER_TO_VSTRING(SIZE(DISTRIBUTED_VECTOR%TRANSFERS,1),"*",ERR,ERROR))
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("Distributed vector transfers is not allocated",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_TRANSFER_INITIALISE")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_TRANSFER_INITIALISE",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_TRANSFER_INITIALISE")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_TRANSFER_INITIALISE

  !
  !================================================================================================================================
  !

  !>Finishes the (ghost) update procedure for a distributed vector. This routine will wait until all transfers have completed!
  SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_FINISH(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx,i,NUMBER_OF_COMPUTATIONAL_NODES
    TYPE(VARYING_STRING) :: LOCAL_ERROR
   
    CALL ENTERS("DISTRIBUTED_VECTOR_UPDATE_FINISH",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(ASSOCIATED(DISTRIBUTED_VECTOR%DOMAIN_MAPPING)) THEN
          NUMBER_OF_COMPUTATIONAL_NODES=COMPUTATIONAL_NODES_NUMBER_GET(ERR,ERROR)
          IF(ERR/=0) GOTO 999
          IF(NUMBER_OF_COMPUTATIONAL_NODES>1) THEN
            CALL DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED(DISTRIBUTED_VECTOR,ERR,ERROR,*999)
            !Copy the receive buffers back to the ghost positions in the data vector
            DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
              SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
              CASE(MATRIX_VECTOR_INTG_TYPE)
                DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_RECEIVE_GHOSTS
                  DISTRIBUTED_VECTOR%DATA_INTG(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                    & LOCAL_GHOST_RECEIVE_INDICES(i))=DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_INTG(i)
                ENDDO !i
              CASE(MATRIX_VECTOR_SP_TYPE)
                DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_RECEIVE_GHOSTS
                  DISTRIBUTED_VECTOR%DATA_SP(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                    & LOCAL_GHOST_RECEIVE_INDICES(i))=DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SP(i)
                ENDDO !i
              CASE(MATRIX_VECTOR_DP_TYPE)
                DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_RECEIVE_GHOSTS
                  DISTRIBUTED_VECTOR%DATA_DP(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                    & LOCAL_GHOST_RECEIVE_INDICES(i))=DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_DP(i)
                ENDDO !i
              CASE(MATRIX_VECTOR_L_TYPE)
                DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_RECEIVE_GHOSTS
                  DISTRIBUTED_VECTOR%DATA_L(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                    & LOCAL_GHOST_RECEIVE_INDICES(i))=DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_L(i)
                ENDDO !i
              CASE DEFAULT
                LOCAL_ERROR="The distributed vector data type of "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              END SELECT
            ENDDO !domain_idx
          ENDIF
        ELSE
          CALL FLAG_ERROR("Distributed vector domain mapping is not associated",ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    IF(DIAGNOSTICS1) THEN
      CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"Distributed vector :",ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Data type = ",DISTRIBUTED_VECTOR%DATA_TYPE,ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Base tag number = ",DISTRIBUTED_VECTOR%BASE_TAG_NUMBER, &
        & ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Number of adjacent domains = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
        & NUMBER_OF_ADJACENT_DOMAINS,ERR,ERROR,*999)
      DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Domain idx = ",domain_idx,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Domain number = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
          & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Receive tag number = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Send tag number = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    MPI send request = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    MPI receive request = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)
      ENDDO !domain_idx
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Data size = ",DISTRIBUTED_VECTOR%DATA_SIZE,ERR,ERROR,*999)
      SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
      CASE(MATRIX_VECTOR_INTG_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_INTG, &
          & '("  Data :",5(X,I13))','(8X,5(X,I13))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_SP_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_SP, &
          & '("  Data :",5(X,E13.6))','(8X,5(X,E13.6))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_DP_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_DP, &
          & '("  Data :",5(X,E13.6))','(8X,5(X,E13.6))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_L_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,8,8,DISTRIBUTED_VECTOR%DATA_L, &
          & '("  Data :",8(X,L))','(8X,8(X,L))',ERR,ERROR,*999)      
      CASE DEFAULT
        LOCAL_ERROR="The distributed vector data type of "// &
          & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
        CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
      END SELECT         
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_FINISH")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_UPDATE_FINISH",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_FINISH")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_FINISH

  !
  !================================================================================================================================
  !

  !>Tests to see if a distributed vector update has finised! \todo USE MPI_TESTALL and store the request handles as big array.
  SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_ISFINISHED(DISTRIBUTED_VECTOR,ISFINISHED,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    LOGICAL, INTENT(OUT) :: ISFINISHED !<On return, is .TRUE. if all the transfer operations for the distributed vector have completed, .FALSE. if not
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx
    INTEGER(INTG) :: MPI_IERROR,STATUS(MPI_STATUS_SIZE)
    
    CALL ENTERS("DISTRIBUTED_VECTOR_UPDATE_ISFINISHED",ERR,ERROR,*999)

    ISFINISHED=.FALSE.
    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(ASSOCIATED(DISTRIBUTED_VECTOR%DOMAIN_MAPPING)) THEN
!!TODO: USE MPI_TESTALL and store the request handles as big array.
          DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
            CALL MPI_TEST(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ISFINISHED,STATUS,MPI_IERROR)
            CALL MPI_ERROR_CHECK("MPI_TEST",MPI_IERROR,ERR,ERROR,*999)
            IF(.NOT.ISFINISHED) EXIT
            !CALL MPI_TEST(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ISFINISHED,STATUS,MPI_IERROR)
            !CALL MPI_ERROR_CHECK("MPI_TEST",MPI_IERROR,ERR,ERROR,*999)
            !IF(.NOT.ISFINISHED) EXIT
          ENDDO !domain_idx
        ELSE
          CALL FLAG_ERROR("Distributed vector domain mapping is not associated",ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_ISFINISHED")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_UPDATE_ISFINISHED",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_ISFINISHED")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_ISFINISHED

  !
  !================================================================================================================================
  !

  !> Waits until a distributed vector update has finised
  SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx
    INTEGER(INTG) :: MPI_IERROR,STATUS(MPI_STATUS_SIZE)
    
    CALL ENTERS("DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(ASSOCIATED(DISTRIBUTED_VECTOR%DOMAIN_MAPPING)) THEN
!!TODO: USE MPI_WAITALL and store the request handles as big array.
          DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
            CALL MPI_WAIT(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,STATUS,MPI_IERROR)
            CALL MPI_ERROR_CHECK("MPI_WAIT",MPI_IERROR,ERR,ERROR,*999)
          ENDDO !domain_idx
        ELSE
          CALL FLAG_ERROR("Distributed vector domain mapping is not associated",ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_WAITFINISHED

  !
  !================================================================================================================================
  !

  !>Starts the (ghost) update procedure for a distributed vector.
  SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_START(DISTRIBUTED_VECTOR,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: domain_idx,i,MPI_IERROR,NUMBER_OF_COMPUTATIONAL_NODES
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_UPDATE_START",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(ASSOCIATED(DISTRIBUTED_VECTOR%DOMAIN_MAPPING)) THEN
          NUMBER_OF_COMPUTATIONAL_NODES=COMPUTATIONAL_NODES_NUMBER_GET(ERR,ERROR)
          IF(ERR/=0) GOTO 999
          IF(NUMBER_OF_COMPUTATIONAL_NODES>1) THEN
            IF(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS>0) THEN
              !Fill in the send buffers with the send ghost values
              DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
                SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
                CASE(MATRIX_VECTOR_INTG_TYPE)
                  DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_SEND_GHOSTS
                    DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_INTG(i)= &
                      & DISTRIBUTED_VECTOR%DATA_INTG(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                      & LOCAL_GHOST_SEND_INDICES(i))
                  ENDDO !i
                CASE(MATRIX_VECTOR_SP_TYPE)
                  DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_SEND_GHOSTS
                    DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SP(i)= &
                      & DISTRIBUTED_VECTOR%DATA_SP(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                      & LOCAL_GHOST_SEND_INDICES(i))
                  ENDDO !i
                CASE(MATRIX_VECTOR_DP_TYPE)
                  DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_SEND_GHOSTS
                    DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_DP(i)= &
                    & DISTRIBUTED_VECTOR%DATA_DP(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                    & LOCAL_GHOST_SEND_INDICES(i))
                  ENDDO !i
                CASE(MATRIX_VECTOR_L_TYPE)
                  DO i=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%NUMBER_OF_SEND_GHOSTS
                    DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_L(i)= &
                      & DISTRIBUTED_VECTOR%DATA_L(DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)% &
                      & LOCAL_GHOST_SEND_INDICES(i))
                  ENDDO !i
                CASE DEFAULT
                  LOCAL_ERROR="The distributed vector data type of "// &
                    & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
                  CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
                END SELECT
              ENDDO !domain_idx
              !Post all the receive calls first and then the send calls.
              DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
                SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
                CASE(MATRIX_VECTOR_INTG_TYPE)
                  CALL MPI_IRECV(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_INTG, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,MPI_INTEGER, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_IRECV",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI IRECV call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive datatype = ",MPI_INTEGER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive source = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_SP_TYPE)
                  CALL MPI_IRECV(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SP, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,MPI_REAL, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_IRECV",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI IRECV call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive datatype = ",MPI_REAL,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive source = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_DP_TYPE)
                  CALL MPI_IRECV(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_DP, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,MPI_DOUBLE_PRECISION, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_IRECV",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI IRECV call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive datatype = ",MPI_DOUBLE_PRECISION,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive source = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_L_TYPE)
                  CALL MPI_IRECV(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_L, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,MPI_LOGICAL, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_IRECV",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI IRECV call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive datatype = ",MPI_LOGICAL,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive source = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Receive request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE DEFAULT
                  LOCAL_ERROR="The distributed vector data type of "// &
                    & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
                  CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
                END SELECT
              ENDDO !domain_idx
              !Post all the send calls.
              DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
                SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
                CASE(MATRIX_VECTOR_INTG_TYPE)
                  CALL MPI_ISEND(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_INTG, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,MPI_INTEGER, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_ISEND",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI ISEND call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send datatype = ",MPI_INTEGER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send dest = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_SP_TYPE)
                  CALL MPI_ISEND(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SP, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,MPI_REAL, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_ISEND",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI ISEND call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send datatype = ",MPI_REAL,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send dest = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_DP_TYPE)
                  CALL MPI_ISEND(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_DP, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,MPI_DOUBLE_PRECISION, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_ISEND",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI ISEND call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send datatype = ",MPI_DOUBLE_PRECISION,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send dest = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE(MATRIX_VECTOR_L_TYPE)
                  CALL MPI_ISEND(DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_L, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,MPI_LOGICAL, &
                    & DISTRIBUTED_VECTOR%DOMAIN_MAPPING%ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%SEND_TAG_NUMBER,MPI_COMM_WORLD, &
                    & DISTRIBUTED_VECTOR%TRANSFERS(domain_idx)%MPI_SEND_REQUEST,MPI_IERROR)
                  CALL MPI_ERROR_CHECK("MPI_ISEND",MPI_IERROR,ERR,ERROR,*999)
                  IF(DIAGNOSTICS5) THEN
                    CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"MPI ISEND call posted:",ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send count = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_BUFFER_SIZE,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send datatype = ",MPI_LOGICAL,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send dest = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
                      & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send tag = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send comm = ",MPI_COMM_WORLD,ERR,ERROR,*999)
                    CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Send request = ",DISTRIBUTED_VECTOR% &
                      & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)                
                  ENDIF
                CASE DEFAULT
                  LOCAL_ERROR="The distributed vector data type of "// &
                    & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
                  CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
                END SELECT
              ENDDO !domain_idx
            ENDIF
          ENDIF
        ELSE
          CALL FLAG_ERROR("Domain mapping is not associated for the distributed vector",ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF

    IF(DIAGNOSTICS1) THEN
      CALL WRITE_STRING(DIAGNOSTIC_OUTPUT_TYPE,"Distributed vector :",ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Data type = ",DISTRIBUTED_VECTOR%DATA_TYPE,ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Base tag number = ",DISTRIBUTED_VECTOR%BASE_TAG_NUMBER, &
        & ERR,ERROR,*999)
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Number of adjacent domains = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
        & NUMBER_OF_ADJACENT_DOMAINS,ERR,ERROR,*999)
      DO domain_idx=1,DISTRIBUTED_VECTOR%DOMAIN_MAPPING%NUMBER_OF_ADJACENT_DOMAINS
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Domain idx = ",domain_idx,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Domain number = ",DISTRIBUTED_VECTOR%DOMAIN_MAPPING% &
          & ADJACENT_DOMAINS(domain_idx)%DOMAIN_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Receive tag number = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%RECEIVE_TAG_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    Send tag number = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%SEND_TAG_NUMBER,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    MPI send request = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%MPI_SEND_REQUEST,ERR,ERROR,*999)
        CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"    MPI receive request = ",DISTRIBUTED_VECTOR% &
          & TRANSFERS(domain_idx)%MPI_RECEIVE_REQUEST,ERR,ERROR,*999)
      ENDDO !domain_idx
      CALL WRITE_STRING_VALUE(DIAGNOSTIC_OUTPUT_TYPE,"  Data size = ",DISTRIBUTED_VECTOR%DATA_SIZE,ERR,ERROR,*999)
      SELECT CASE(DISTRIBUTED_VECTOR%DATA_TYPE)
      CASE(MATRIX_VECTOR_INTG_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_INTG, &
          & '("  Data :",5(X,I13))','(8X,5(X,I13))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_SP_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_SP, &
          & '("  Data :",5(X,E13.6))','(8X,5(X,E13.6))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_DP_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,5,5,DISTRIBUTED_VECTOR%DATA_DP, &
          & '("  Data :",5(X,E13.6))','(8X,5(X,E13.6))',ERR,ERROR,*999)      
      CASE(MATRIX_VECTOR_L_TYPE)
        CALL WRITE_STRING_VECTOR(DIAGNOSTIC_OUTPUT_TYPE,1,1,DISTRIBUTED_VECTOR%DATA_SIZE,8,8,DISTRIBUTED_VECTOR%DATA_L, &
          & '("  Data :",8(X,L))','(8X,8(X,L))',ERR,ERROR,*999)      
      CASE DEFAULT
        LOCAL_ERROR="The distributed vector data type of "// &
          & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))//" is invalid"
        CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
      END SELECT         
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_START")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_UPDATE_START",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_UPDATE_START")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_UPDATE_START

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed integer vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_INTG(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to add
    INTEGER(INTG), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values added until dof mappings fixed. Ghost values that are added will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_INTG(INDICES(i))=DISTRIBUTED_VECTOR%DATA_INTG(INDICES(i))+VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the integer data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indicies array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_INTG

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed integer vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_INTG1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be added at
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value to be added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
          !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_INTG(INDEX)=DISTRIBUTED_VECTOR%DATA_INTG(INDEX)+VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the integer data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_INTG1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_INTG1

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed single precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_SP(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be added
    REAL(SP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to add
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_SP(INDICES(i))=DISTRIBUTED_VECTOR%DATA_SP(INDICES(i))+VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the single precision data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_SP

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed single precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_SP1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be added
    REAL(SP), INTENT(IN) :: VALUE !<The value to be added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_SP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
          !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_SP(INDEX)=DISTRIBUTED_VECTOR%DATA_SP(INDEX)+VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the single precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_SP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_SP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_SP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_SP1

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed double precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_DP(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be added
    REAL(DP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_DP(INDICES(i))=DISTRIBUTED_VECTOR%DATA_DP(INDICES(i))+VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the double precision data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_DP

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed double precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_DP1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be added
    REAL(DP), INTENT(IN) :: VALUE !<The value to be added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_DP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
          !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_DP(INDEX)=DISTRIBUTED_VECTOR%DATA_DP(INDEX)+VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the double precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_DP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_DP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_DP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_DP1

  !
  !================================================================================================================================
  !

  !>Adds values to a distributed logical vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_L(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be added
    LOGICAL, INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADDED_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_L(INDICES(i))=DISTRIBUTED_VECTOR%DATA_L(INDICES(i))+VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the logical data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_L

  !
  !================================================================================================================================
  !

  !>Adds one value to a distributed logical vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_L1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be added
    LOGICAL, INTENT(IN) :: VALUE !<The value to be added
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_ADD_L1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
          !Allow all values to be added until dof mappings fixed. Ghost values that are added will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_L(INDEX)=DISTRIBUTED_VECTOR%DATA_L(INDEX)+VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the logical data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_L1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_ADD_L1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_ADD_L1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_ADD_L1

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed integer vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_INTG(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be set
    INTEGER(INTG), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_INTG",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_INTG(INDICES(i))=VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the integer data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indicies array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_INTG")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_INTG",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_INTG")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_INTG

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed integer vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_INTG1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be set
    INTEGER(INTG), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_INTG1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_INTG_TYPE) THEN
          !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_INTG(INDEX)=VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the integer data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_INTG1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_INTG1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_INTG1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_INTG1

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed single precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_SP(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be set
    REAL(SP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_SP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_SP(INDICES(i))=VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the single precision data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_SP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_SP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_SP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_SP

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed single precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_SP1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be set
    REAL(SP), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_SP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_SP_TYPE) THEN
          !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_SP(INDEX)=VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the single precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_SP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_SP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_SP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_SP1

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed double precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_DP(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be set
    REAL(DP), INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_DP",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_DP(INDICES(i))=VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the double precision data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_DP")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_DP",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_DP")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_DP

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed double precision vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_DP1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be set
    REAL(DP), INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_DP1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_DP_TYPE) THEN
          !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_DP(INDEX)=VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the double precision data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_DP1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_DP1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_DP1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_DP1

  !
  !================================================================================================================================
  !

  !>Sets values in a distributed logical vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_L(DISTRIBUTED_VECTOR,INDICES,VALUES,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDICES(:) !<INDICES(i). The i'th index to be set
    LOGICAL, INTENT(IN) :: VALUES(:) !<VALUES(i). The i'th value to set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    INTEGER(INTG) :: i
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_L",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(SIZE(INDICES,1)==SIZE(VALUES,1)) THEN
          IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
            DO i=1,SIZE(INDICES,1)
              !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
              IF(INDICES(i)>0.AND.INDICES(i)<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
                DISTRIBUTED_VECTOR%DATA_L(INDICES(i))=VALUES(i)
              ELSE
                LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDICES(i),"*",ERR,ERROR))// &
                  & " is invalid. The index must be between 1 and "// &
                  & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
                CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
              ENDIF
            ENDDO !i
          ELSE
            LOCAL_ERROR="The distributed data type of "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
              & " does not correspond to the logical data type of the given values"
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The size of the indices array ("//TRIM(NUMBER_TO_VSTRING(SIZE(INDICES,1),"*",ERR,ERROR))// &
            & ") does not conform to the size of the values array ("//TRIM(NUMBER_TO_VSTRING(SIZE(VALUES,1),"*",ERR,ERROR))//")"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_L")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_L",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_L")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_L

  !
  !================================================================================================================================
  !

  !>Sets one value in a distributed logical vector.
  SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_L1(DISTRIBUTED_VECTOR,INDEX,VALUE,ERR,ERROR,*)

    !Argument variables
    TYPE(DISTRIBUTED_VECTOR_TYPE), POINTER :: DISTRIBUTED_VECTOR !<A pointer to the distributed vector
    INTEGER(INTG), INTENT(IN) :: INDEX !<The index to be set
    LOGICAL, INTENT(IN) :: VALUE !<The value to be set
    INTEGER(INTG), INTENT(OUT) :: ERR !<The error code
    TYPE(VARYING_STRING), INTENT(OUT) :: ERROR !<The error string
    !Local Variables
    TYPE(VARYING_STRING) :: LOCAL_ERROR
    
    CALL ENTERS("DISTRIBUTED_VECTOR_VALUES_SET_L1",ERR,ERROR,*999)

    IF(ASSOCIATED(DISTRIBUTED_VECTOR)) THEN
      IF(DISTRIBUTED_VECTOR%VECTOR_FINISHED) THEN
        IF(DISTRIBUTED_VECTOR%DATA_TYPE==MATRIX_VECTOR_L_TYPE) THEN
          !Allow all values set until dof mappings fixed. Ghost values that are set will not be propogated
          IF(INDEX>0.AND.INDEX<=DISTRIBUTED_VECTOR%DATA_SIZE) THEN
            DISTRIBUTED_VECTOR%DATA_L(INDEX)=VALUE
          ELSE
            LOCAL_ERROR="Index "//TRIM(NUMBER_TO_VSTRING(INDEX,"*",ERR,ERROR))// &
              & " is invalid. The index must be between 1 and "// &
              & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_SIZE,"*",ERR,ERROR))
            CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
          ENDIF
        ELSE
          LOCAL_ERROR="The distributed data type of "// &
            & TRIM(NUMBER_TO_VSTRING(DISTRIBUTED_VECTOR%DATA_TYPE,"*",ERR,ERROR))// &
            & " does not correspond to the logical data type of the given value"
          CALL FLAG_ERROR(LOCAL_ERROR,ERR,ERROR,*999)
        ENDIF
      ELSE
        CALL FLAG_ERROR("The distributed vector has not been finished",ERR,ERROR,*999)
      ENDIF
    ELSE
      CALL FLAG_ERROR("Distributed vector is not associated",ERR,ERROR,*999)
    ENDIF
    
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_L1")
    RETURN
999 CALL ERRORS("DISTRIBUTED_VECTOR_VALUES_SET_L1",ERR,ERROR)
    CALL EXITS("DISTRIBUTED_VECTOR_VALUES_SET_L1")
    RETURN 1
  END SUBROUTINE DISTRIBUTED_VECTOR_VALUES_SET_L1

  !
  !================================================================================================================================
  !
  
END MODULE DISTRIBUTED_MATRIX_VECTOR
