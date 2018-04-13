      /if not defined(CEELIB)
      /define CEELIB

      // --------------------------------------------------------------
      //  Program or Procedure Call APIs
      // --------------------------------------------------------------

      // Retrieve Operational Descriptor Information (CEEDOD)
     d CEEDOD...
     d                 pr
     d                                            extproc('CEEDOD')
     d  i_posn                       10i 0 const
     d  o_desctype                   10i 0
     d  o_datatype                   10i 0
     d  o_descinf1                   10i 0
     d  o_descinf2                   10i 0
     d  o_datalen                    10i 0
     d  o_fc                         12a          options(*omit   )

      // Reference fields for CEEDOD API
     d descInf_t       ds                  based(pDummy)   qualified
     d  desctype                     10i 0
     d  datatype                     10i 0
     d  descinf1                     10i 0
     d  descinf2                     10i 0
     d  datalen                      10i 0

      // Test for Omitted Argument (CEETSTA) API
     d CEETSTA...
     d                 pr
     d                                            extproc('CEETSTA')
     d  io_isPresent                 10i 0
     d  i_argNum                     10i 0 const
     d  o_fc                         12a          options(*omit   )

      // Get String Information (CEEGSI) API
     d CEEGSI...
     d                 pr
     d                                            extproc('CEEGSI')
     d  i_posn                       10i 0 const
     d  o_datatype                   10i 0
     d  o_curlen                     10i 0
     d  o_maxlen                     10i 0
     d  o_fb                         12a          options(*omit   )

      // Reference fields for CEEGSI API
     d strInf_t        ds                  based(pDummy)   qualified
     d  datatype                     10i 0
     d  curlen                       10i 0
     d  maxlen                       10i 0

      // --------------------------------------------------------------
      //  Math APIs
      // --------------------------------------------------------------

      // Logarithm base 10 (double float)
     d CEESDLG1...
     d                 pr                  extproc('CEESDLG1')
     d  i_value                       8f   const
     d  o_result                      8f

      // --------------------------------------------------------------
      //  ILE CEE Date and Time APIs
      // --------------------------------------------------------------

      // Calculate Day of Week from Lilian Date (CEEDYWK) API
     d CEEDYWK         pr                  opdesc extproc('CEEDYWK')
     d   lilian_date                 10i 0 const
     d   day_no                      10i 0
     d   feedback                    12a   options(*omit)

      // Convert Lilian Date to Character Format (CEEDATE) API
     d CEEDATE         pr                  opdesc extproc('CEEDATE')
     d   lilian_date                 10i 0 const
     d   date_format                 80a   const options(*varsize)
     d   char_date                   80a   options(*varsize)
     d   feedback                    12a   options(*omit)

      // Convert Date to Lilian Format (CEEDAYS) API
     d CEEDAYS         pr                  opdesc extproc('CEEDAYS')
     d   char_date                   80a   const options(*varsize)
     d   date_format                 80a   const options(*varsize)
     d   lilian_date                 10i 0
     d   feedback                    12a   options(*omit)

      // --------------------------------------------------------------
      //  Activation Group and Control Flow APIs
      // --------------------------------------------------------------

      // Register Activation Group Exit Procedure (CEE4RAGE) API
     d CEE4RAGE...
     d                 pr                  extproc('CEE4RAGE')
     d  i_pProc                        *   const procptr
     d   fc                          12a         options(*OMIT)

     d END_ACTGRP_CODE_EXCEPTION_MESSAGE...
     d                 C                   x'40000000'
     d END_ACTGRP_CODE_ABNORMAL_END...
     d                 C                   x'00008000'
     d END_ACTGRP_CODE_ACTGRP_IS_ENDING...
     d                 C                   x'00004000'
     d END_ACTGRP_CODE_INIT_BY_RCLACTGRP...
     d                 C                   x'00002000'
     d END_ACTGRP_CODE_INIT_BY_JOB_END...
     d                 C                   x'00001000'
     d END_ACTGRP_CODE_INIT_BY_EXIT_VERB...
     d                 C                   x'00000800'
     d END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK...
     d                 C                   x'00000400'
     d END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP...
     d                 C                   x'00000200'

      // Register Call Stack Entry Termination User Exit Procedure (CEERTX)
     d CEERTX...
     d                 pr                         extproc('CEERTX')
     d  i_procPtr                      *   const  procptr
     d  i_rtxToken                     *   const  options(*omit)
     d  o_fc                         12a          options(*omit)

     D CEERTX_user_exit...
     D                 pr                         extproc('CEERTX_user_exit')
     D  i_rtxToken                     *   const

      // Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
     d CEEUTX...
     d                 pr                         extproc('CEEUTX')
     d  i_procPtr                      *   const  procptr
     d  o_fc                         12a          options(*omit)

      /endif
