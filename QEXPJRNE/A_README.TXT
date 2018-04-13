EXPJRNE - A Tools/400 Service Program
-------------------------------------

EXPJRNE is a utility for exporting journal entries from a journal to
an output file. The utility creates the output file with the meta
data fields of the journal entry and the original fields of the 
journaled file. That makes it is easy to analyze the exported data.

Dependencies: BASICS1, RTVFLDA

Compile members with the following PDM option:                                                     
                                                                          
   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO) 
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)          
     USER1(*LIST) USER2(*FULL)                                            

Members of type MAKPGM or BND are used for linking programs (MAKPGM) 
and service programs (BND).

2018, Thomas Raddatz