      SUBROUTINE SMATRIX12(P,ANS)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.5.2, 2016-12-10
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     MadGraph5_aMC@NLO for Madevent Version
C     
C     Returns amplitude squared summed/avg over colors
C     and helicities
C     for the point in phase space P(0:3,NEXTERNAL)
C     
C     Process: u~ d~ > x1+ x1- u~ d~ QCD=0 / go dl dr ul ur sl sr cl
C      cr b1 b2 t1 t2 dl dr ul ur sl sr cl cr b1 b2 t1 t2 @1
C     Process: c~ s~ > x1+ x1- c~ s~ QCD=0 / go dl dr ul ur sl sr cl
C      cr b1 b2 t1 t2 dl dr ul ur sl sr cl cr b1 b2 t1 t2 @1
C     
      USE DISCRETESAMPLER
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INCLUDE 'genps.inc'
      INCLUDE 'maxconfigs.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=64)
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=44)
      INTEGER    NDIAGS
      PARAMETER (NDIAGS=44)
      INTEGER    THEL
      PARAMETER (THEL=2*NCOMB)
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
C     
C     global (due to reading writting) 
C     
      LOGICAL GOODHEL(NCOMB,2)
      INTEGER NTRY(2)
      COMMON/BLOCK_GOODHEL/NTRY,GOODHEL
C     
C     LOCAL VARIABLES 
C     
      INTEGER NHEL(NEXTERNAL,NCOMB)
      INTEGER ISHEL(2)
      REAL*8 T,MATRIX12
      REAL*8 R,SUMHEL,TS(NCOMB)
      INTEGER I,IDEN
      INTEGER JC(NEXTERNAL),II
      REAL*8 HWGT, XTOT, XTRY, XREJ, XR, YFRAC(0:NCOMB)
      INTEGER NGOOD(2), IGOOD(NCOMB,2)
      INTEGER JHEL(2), J, JJ
      INTEGER THIS_NTRY(2)
      SAVE THIS_NTRY
      DATA THIS_NTRY /0,0/
C     This is just to temporarily store the reference grid for
C      helicity of the DiscreteSampler so as to obtain its number of
C      entries with ref_helicity_grid%n_tot_entries
      TYPE(SAMPLEDDIMENSION) REF_HELICITY_GRID
C     
C     GLOBAL VARIABLES
C     
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2

      CHARACTER*101         HEL_BUFF
      COMMON/TO_HELICITY/  HEL_BUFF

      INTEGER IMIRROR
      COMMON/TO_MIRROR/ IMIRROR

      REAL*8 POL(2)
      COMMON/TO_POLARIZATION/ POL

      INTEGER          ISUM_HEL
      LOGICAL                    MULTI_CHANNEL
      COMMON/TO_MATRIX/ISUM_HEL, MULTI_CHANNEL
      INTEGER MAPCONFIG(0:LMAXCONFIGS), ICONFIG
      COMMON/TO_MCONFIGS/MAPCONFIG, ICONFIG
      INTEGER SUBDIAG(MAXSPROC),IB(2)
      COMMON/TO_SUB_DIAG/SUBDIAG,IB
      DATA XTRY, XREJ /0,0/
      DATA NGOOD /0,0/
      DATA ISHEL/0,0/
      SAVE YFRAC, IGOOD, JHEL
      DATA (NHEL(I,   1),I=1,6) /-1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,   2),I=1,6) /-1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,   3),I=1,6) /-1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,   4),I=1,6) /-1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,   5),I=1,6) /-1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,   6),I=1,6) /-1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,   7),I=1,6) /-1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,   8),I=1,6) /-1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,   9),I=1,6) /-1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  10),I=1,6) /-1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  11),I=1,6) /-1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  12),I=1,6) /-1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  13),I=1,6) /-1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  14),I=1,6) /-1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  15),I=1,6) /-1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  16),I=1,6) /-1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  17),I=1,6) /-1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  18),I=1,6) /-1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  19),I=1,6) /-1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  20),I=1,6) /-1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  21),I=1,6) /-1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  22),I=1,6) /-1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  23),I=1,6) /-1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  24),I=1,6) /-1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  25),I=1,6) /-1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  26),I=1,6) /-1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  27),I=1,6) /-1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  28),I=1,6) /-1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  29),I=1,6) /-1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  30),I=1,6) /-1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,  31),I=1,6) /-1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  32),I=1,6) /-1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,  33),I=1,6) / 1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,  34),I=1,6) / 1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,  35),I=1,6) / 1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,  36),I=1,6) / 1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,  37),I=1,6) / 1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,  38),I=1,6) / 1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,  39),I=1,6) / 1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,  40),I=1,6) / 1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,  41),I=1,6) / 1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  42),I=1,6) / 1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  43),I=1,6) / 1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  44),I=1,6) / 1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  45),I=1,6) / 1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  46),I=1,6) / 1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  47),I=1,6) / 1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  48),I=1,6) / 1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  49),I=1,6) / 1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  50),I=1,6) / 1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  51),I=1,6) / 1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  52),I=1,6) / 1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  53),I=1,6) / 1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  54),I=1,6) / 1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  55),I=1,6) / 1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  56),I=1,6) / 1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  57),I=1,6) / 1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  58),I=1,6) / 1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  59),I=1,6) / 1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  60),I=1,6) / 1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  61),I=1,6) / 1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  62),I=1,6) / 1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,  63),I=1,6) / 1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  64),I=1,6) / 1, 1,-1, 1,-1,-1/
      DATA IDEN/36/

C     To be able to control when the matrix<i> subroutine can add
C      entries to the grid for the MC over helicity configuration
      LOGICAL ALLOW_HELICITY_GRID_ENTRIES
      COMMON/TO_ALLOW_HELICITY_GRID_ENTRIES/ALLOW_HELICITY_GRID_ENTRIES

C     ----------
C     BEGIN CODE
C     ----------
      NTRY(IMIRROR)=NTRY(IMIRROR)+1
      THIS_NTRY(IMIRROR) = THIS_NTRY(IMIRROR)+1
      DO I=1,NEXTERNAL
        JC(I) = +1
      ENDDO

      IF (MULTI_CHANNEL) THEN
        DO I=1,NDIAGS
          AMP2(I)=0D0
        ENDDO
        JAMP2(0)=2
        DO I=1,INT(JAMP2(0))
          JAMP2(I)=0D0
        ENDDO
      ENDIF
      ANS = 0D0
      WRITE(HEL_BUFF,'(20I5)') (0,I=1,NEXTERNAL)
      DO I=1,NCOMB
        TS(I)=0D0
      ENDDO

        !   If the helicity grid status is 0, this means that it is not yet initialized.
        !   If HEL_PICKED==-1, this means that calls to other matrix<i> where in initialization mode as well for the helicity.
      IF ((ISHEL(IMIRROR).EQ.0.AND.ISUM_HEL.EQ.0).OR.(DS_GET_DIM_STATUS
     $('Helicity').EQ.0).OR.(HEL_PICKED.EQ.-1)) THEN
        DO I=1,NCOMB
          IF (GOODHEL(I,IMIRROR) .OR. NTRY(IMIRROR).LE.MAXTRIES.OR.(ISU
     $M_HEL.NE.0).OR.THIS_NTRY(IMIRROR).LE.2) THEN
            T=MATRIX12(P ,NHEL(1,I),JC(1))
            DO JJ=1,NINCOMING
              IF(POL(JJ).NE.1D0.AND.NHEL(JJ,I).EQ.INT(SIGN(1D0,POL(JJ))
     $         )) THEN
                T=T*ABS(POL(JJ))
              ELSE IF(POL(JJ).NE.1D0)THEN
                T=T*(2D0-ABS(POL(JJ)))
              ENDIF
            ENDDO
            IF (ISUM_HEL.NE.0.AND.DS_GET_DIM_STATUS('Helicity')
     $       .EQ.0.AND.ALLOW_HELICITY_GRID_ENTRIES) THEN
              CALL DS_ADD_ENTRY('Helicity',I,T)
            ENDIF
            ANS=ANS+DABS(T)
            TS(I)=T
          ENDIF
        ENDDO
        IF(NTRY(IMIRROR).EQ.(MAXTRIES+1)) THEN
          CALL RESET_CUMULATIVE_VARIABLE()  ! avoid biais of the initialization
        ENDIF
        IF (ISUM_HEL.NE.0) THEN
            !         We set HEL_PICKED to -1 here so that later on, the call to DS_add_point in dsample.f does not add anything to the grid since it was already done here.
          HEL_PICKED = -1
            !         For safety, hardset the helicity sampling jacobian to 0.0d0 to make sure it is not .
          HEL_JACOBIAN   = 1.0D0
            !         We don't want to re-update the helicity grid if it was already updated by another matrix<i>, so we make sure that the reference grid is empty.
          REF_HELICITY_GRID = DS_GET_DIMENSION(REF_GRID,'Helicity')
          IF((DS_GET_DIM_STATUS('Helicity').EQ.1).AND.(REF_HELICITY_GRI
     $D%N_TOT_ENTRIES.EQ.0)) THEN
              !           If we finished the initialization we can update the grid so as to start sampling over it.
              !           However the grid will now be filled by dsample with different kind of weights (including pdf, flux, etc...) so by setting the grid_mode of the reference grid to 'initialization' we make sure it will be overwritten (as opposed to 'combined') by the running grid at the next update.
            CALL DS_UPDATE_GRID('Helicity')
            CALL DS_SET_GRID_MODE('Helicity','init')
          ENDIF
        ELSE
          JHEL(IMIRROR) = 1
          IF(NTRY(IMIRROR).LE.MAXTRIES.OR.THIS_NTRY(IMIRROR).LE.2)THEN
            DO I=1,NCOMB
              IF (.NOT.GOODHEL(I,IMIRROR) .AND. (DABS(TS(I)).GT.ANS
     $         *LIMHEL/NCOMB)) THEN
                GOODHEL(I,IMIRROR)=.TRUE.
                NGOOD(IMIRROR) = NGOOD(IMIRROR) +1
                IGOOD(NGOOD(IMIRROR),IMIRROR) = I
                PRINT *,'Added good helicity ',I,TS(I)*NCOMB/ANS,' in'
     $           //' event ',NTRY(IMIRROR), 'local:',THIS_NTRY(IMIRROR)
              ENDIF
            ENDDO
          ENDIF
          IF(NTRY(IMIRROR).EQ.MAXTRIES)THEN
            ISHEL(IMIRROR)=MIN(ISUM_HEL,NGOOD(IMIRROR))
          ENDIF
        ENDIF
      ELSE  ! random helicity 
C       The helicity configuration was chosen already by genps and put
C        in a common block defined in genps.inc.
        I = HEL_PICKED

        T=MATRIX12(P ,NHEL(1,I),JC(1))

        DO JJ=1,NINCOMING
          IF(POL(JJ).NE.1D0.AND.NHEL(JJ,I).EQ.INT(SIGN(1D0,POL(JJ))))
     $      THEN
            T=T*ABS(POL(JJ))
          ELSE IF(POL(JJ).NE.1D0)THEN
            T=T*(2D0-ABS(POL(JJ)))
          ENDIF
        ENDDO
C       Always one helicity at a time
        ANS = T
C       Include the Jacobian from helicity sampling
        ANS = ANS * HEL_JACOBIAN

        WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
      ENDIF
      IF (ANS.NE.0D0.AND.(ISUM_HEL .NE. 1.OR.HEL_PICKED.EQ.-1)) THEN
        CALL RANMAR(R)
        SUMHEL=0D0
        DO I=1,NCOMB
          SUMHEL=SUMHEL+DABS(TS(I))/ANS
          IF(R.LT.SUMHEL)THEN
            WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
C           Set right sign for ANS, based on sign of chosen helicity
            ANS=DSIGN(ANS,TS(I))
            GOTO 10
          ENDIF
        ENDDO
 10     CONTINUE
      ENDIF
      IF (MULTI_CHANNEL) THEN
        XTOT=0D0
        DO I=1,NDIAGS
          XTOT=XTOT+AMP2(I)
        ENDDO
        IF (XTOT.NE.0D0) THEN
          ANS=ANS*AMP2(SUBDIAG(12))/XTOT
        ELSE
          ANS=0D0
        ENDIF
      ENDIF
      ANS=ANS/DBLE(IDEN)
      END


      REAL*8 FUNCTION MATRIX12(P,NHEL,IC)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.5.2, 2016-12-10
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Returns amplitude squared summed/avg over colors
C     for the point with external lines W(0:6,NEXTERNAL)
C     
C     Process: u~ d~ > x1+ x1- u~ d~ QCD=0 / go dl dr ul ur sl sr cl
C      cr b1 b2 t1 t2 dl dr ul ur sl sr cl cr b1 b2 t1 t2 @1
C     Process: c~ s~ > x1+ x1- c~ s~ QCD=0 / go dl dr ul ur sl sr cl
C      cr b1 b2 t1 t2 dl dr ul ur sl sr cl cr b1 b2 t1 t2 @1
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=44)
      INCLUDE 'genps.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER    NWAVEFUNCS,     NCOLOR
      PARAMETER (NWAVEFUNCS=15, NCOLOR=2)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
      COMPLEX*16 IMAG1
      PARAMETER (IMAG1=(0D0,1D0))
      INTEGER NAMPSO, NSQAMPSO
      PARAMETER (NAMPSO=1, NSQAMPSO=1)
      LOGICAL CHOSEN_SO_CONFIGS(NSQAMPSO)
      DATA CHOSEN_SO_CONFIGS/.TRUE./
      SAVE CHOSEN_SO_CONFIGS
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,J,M,N
      COMPLEX*16 ZTEMP
      REAL*8 DENOM(NCOLOR), CF(NCOLOR,NCOLOR)
      COMPLEX*16 AMP(NGRAPHS), JAMP(NCOLOR,NAMPSO)
      COMPLEX*16 W(6,NWAVEFUNCS)
C     Needed for v4 models
      COMPLEX*16 DUM0,DUM1
      DATA DUM0, DUM1/(0D0, 0D0), (1D0, 0D0)/
C     
C     FUNCTION
C     
      INTEGER SQSOINDEX12
C     
C     GLOBAL VARIABLES
C     
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2
      INCLUDE 'coupl.inc'
C     
C     COLOR DATA
C     
      DATA DENOM(1)/1/
      DATA (CF(I,  1),I=  1,  2) /    9,    3/
C     1 T(1,5) T(2,6)
      DATA DENOM(2)/1/
      DATA (CF(I,  2),I=  1,  2) /    3,    9/
C     1 T(1,6) T(2,5)
C     ----------
C     BEGIN CODE
C     ----------
      CALL OXXXXX(P(0,1),ZERO,NHEL(1),-1*IC(1),W(1,1))
      CALL OXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
      CALL IXXXXX(P(0,3),MX1,NHEL(3),-1*IC(3),W(1,3))
      CALL OXXXXX(P(0,4),MX1,NHEL(4),+1*IC(4),W(1,4))
      CALL IXXXXX(P(0,5),ZERO,NHEL(5),-1*IC(5),W(1,5))
      CALL IXXXXX(P(0,6),ZERO,NHEL(6),-1*IC(6),W(1,6))
      CALL JIOXXX(W(1,5),W(1,1),GAU,ZERO,AWIDTH,W(1,7))
      CALL JIOXXX(W(1,6),W(1,2),GAD,ZERO,AWIDTH,W(1,8))
      CALL FVIXXX(W(1,3),W(1,7),GAX,MX1,WX1,W(1,9))
C     Amplitude(s) for diagram number 1
      CALL IOVXXX(W(1,9),W(1,4),W(1,8),GAX,AMP(1))
      CALL FVOXXX(W(1,4),W(1,7),GAX,MX1,WX1,W(1,10))
C     Amplitude(s) for diagram number 2
      CALL IOVXXX(W(1,3),W(1,10),W(1,8),GAX,AMP(2))
      CALL JIOXXX(W(1,6),W(1,2),GZD,ZMASS,ZWIDTH,W(1,11))
C     Amplitude(s) for diagram number 3
      CALL IOVXXX(W(1,9),W(1,4),W(1,11),GZX11,AMP(3))
C     Amplitude(s) for diagram number 4
      CALL IOVXXX(W(1,3),W(1,10),W(1,11),GZX11,AMP(4))
      CALL JIOXXX(W(1,5),W(1,1),GZU,ZMASS,ZWIDTH,W(1,10))
      CALL FVIXXX(W(1,3),W(1,10),GZX11,MX1,WX1,W(1,9))
C     Amplitude(s) for diagram number 5
      CALL IOVXXX(W(1,9),W(1,4),W(1,8),GAX,AMP(5))
      CALL FVOXXX(W(1,4),W(1,10),GZX11,MX1,WX1,W(1,12))
C     Amplitude(s) for diagram number 6
      CALL IOVXXX(W(1,3),W(1,12),W(1,8),GAX,AMP(6))
C     Amplitude(s) for diagram number 7
      CALL IOVXXX(W(1,9),W(1,4),W(1,11),GZX11,AMP(7))
      CALL FVIXXX(W(1,3),W(1,10),GZX12,MX2,WX2,W(1,9))
C     Amplitude(s) for diagram number 8
      CALL IOVXXX(W(1,9),W(1,4),W(1,11),GZX12,AMP(8))
C     Amplitude(s) for diagram number 9
      CALL IOVXXX(W(1,3),W(1,12),W(1,11),GZX11,AMP(9))
      CALL FVOXXX(W(1,4),W(1,10),GZX12,MX2,WX2,W(1,12))
C     Amplitude(s) for diagram number 10
      CALL IOVXXX(W(1,3),W(1,12),W(1,11),GZX12,AMP(10))
      CALL HIOXXX(W(1,3),W(1,4),GH1X11,MH1,WH1,W(1,12))
C     Amplitude(s) for diagram number 11
      CALL VVSXXX(W(1,10),W(1,11),W(1,12),GZZH1,AMP(11))
      CALL HIOXXX(W(1,3),W(1,4),GH2X11,MH2,WH2,W(1,9))
C     Amplitude(s) for diagram number 12
      CALL VVSXXX(W(1,10),W(1,11),W(1,9),GZZH2,AMP(12))
      CALL JIOXXX(W(1,3),W(1,4),GAX,ZERO,AWIDTH,W(1,13))
      CALL FVIXXX(W(1,6),W(1,7),GAD,ZERO,ZERO,W(1,14))
C     Amplitude(s) for diagram number 13
      CALL IOVXXX(W(1,14),W(1,2),W(1,13),GAD,AMP(13))
      CALL FVOXXX(W(1,2),W(1,7),GAD,ZERO,ZERO,W(1,15))
C     Amplitude(s) for diagram number 14
      CALL IOVXXX(W(1,6),W(1,15),W(1,13),GAD,AMP(14))
      CALL JIOXXX(W(1,3),W(1,4),GZX11,ZMASS,ZWIDTH,W(1,7))
C     Amplitude(s) for diagram number 15
      CALL IOVXXX(W(1,14),W(1,2),W(1,7),GZD,AMP(15))
C     Amplitude(s) for diagram number 16
      CALL IOVXXX(W(1,6),W(1,15),W(1,7),GZD,AMP(16))
      CALL FVIXXX(W(1,6),W(1,10),GZD,ZERO,ZERO,W(1,15))
C     Amplitude(s) for diagram number 17
      CALL IOVXXX(W(1,15),W(1,2),W(1,13),GAD,AMP(17))
      CALL FVOXXX(W(1,2),W(1,10),GZD,ZERO,ZERO,W(1,14))
C     Amplitude(s) for diagram number 18
      CALL IOVXXX(W(1,6),W(1,14),W(1,13),GAD,AMP(18))
C     Amplitude(s) for diagram number 19
      CALL IOVXXX(W(1,15),W(1,2),W(1,7),GZD,AMP(19))
C     Amplitude(s) for diagram number 20
      CALL IOVXXX(W(1,6),W(1,14),W(1,7),GZD,AMP(20))
      CALL JIOXXX(W(1,5),W(1,2),GWF,WMASS,WWIDTH,W(1,14))
      CALL JIOXXX(W(1,6),W(1,1),GWF,WMASS,WWIDTH,W(1,15))
      CALL FVIXXX(W(1,3),W(1,14),GWX1N1,MN1,WN1,W(1,10))
C     Amplitude(s) for diagram number 21
      CALL IOVXXX(W(1,10),W(1,4),W(1,15),GWN1X1,AMP(21))
      CALL FVIXXX(W(1,3),W(1,14),GWX1N2,MN2,WN2,W(1,10))
C     Amplitude(s) for diagram number 22
      CALL IOVXXX(W(1,10),W(1,4),W(1,15),GWN2X1,AMP(22))
      CALL FVIXXX(W(1,3),W(1,14),GWX1N3,MN3,WN3,W(1,10))
C     Amplitude(s) for diagram number 23
      CALL IOVXXX(W(1,10),W(1,4),W(1,15),GWN3X1,AMP(23))
      CALL FVIXXX(W(1,3),W(1,14),GWX1N4,MN4,WN4,W(1,10))
C     Amplitude(s) for diagram number 24
      CALL IOVXXX(W(1,10),W(1,4),W(1,15),GWN4X1,AMP(24))
C     Amplitude(s) for diagram number 25
      CALL VVVXXX(W(1,14),W(1,15),W(1,13),GWWA,AMP(25))
C     Amplitude(s) for diagram number 26
      CALL VVVXXX(W(1,14),W(1,15),W(1,7),GWWZ,AMP(26))
C     Amplitude(s) for diagram number 27
      CALL VVSXXX(W(1,14),W(1,15),W(1,12),GWWH1,AMP(27))
C     Amplitude(s) for diagram number 28
      CALL VVSXXX(W(1,14),W(1,15),W(1,9),GWWH2,AMP(28))
      CALL FVIXXX(W(1,6),W(1,14),GWF,ZERO,ZERO,W(1,9))
C     Amplitude(s) for diagram number 29
      CALL IOVXXX(W(1,9),W(1,1),W(1,13),GAU,AMP(29))
      CALL FVOXXX(W(1,1),W(1,14),GWF,ZERO,ZERO,W(1,12))
C     Amplitude(s) for diagram number 30
      CALL IOVXXX(W(1,6),W(1,12),W(1,13),GAD,AMP(30))
C     Amplitude(s) for diagram number 31
      CALL IOVXXX(W(1,9),W(1,1),W(1,7),GZU,AMP(31))
C     Amplitude(s) for diagram number 32
      CALL IOVXXX(W(1,6),W(1,12),W(1,7),GZD,AMP(32))
      CALL FVIXXX(W(1,5),W(1,15),GWF,ZERO,ZERO,W(1,12))
C     Amplitude(s) for diagram number 33
      CALL IOVXXX(W(1,12),W(1,2),W(1,13),GAD,AMP(33))
      CALL FVIXXX(W(1,5),W(1,13),GAU,ZERO,ZERO,W(1,6))
C     Amplitude(s) for diagram number 34
      CALL IOVXXX(W(1,6),W(1,2),W(1,15),GWF,AMP(34))
C     Amplitude(s) for diagram number 35
      CALL IOVXXX(W(1,12),W(1,2),W(1,7),GZD,AMP(35))
      CALL FVIXXX(W(1,5),W(1,7),GZU,ZERO,ZERO,W(1,12))
C     Amplitude(s) for diagram number 36
      CALL IOVXXX(W(1,12),W(1,2),W(1,15),GWF,AMP(36))
      CALL FVIXXX(W(1,5),W(1,8),GAU,ZERO,ZERO,W(1,15))
C     Amplitude(s) for diagram number 37
      CALL IOVXXX(W(1,15),W(1,1),W(1,13),GAU,AMP(37))
C     Amplitude(s) for diagram number 38
      CALL IOVXXX(W(1,6),W(1,1),W(1,8),GAU,AMP(38))
C     Amplitude(s) for diagram number 39
      CALL IOVXXX(W(1,15),W(1,1),W(1,7),GZU,AMP(39))
C     Amplitude(s) for diagram number 40
      CALL IOVXXX(W(1,12),W(1,1),W(1,8),GAU,AMP(40))
      CALL FVIXXX(W(1,5),W(1,11),GZU,ZERO,ZERO,W(1,8))
C     Amplitude(s) for diagram number 41
      CALL IOVXXX(W(1,8),W(1,1),W(1,13),GAU,AMP(41))
C     Amplitude(s) for diagram number 42
      CALL IOVXXX(W(1,6),W(1,1),W(1,11),GZU,AMP(42))
C     Amplitude(s) for diagram number 43
      CALL IOVXXX(W(1,8),W(1,1),W(1,7),GZU,AMP(43))
C     Amplitude(s) for diagram number 44
      CALL IOVXXX(W(1,12),W(1,1),W(1,11),GZU,AMP(44))
C     JAMPs contributing to orders ALL_ORDERS=1
      JAMP(1,1)=-AMP(1)-AMP(2)-AMP(3)-AMP(4)-AMP(5)-AMP(6)-AMP(7)
     $ -AMP(8)-AMP(9)-AMP(10)-AMP(11)-AMP(12)-AMP(13)-AMP(14)-AMP(15)
     $ -AMP(16)-AMP(17)-AMP(18)-AMP(19)-AMP(20)-AMP(37)-AMP(38)-AMP(39)
     $ -AMP(40)-AMP(41)-AMP(42)-AMP(43)-AMP(44)
      JAMP(2,1)=+AMP(21)+AMP(22)+AMP(23)+AMP(24)+AMP(25)+AMP(26)
     $ +AMP(27)+AMP(28)+AMP(29)+AMP(30)+AMP(31)+AMP(32)+AMP(33)+AMP(34)
     $ +AMP(35)+AMP(36)

      MATRIX12 = 0.D0
      DO M = 1, NAMPSO
        DO I = 1, NCOLOR
          ZTEMP = (0.D0,0.D0)
          DO J = 1, NCOLOR
            ZTEMP = ZTEMP + CF(J,I)*JAMP(J,M)
          ENDDO
          DO N = 1, NAMPSO
            IF (CHOSEN_SO_CONFIGS(SQSOINDEX12(M,N))) THEN
              MATRIX12 = MATRIX12 + ZTEMP*DCONJG(JAMP(I,N))/DENOM(I)
            ENDIF
          ENDDO
        ENDDO
      ENDDO

      AMP2(1)=AMP2(1)+AMP(1)*DCONJG(AMP(1))
      AMP2(2)=AMP2(2)+AMP(2)*DCONJG(AMP(2))
      AMP2(3)=AMP2(3)+AMP(3)*DCONJG(AMP(3))
      AMP2(4)=AMP2(4)+AMP(4)*DCONJG(AMP(4))
      AMP2(5)=AMP2(5)+AMP(5)*DCONJG(AMP(5))
      AMP2(6)=AMP2(6)+AMP(6)*DCONJG(AMP(6))
      AMP2(7)=AMP2(7)+AMP(7)*DCONJG(AMP(7))
      AMP2(8)=AMP2(8)+AMP(8)*DCONJG(AMP(8))
      AMP2(9)=AMP2(9)+AMP(9)*DCONJG(AMP(9))
      AMP2(10)=AMP2(10)+AMP(10)*DCONJG(AMP(10))
      AMP2(11)=AMP2(11)+AMP(11)*DCONJG(AMP(11))
      AMP2(12)=AMP2(12)+AMP(12)*DCONJG(AMP(12))
      AMP2(14)=AMP2(14)+AMP(14)*DCONJG(AMP(14))
      AMP2(13)=AMP2(13)+AMP(13)*DCONJG(AMP(13))
      AMP2(16)=AMP2(16)+AMP(16)*DCONJG(AMP(16))
      AMP2(15)=AMP2(15)+AMP(15)*DCONJG(AMP(15))
      AMP2(18)=AMP2(18)+AMP(18)*DCONJG(AMP(18))
      AMP2(17)=AMP2(17)+AMP(17)*DCONJG(AMP(17))
      AMP2(20)=AMP2(20)+AMP(20)*DCONJG(AMP(20))
      AMP2(19)=AMP2(19)+AMP(19)*DCONJG(AMP(19))
      AMP2(38)=AMP2(38)+AMP(38)*DCONJG(AMP(38))
      AMP2(37)=AMP2(37)+AMP(37)*DCONJG(AMP(37))
      AMP2(40)=AMP2(40)+AMP(40)*DCONJG(AMP(40))
      AMP2(39)=AMP2(39)+AMP(39)*DCONJG(AMP(39))
      AMP2(42)=AMP2(42)+AMP(42)*DCONJG(AMP(42))
      AMP2(41)=AMP2(41)+AMP(41)*DCONJG(AMP(41))
      AMP2(44)=AMP2(44)+AMP(44)*DCONJG(AMP(44))
      AMP2(43)=AMP2(43)+AMP(43)*DCONJG(AMP(43))
      AMP2(25)=AMP2(25)+AMP(25)*DCONJG(AMP(25))
      AMP2(26)=AMP2(26)+AMP(26)*DCONJG(AMP(26))
      AMP2(27)=AMP2(27)+AMP(27)*DCONJG(AMP(27))
      AMP2(28)=AMP2(28)+AMP(28)*DCONJG(AMP(28))
      AMP2(34)=AMP2(34)+AMP(34)*DCONJG(AMP(34))
      AMP2(33)=AMP2(33)+AMP(33)*DCONJG(AMP(33))
      AMP2(36)=AMP2(36)+AMP(36)*DCONJG(AMP(36))
      AMP2(35)=AMP2(35)+AMP(35)*DCONJG(AMP(35))
      AMP2(30)=AMP2(30)+AMP(30)*DCONJG(AMP(30))
      AMP2(29)=AMP2(29)+AMP(29)*DCONJG(AMP(29))
      AMP2(32)=AMP2(32)+AMP(32)*DCONJG(AMP(32))
      AMP2(31)=AMP2(31)+AMP(31)*DCONJG(AMP(31))
      AMP2(21)=AMP2(21)+AMP(21)*DCONJG(AMP(21))
      AMP2(22)=AMP2(22)+AMP(22)*DCONJG(AMP(22))
      AMP2(23)=AMP2(23)+AMP(23)*DCONJG(AMP(23))
      AMP2(24)=AMP2(24)+AMP(24)*DCONJG(AMP(24))
      DO I = 1, NCOLOR
        DO M = 1, NAMPSO
          DO N = 1, NAMPSO
            IF (CHOSEN_SO_CONFIGS(SQSOINDEX12(M,N))) THEN
              JAMP2(I)=JAMP2(I)+DABS(DBLE(JAMP(I,M)*DCONJG(JAMP(I,N))))
            ENDIF
          ENDDO
        ENDDO
      ENDDO

      END

C     Set of functions to handle the array indices of the split orders


      INTEGER FUNCTION SQSOINDEX12(ORDERINDEXA, ORDERINDEXB)
C     
C     This functions plays the role of the interference matrix. It can
C      be hardcoded or 
C     made more elegant using hashtables if its execution speed ever
C      becomes a relevant
C     factor. From two split order indices, it return the
C      corresponding index in the squared 
C     order canonical ordering.
C     
C     CONSTANTS
C     

      INTEGER    NSO, NSQUAREDSO, NAMPSO
      PARAMETER (NSO=1, NSQUAREDSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERINDEXA, ORDERINDEXB
C     
C     LOCAL VARIABLES
C     
      INTEGER I, SQORDERS(NSO)
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      DATA (AMPSPLITORDERS(  1,I),I=  1,  1) /    1/
      COMMON/AMPSPLITORDERS12/AMPSPLITORDERS
C     
C     FUNCTION
C     
      INTEGER SOINDEX_FOR_SQUARED_ORDERS12
C     
C     BEGIN CODE
C     
      DO I=1,NSO
        SQORDERS(I)=AMPSPLITORDERS(ORDERINDEXA,I)+AMPSPLITORDERS(ORDERI
     $NDEXB,I)
      ENDDO
      SQSOINDEX12=SOINDEX_FOR_SQUARED_ORDERS12(SQORDERS)
      END

      INTEGER FUNCTION SOINDEX_FOR_SQUARED_ORDERS12(ORDERS)
C     
C     This functions returns the integer index identifying the squared
C      split orders list passed in argument which corresponds to the
C      values of the following list of couplings (and in this order).
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO, NAMPSO
      PARAMETER (NSO=1, NSQSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER SQSPLITORDERS(NSQSO,NSO)
      DATA (SQSPLITORDERS(  1,I),I=  1,  1) /    2/
      COMMON/SQPLITORDERS12/SQPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NSQSO
        DO J=1,NSO
          IF (ORDERS(J).NE.SQSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_SQUARED_ORDERS12 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping in function'
      WRITE(*,*) 'SOINDEX_FOR_SQUARED_ORDERS12'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

      SUBROUTINE GET_NSQSO_BORN12(NSQSO)
C     
C     Simple subroutine returning the number of squared split order
C     contributions returned when calling smatrix_split_orders 
C     

      INTEGER    NSQUAREDSO
      PARAMETER  (NSQUAREDSO=1)

      INTEGER NSQSO

      NSQSO=NSQUAREDSO

      END

C     This is the inverse subroutine of SOINDEX_FOR_SQUARED_ORDERS.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_SQUARED_ORDERS_FOR_SOINDEX12(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the squared
C      split order index in argument. Order values correspond to
C      following list of couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO
      PARAMETER (NSO=1, NSQSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER SQPLITORDERS(NSQSO,NSO)
      COMMON/SQPLITORDERS12/SQPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NSQSO) THEN
        DO I=1,NSO
          ORDERS(I) =  SQPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function GET_SQUARED_ORDERS_FOR_SOIN'
     $ //'DEX12'
      WRITE(*,*) 'Could not find squared orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This is the inverse subroutine of getting amplitude SO orders.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_ORDERS_FOR_AMPSOINDEX12(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the split order
C      index in argument. Order values correspond to following list of
C      couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS12/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NAMPSO) THEN
        DO I=1,NSO
          ORDERS(I) =  AMPSPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function GET_ORDERS_FOR_AMPSOINDEX12'
     $ //''
      WRITE(*,*) 'Could not find amplitude split orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This function is not directly useful, but included for
C      completeness
      INTEGER FUNCTION SOINDEX_FOR_AMPORDERS12(ORDERS)
C     
C     This functions returns the integer index identifying the
C      amplitude split orders passed in argument which correspond to
C      the values of the following list of couplings (and in this
C      order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS12/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NAMPSO
        DO J=1,NSO
          IF (ORDERS(J).NE.AMPSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_AMPORDERS12 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping function SOINDEX_FOR_AMPORDERS12'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

