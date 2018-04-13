      /if not defined(objd0400_t)
      /define objd0400_t
      // =============================================================
      //   QUSROBJD API - OBJD0400
      // =============================================================

     D objd0400_t      ds                  qualified           based(pDummy)
      // OBJD0100 ...
     D  bytRet                       10i 0
     D  bytAvl                       10i 0
     D  name                         10a
     D  lib                          10a
     D  type                         10a
     D  rtnLib                       10a
     D  auxStgP                      10i 0
     D  owner                        10a
     D  domain                        2a
     D  crtDatTim                    13a
     D  chgDatTim                    13a
      // OBJD0200 ...
     D  extObjAtr                    10a
     D  text                         50a
     D  srcFile                      10a
     D  srcLib                       10a
     D  srcMbr                       10a
      // OBJD0300 ...
     D  srcFDatTim                   13a
     D  savDatTim                    13a
     D  rstDatTim                    13a
     D  crtUsrPrf                    10a
     D  crtSys                        8a
     D  resDat                        7a
     D  savSize                      10i 0
     D  savSeqNbr                    10i 0
     D  stg                          10a
     D  savCmd                       10a
     D  savVolID                     71a
     D  savDev                       10a
     D  savFName                     10a
     D  savFLibName                  10a
     D  savLbl                       17a
     D  sysLvl                        9a
     D  compiler                     16a
     D  objLvl                        8a
     D  usrChg                        1a
     D  licPgm                       16a
     D  ptf                          10a
     D  apar                         10a
      // OBJD0400 ...
     D  lastUseDat                    7a
     D  useInfUpd                     1a
     D  daysUseCnt                   10i 0
     D  objSize                      10i 0
     D  objSizeMlt                   10i 0
     D  objCmpSts                     1a
     D  alwChgPgm                     1a
     D  chgByPgm                      1a
     D  usrDfnAtr                    10a
     D  aspOflw                       1a
     D  savActDatTim                 13a
     D  objAudVal                    10a
     D  priGrp                       10a
     D  jrnStat                       1a
     D  jrnName                      10a
     D  jrnLibName                   10a
     D  jrnImages                     1a
     D  jrnOmitE                      1a
     D  jrnStrDatTim                 13a
     D  dgtSigned                     1a
     D  savSizeUnits                 10i 0
     D  savSizeMlt                   10i 0
     D  libASPNbr                    10i 0
     D  objASPDev                    10a
     D  libASPDev                    10a
     D  dgtSignedTrst                 1a
     D  dgtSignedMult                 1a
     D  reserved_1                    2a
     D  priAscSpcSize                10i 0
     D  optSpcAlgn                    1a
     D  objASPGrp                    10a
     D  libASPGrp                    10a
     D  strJrnRcv                    10a
     D  strJrnRcvLib                 10a
     D  strJrnRcvLibASPDev...
     D                               10a
     D  strJrnRcvLibASPGrp...
     D                               10a
     D  reserved_2                    1a

      /endif
