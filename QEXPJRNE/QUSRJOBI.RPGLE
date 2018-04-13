      /if not defined(QUSRJOBI)
      /define QUSRJOBI

      // Retrieve Job Information (QUSRJOBI) API
     d QUSRJOBI...
     d                 pr                  extpgm('QUSRJOBI')
     d  o_rcvVar                  65535a          options(*varsize)
     d  i_rcvVarLen                  10i 0 const
     d  i_format                      8a   const
     d  i_qJob                       26a   const
     d  i_intJobID                   16a   const
     d  io_errCode                65535a          options(*nopass: *varsize)    OptGrp 1
     d  i_resPrfStat                  1a   const  options(*nopass)              OptGrp 2

     d jobi0100_t...
     d                 ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  reserved_1                    2a
     d  runPty                       10i 0
     d  timeSlice                    10i 0
     d  dftWait                      10i 0
     d  purge                        10a

     d jobi0200_t...
     d                 ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  sbsDName                     10a
     d  runPty                       10i 0
     d  sysPoolID                    10i 0
     d  prcTimeUsd                   10i 0
     d  numAuxIORq                   10i 0
     d  numIntTact                   10i 0
     d  rspTimeTot                   10i 0
     d  fncType                       1a
     d  fncName                      10a
     d  actJobSts                     4a
     d  numDBLckW                    10i 0
     d  numIntLckW                   10i 0
     d  numNonDBLckW                 10i 0
     d  timeDBLckW                   10i 0
     d  timeIntLckW                  10i 0
     d  timeNonDBLckW                10i 0
     d  reserved_01                   1a
     d  currSysPoolID                10i 0
     d  thrdCount                    10i 0
     d  prcUntTmUsd                  20u 0
     d  numAuxIORqLng                20u 0
     d  prcUntTmUsdDB                20u 0
     d  pageFaults                   20u 0
     d  actJobStsJobEnd...
     d                                4a
     d  memPoolName                  10a
     d  msgRply                       1a

     d jobi0400_t...
     d                 ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  dateTimeEnt                  13a
     d  dateTimeAct                  13a
     d  jobAcctCode                  15a
     d  jobD                         10a
     d  jobDLib                      10a
     d  unitOfWorkID                 24a
     d  mode                          8a
     d  inqMsgRply                   10a
     d  logCLPgms                    10a
     d  brkMsgHdl                    10a
     d  stsMsgHdl                    10a
     d  devRcvrAct                   13a
     d  ddmCnvHdl                    10a
     d  dateSep                       1a
     d  dateFmt                       4a
     d  prtText                      30a
     d  sbmJob                       10a
     d  sbmUser                      10a
     d  sbmNbr                        6a
     d  sbmMsgQ                      10a
     d  sbmMsgQLib                   10a
     d  timeSep                       1a
     d  ccsid                        10i 0
     d  dateTimeScd                   8a
     d  prtKeyFmt                    10a
     d  sortSeq                      10a
     d  sortSeqLib                   10a
     d  langID                        3a
     d  countryID                     2a
     d  complSts                      1a
     d  signedOnJob                   1a
     d  jobSws                        8a
     d  msgQFullAct                  10a
     d  reserved_01                   1a
     d  msgQMaxSize                  10i 0
     d  dftCcsid                     10i 0
     d  rtgData                      80a
     d  decFmt                        1a
     d  chrIDCtrl                    10a
     d  serverType                   30a
     d  alwMltThrds                   1a
     d  jobLogPnd                     1a
     d  reserved_02                   1a
     d  jobEndRsn                    10i 0
     d  jobTypeEnhncd                10i 0
     d  dateTimeEnd                  13a
     d  reserved_03                   1a
     d  splFActn                     10a
     d  ofsAspGrpInf                 10i 0
     d  numEAspGrpInf                10i 0
     d  lenAspGrpInfE                10i 0
     d  timeZoneDscNm                10a
     d  jobLogOutput                 10a

     d jobi0600_t...
     d                 ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  jobSws                        8a
     d  endStatus                     1a
     d  sbsD                         10a
     d  sbsDLib                      10a
     d  curUser                      10a
     d  dbcs                          1a
     d  exitKey                       1a
     d  cancelKey                     1a
     d  prdRetCode                   10i 0
     d  userRetCode                  10i 0
     d  pgmretCode                   10i 0
     d  spcEnv                       10a
     d  device                       10a
     d  grpPrf                       10a
     d  grpPrfAry                    10a   dim(15)
     d  jobUsrID                     10a
     d  jobUsrIDStg                   1a

     d jobi0700_t...
     d                 ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  reserved_1                    2a
     d  numSysLibE                   10i 0
     d  numPrdLibE                   10i 0
     d  numCurLibE                   10i 0
     d  numUsrLibE                   10i 0

      /endif
