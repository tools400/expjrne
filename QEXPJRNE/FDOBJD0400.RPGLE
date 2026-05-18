**free
/if not defined(objd0400_t)
/define objd0400_t
// =============================================================
//   QUSROBJD API - OBJD0400
// =============================================================

dcl-ds objd0400_t qualified based(pDummy);
  // OBJD0100 ...
  bytRet             int(10);
  bytAvl             int(10);
  name               char(10);
  lib                char(10);
  type               char(10);
  rtnLib             char(10);
  auxStgP            int(10);
  owner              char(10);
  domain             char(2);
  crtDatTim          char(13);
  chgDatTim          char(13);
  // OBJD0200 ...
  extObjAtr          char(10);
  text               char(50);
  srcFile            char(10);
  srcLib             char(10);
  srcMbr             char(10);
  // OBJD0300 ...
  srcFDatTim         char(13);
  savDatTim          char(13);
  rstDatTim          char(13);
  crtUsrPrf          char(10);
  crtSys             char(8);
  resDat             char(7);
  savSize            int(10);
  savSeqNbr          int(10);
  stg                char(10);
  savCmd             char(10);
  savVolID           char(71);
  savDev             char(10);
  savFName           char(10);
  savFLibName        char(10);
  savLbl             char(17);
  sysLvl             char(9);
  compiler           char(16);
  objLvl             char(8);
  usrChg             char(1);
  licPgm             char(16);
  ptf                char(10);
  apar               char(10);
  // OBJD0400 ...
  lastUseDat         char(7);
  useInfUpd          char(1);
  daysUseCnt         int(10);
  objSize            int(10);
  objSizeMlt         int(10);
  objCmpSts          char(1);
  alwChgPgm          char(1);
  chgByPgm           char(1);
  usrDfnAtr          char(10);
  aspOflw            char(1);
  savActDatTim       char(13);
  objAudVal          char(10);
  priGrp             char(10);
  jrnStat            char(1);
  jrnName            char(10);
  jrnLibName         char(10);
  jrnImages          char(1);
  jrnOmitE           char(1);
  jrnStrDatTim       char(13);
  dgtSigned          char(1);
  savSizeUnits       int(10);
  savSizeMlt         int(10);
  libASPNbr          int(10);
  objASPDev          char(10);
  libASPDev          char(10);
  dgtSignedTrst      char(1);
  dgtSignedMult      char(1);
  reserved_1         char(2);
  priAscSpcSize      int(10);
  optSpcAlgn         char(1);
  objASPGrp          char(10);
  libASPGrp          char(10);
  strJrnRcv          char(10);
  strJrnRcvLib       char(10);
  strJrnRcvLibASPDev char(10);
  strJrnRcvLibASPGrp char(10);
  reserved_2         char(1);
end-ds;

/endif
