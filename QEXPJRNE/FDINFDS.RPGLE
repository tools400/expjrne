      /if not defined(fileInfDS_t)
      /define fileInfDS_t
      // =============================================================
      //   File information data structure
      // =============================================================
     d fileInfDS_t     ds                  based(pDummy)   qualified
      // Reserved 01
     d  reserved_01            1      8a
      // Open indication 1=open
     d  isOpen                 9      9a
      // End of file 1=EOF
     d  isEOF                 10     10a
      // Status
     d  status                11     15s 0
      // Operation code, first 5 pos.
     d  opCode                16     20a
      // IO-Type:
      //   F=The last operation was specified for a file name
      //   R=The last operation was specified for a record
      //   I=The last operation was an implicit file operation.
     d  IO_type               21     21a
      // Routine of operation code
     d  routine               22     29a
      // RPG source listing line nbr
     d  srcSeq                30     37a
      // Record format
     d  rcdFormat             38     45a
      // System message number
     d  sysMsgNbr             46     52a
      // Reserved 02
     d  reserved_02           53     66a

      // Valid after post:
      //    Screen size (product of the number of rows
      //    and the number of columns on the device screen).
     d  screenSize            67     70s 0
      //    The display's keyboard type.
      //       00 = alphanumeric or katakana
      //       10 = ideographic
     d  kbdType               71     72s 0
      //    The display type.
      //       00 = alphanumeric or katakana
      //       10 = ideographic
      //       20 = DBCS
     d  displayType           73     74s 0
      //    Always set to 00.
     d  mode                  75     76s 0
      // Reserved_03
     d  reserved_03           77     80a

      // -------------------------------
      //   Open Feedback
      // -------------------------------
     d  openFeedback                       likeds(openFeedback_t)

      // -------------------------------
      //   Input/Output Feedback
      // -------------------------------
     d  IO_feedback                        likeds(IO_feedback_t )

      // -------------------------------
      //   I/O Feedback, File specific
      // -------------------------------
     d  IO_feedback_file...
     d                              256a
      // I/O Feedback Database File
     d  IO_feedback_DB...
     d                                     likeds(IO_feedback_DB_t)
     d                                     overlay(IO_feedback_file)

      // -------------------------------
      //   Open Feedback
      // -------------------------------
     d openFeedback_t...
     d                 ds           160    qualified
      // DS=Display DB=File SP=Spooled File
     d  ODP_type               1      2a
      // File name
     d  file                   3     12a
      // Library
     d  lib                   13     22a
      // Spool file name
     d  spoolFile             23     32a
      // Spool file library
     d  spoolLib              33     42a
      // Spool file number
     d  spoolNbr              43     44i 0
      // Record length
     d  maxRcdLength          45     46i 0
      // Key length
     d  maxKeyLength          47     48i 0
      // Member
     d  mbr                   49     58a
      // Reserved
     d  reserved_01           59     62i 0
      // Reserved
     d  reserved_02           63     66i 0
      // File type
      //     1  =  Display
      //     2  =  Printer
      //     4  =  Diskette
      //     5  =  Tape
      //     9  =  Save
      //    10  =  DDM
      //    11  =  ICF
      //    20  =  Inline data
      //    21  =  Database
     d  fileType              67     68i 0
      // Reserved
     d  reserved_03           69     71a
      // Number of lines on a display screen or       (Display, printer)
      // number of lines on a printed page.
     d  rows                  72     73i 0
      // Length of the null field byte map.           (Database)
     d  lenNullFldMap         72     73i 0
      // Number of positions on a display screen or   (Display, printer)
      // number of characters on a printed line.
     d  columns               74     75i 0
      // Length of the null key field byte map.       (Database)
     d  lenKeyFldMap          74     75i 0
      // Number of records in the member at open
      // at open time.
     d numRcdsAtOpen          76     79i 0
      // Access type
     d accessType             80     81a
      // Duplicate key?
     d isDupKey               82     82a
      // Source file?
     d isSrcFile              83     83a
      // Reserved
     d reserved_04            84     93a
      // Reserved
     d reserved_05            94    103a
      // Offset to volume label fields of open
      // feedback area.
     d ofsVolLblFld          104    105i 0
      // Max rcds in blk
     d maxBlkRcds            106    107i 0
      // Overflow line
     d overflow              108    109i 0
      // Blk increment
     d blkInc                110    111i 0
      // Reserved
     d reserved_06           112    115a
      // Miscellaneous flags
     d flags1                116    116a
      // Requester name
     d requester             117    126a
      // Open count
     d openCount             127    128i 0
      // Reserved
     d reserved_07           129    129a
      // Num based mbrs
     d numBasedMbrs          131    132i 0
      // Miscellaneous flags
     d flags2                133    133a
      // Open identifier
     d openID                134    135a
      // Max rcd fmt length
     d maxRcdFmtLen          136    137i 0
      // Database CCSID
     d CCSID                 138    139i 0
      // Miscellaneous flags
     d flags3                140    140a
      // Reserved
     d reserved_08           141    146a
      // Num devs defined
     d numDevices            147    148i 0

      // -------------------------------
      //   Input/Output Feedback
      // -------------------------------
     d IO_feedback_t...
     d                 ds           126    qualified
      // Offset to file dependant feedback
     d ofsFileDepFB            1      2i 0
      // Write count
     d writeCount              3      6i 0
      // Read count
     d readCount               7     10i 0
      // Write/read count
     d writeReadCount         11     14i 0
      // Other I/O count
     d otherCount             15     18i 0
      // Reserved
     d reserved_01            19     19a
      // Current operation
      //   hex 01 =  Read or read block or read from invited devices
      //   hex 02 =  Read direct
      //   hex 03 =  Read by key
      //   hex 05 =  Write or write block
      //   hex 06 =  Write-read
      //   hex 07 =  Update
      //   hex 08 =  Delete
      //   hex 09 =  Force-end-of-data
      //   hex 0A =  Force-end-of-volume
      //   hex 0D =  Release record lock
      //   hex 0E =  Change end-of-data
      //   hex 0F =  Put deleted record
      //   hex 11 =  Release device
      //   hex 12 =  Acquire device
     d operation              20     20a
      // Rcd format name
     d IO_rcdFmt              21     30a
      // Device class
     d deviceClass            31     32a
      // Pgm device name
     d IO_pgmDevice           33     42a
      // Rcd len of I/O
     d IO_rcdLength           43     46i 0
      // Reserved
     d reserved_02            47    126a

      // -------------------------------
      //   I/O Feedback Database File
      // -------------------------------
     d IO_feedback_DB_t...
     d                 ds                  qualified
      // Number of locked records
     d  numLckRcds            11     12i 0
      // Maximum number of fields
     d  maxNumFlds            13     14i 0
      // Nbr of key fields
     d  nbrOfKeyFlds          21     22i 0
      // Key length
     d  keyLength             27     28i 0
      // Data member number.
     d  dtaMbrNum             29     30i 0
      // Relative record number in data member.
     d  rcdNbr                31     34u 0

      /endif
