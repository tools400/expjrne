      /if not defined(CLIB2)
      /define CLIB2

      // File open feedback data structure
     d RFILE_t         ds                  based(pDummy)         qualified
     d  res01                        16a
     d  pInBuf                         *
     d  pOutBuf                        *
     d  res02                        48a
      /if not defined(*V5R3M0)
     d  riofb                              like(RIOFB_t)
      /else
     d  riofb                              likeds(RIOFB_t)
      /endif
     d  res03                        32a
     d  bufLen                       10u 0
     d  res04                        28a
     d  pInNull                        *
     d  pOutNul                        *
     d  pKeyNul                        *
     d  res05                        48a
     d  minLen                       10i 0
     d  nMapLen                       5i 0
     d  nKeyLen                       5i 0
     d  res06                         8a

      // Record IO feedback data structure
     d RIOFB_t         ds                  based(pDummy)  align  qualified
     d  pKey                           *
     d  pSysP                          *
     d  rrn                          10u 0
     d  numByt                       10i 0
     d  blkCnt                        5i 0
     d  blkFld                        1a
     d  bitfld                        1a
     d   dupKy                        1a   overlay(bitfld: 1)
     d   icfLc                        1a   overlay(bitfld: 1)
     d   res01                        1a   overlay(bitfld: 1)
     d  res02                        20a

      // Constants used by IO feedback procedures
     d RRN_EQ          c                   x'08000300'

     d KEY_EQ          c                   x'0B000100'
     d KEY_GT          c                   x'0D000100'
     d KEY_LT          c                   x'09000100'
     d KEY_LE          c                   x'0A000100'
     d KEY_GE          c                   x'0C000100'
     d KEY_NEXTUNQ     c                   x'05000100'
     d KEY_PREVUNQ     c                   x'06000100'
     d KEY_NEXTEQ      c                   x'0E000100'
     d KEY_PREVEQ      c                   x'0F000100'

     d FIRST           c                   x'01000300'
     d LAST            c                   x'02000300'
     d NEXT            c                   x'03000300'
     d PREVIOUS        c                   x'04000300'

     d START_FRC       c                   x'03000004'
     d START           c                   x'01000004'
     d END_FRC         c                   x'04000004'
     d END             c                   x'02000004'

     d NO_LOCK         c                   x'00000001'
     d DFT             c                   x'0B000100'
     d NO_POSITION     c                   x'00100000'
     d PRIOR           c                   x'00001000'
     d DATA_ONLY       c                   x'00000002'
     d NULL_KEY_MAP    c                   x'00000008'

     d EOF             c                   -1

      // _Ropen -- Open a Record File for I/O Operatins                                      R
      //   #include <recio.h>
      //   _RFILE *_Ropen(const char * filename, const char * mode, ...);
     d Ropen           pr              *          extproc('_Ropen')             _RFILE
     d  i_fileName                     *   value  options(*string)
     d  i_mode                         *   value  options(*string)

      // _Rclose -- Close a File
      //   #include <recio.h>
      //   int _Rclose(_RFILE *fp);
     d Rclose          pr            10i 0        extproc('_Rclose')
     d  i_fp                           *   value

      // _Rlocate -- Position to a Record
      //   #include <recio.h>
      //   _RIOFB_T *_Rlocate(_RFILE *fp, void *key, int klen_rrn, int opts);
     d Rlocate         pr              *          extproc('_Rlocate')           _RIOFB_T
     d  i_fp                           *   value
     d  i_key                          *   value
     d  i_klen_rrn                   10i 0 value
     d  i_opts                       10i 0 value

      // _Rreadd -- Read a Record by Relative Record Number
      //   #include <recio.h>
      //   _RIOFB_T *_Rreadd (_RFILE *fp, void *buf, size_t size,
      //                               int opts, long rrn);
     d Rreadd          pr              *          extproc('_Rreadd')            _RIOFB_T
     d  i_fp                           *   value
     d  i_pBuffer                      *   value
     d  i_size                       10u 0 value
     d  i_opts                       10i 0 value
     d  i_rrn                        10i 0 value

      // _Rreadn -- Read the next Record
      //   #include <recio.h>
      //   _RIOFB_T *_Rreadn (_RFILE *fp, void *buf, size_t size, int opts);
     d Rreadn          pr              *          extproc('_Rreadn')            _RIOFB_T
     d  i_fp                           *   value
     d  i_pBuffer                      *   value
     d  i_size                       10u 0 value
     d  i_opts                       10i 0 value

      // _Rreadk -- Read a Record by Key
      //   #include <recio.h>
      //   _RIOFB_T *_Rreadk(_RFILE *fp, void *buf, size_t size,
      //                      int opts, void *key, unsigned int keylen);
     d Rreadk          pr              *          extproc('_Rreadk')            _RIOFB_T
     d  i_fp                           *   value
     d  i_pBuffer                      *   value
     d  i_size                       10u 0 value
     d  i_opts                       10i 0 value
     d  i_key                          *   value
     d  i_klen                       10i 0 value

      // _Rreads -- Read the Same Record
      //   #include <recio.h>
      //   _RIOFB_T *_Rreads(_RFILE *fp, void *buf, size_t size, int opts);
     d Rreads          pr              *          extproc('_Rreads')            _RIOFB_T
     d  i_fp                           *   value
     d  i_pBuffer                      *   value
     d  i_size                       10u 0 value
     d  i_opts                       10i 0 value

      // _Rrlslck -- Release a Record Lock
      //   #include <recio.h>
      //   int _Rrlslck(_RFILE *fp);
     d RrlsLck         pr              *          extproc('_Rrlslck')           int 1=success
     d  i_fp                           *   value                                    0=error

      // _Rupdate -- Update a Record
      //   #include <recio.h>
      //   _RIOFB_T *_Rupdate(_RFILE *fp, void *buf, size_t size);
     d Rupdate         pr              *          extproc('_Rupdate')           _RIOFB_T
     d  i_fp                           *   value
      /if defined(RUPDATE_OPTIONS_STRING)
     d  i_pBuffer                      *   value  options(*string)
      /else
     d  i_pBuffer                      *   value
      /endif
     d  i_size                       10u 0 value

      // _Rwrite -- Write the next record
      //   #include <recio.h>
      //   _RIOFB_T * _Rwrite(_RFILE *fp, void *buf, size_t size);
     d Rwrite          PR              *          extproc('_Rwrite')            _RIOFB_T
     d  i_fp                           *   value
      /if defined(RWRITE_OPTIONS_STRING)
     d  i_pBuffer                      *   value  options(*string)
      /else
     d  i_pBuffer                      *   value
      /endif
     d  i_size                       10u 0 value

      // _Rwrited -- Write a Record Directly
      //   #include <recio.h>
      //   _RIOFB_T *_Rwrited(_RFILE *fp, void *buf, size_t size, unsigned long rrn);
     d Rwrited         PR              *          extproc('_Rwrited')           _RIOFB_T
     d  i_fp                           *   value
      /if defined(RWRITE_OPTIONS_STRING)
     d  i_pBuffer                      *   value  options(*string)
      /else
     d  i_pBuffer                      *   value
      /endif
     d  i_size                       10u 0 value
     d  i_rrn                        10u 0 value

      // _Rformat -- Set the Record Format Name
      //   #include <recio.h>
      //   void  _Rformat(_RFILE *fp, char *fmt);
     d Rformat         pr                         extproc('_Rformat')           void
     d  i_handle                       *   value
     d  i_format                       *   value  options(*string)

      /endif
