     h debug
     h option(*SRCSTMT : *NODEBUGIO)
      /if not defined(NO_DECEDIT)
     h DECEDIT('0,')
      /endif
     h datedit(*DMY.)
     h datfmt(*ISO )
     h timfmt(*ISO )
     h expropts(*RESDECPOS)
     h extbinint(*YES)
      /copy QEXPJRNE,COPYRIGHT
