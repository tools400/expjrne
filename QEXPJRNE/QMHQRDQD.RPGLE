      /if not defined(QMHQRDQD)
      /define QMHQRDQD

      // Retrieve Data Queue Description (QMHQRDQD) API
     d QMHQRDQD...
     d                 pr                  extpgm('QMHQRDQD')
     d  o_rcvVar                  65535a          options(*varsize)
     d  i_lenRcvVar                  10i 0 const
     d  i_format                      8a   const
     d  i_qDtaQ                      20a   const

      // RDQD0100 Format
     d RDQD0100_t      ds                  qualified               based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  msgLength                    10i 0
     d  keyLength                    10i 0
     d  sequence                      1a
     d  inclSndID                     1a
     d  forceInd                      1a
     d  text                         50a
     d  typeDtaQ                      1a
     d  autoReclaim                   1a
     d  reserved_1                    1a
     d  numMsg                       10i 0
     d  numAllocE                    10i 0
     d  dtaQ_name                    10a
     d  dtaQ_lib                     10a
     d  maxNumEAlw                   10i 0
     d  initNumE                     10i 0
     d  maxNumESpc                   10i 0

      // RDQD0200 Format
     d RDQD0200_t      ds                  qualified               based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  appcDevD                     10a
     d  mode                          8a
     d  rmtLocName                    8a
     d  lclLocName                    8a
     d  rmtNetID                      8a
     d  rmtDtaQ_name                 10a
     d  rmtDtaQ_lib                  10a
     d  dtaQ_name                    10a
     d  dtaQ_lib                     10a
     d  rdbName                      18a

      /ENDIF
