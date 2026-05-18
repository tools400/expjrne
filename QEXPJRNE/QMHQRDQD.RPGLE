**free
/if not defined(QMHQRDQD)
/define QMHQRDQD

// Retrieve Data Queue Description (QMHQRDQD) API
dcl-pr QMHQRDQD extpgm('QMHQRDQD');
  o_rcvVar    char(65535) options(*varsize);
  i_lenRcvVar int(10) const;
  i_format    char(8) const;
  i_qDtaQ     char(20) const;
end-pr;

// RDQD0100 Format
dcl-ds RDQD0100_t qualified based(pDummy);
  bytRet      int(10);
  bytAvl      int(10);
  msgLength   int(10);
  keyLength   int(10);
  sequence    char(1);
  inclSndID   char(1);
  forceInd    char(1);
  text        char(50);
  typeDtaQ    char(1);
  autoReclaim char(1);
  reserved_1  char(1);
  numMsg      int(10);
  numAllocE   int(10);
  dtaQ_name   char(10);
  dtaQ_lib    char(10);
  maxNumEAlw  int(10);
  initNumE    int(10);
  maxNumESpc  int(10);
end-ds;

// RDQD0200 Format
dcl-ds RDQD0200_t qualified based(pDummy);
  bytRet       int(10);
  bytAvl       int(10);
  appcDevD     char(10);
  mode         char(8);
  rmtLocName   char(8);
  lclLocName   char(8);
  rmtNetID     char(8);
  rmtDtaQ_name char(10);
  rmtDtaQ_lib  char(10);
  dtaQ_name    char(10);
  dtaQ_lib     char(10);
  rdbName      char(18);
end-ds;

/endif
