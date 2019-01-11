      /IF NOT DEFINED(EXPJRNE_PROTOTYPE)
      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER5                                          *
      *  Description . : Export Journal Entries - DDS                       *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 10.08.2007                                         *
      *                                                                     *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Date        Name          Comment                                  *
      *  ----------  ------------  ---------------------------------------  *
      *  10.10.2007  Th.Raddatz    Now renaming field/record format name    *
      *                            if the name contains invalid chracaters. *
      *                            '.' is changed to '_'.                   *
      *                                                                     *
      *  19.09.2008  Th.Raddatz    Fix problem when writing long keywords   *
      *                            to source member.                        *
      *                                                                     *
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
      *                            Fixed problem with VARLEN fields.        *
      *                            Actually the problem was caused by       *
      *                            service program RTVFLDA because it did   *
      *                            not correctly set the 'length' field.    *
      *                            EXPJRNE now requires RTVFLDA V1.5!       *
      *                                                                     *
      *  12.08.2009  Th.Raddatz    Added 'CCSID(xxxxx)' keyword.            *
      *                                                                     *
      *  19.08.2009  Th.Raddatz    Fixed problem that CCSID clause was      *
      *                            incorrectly added to DATE, TIME and      *
      *                            TIMESTAMP fields.                        *
      *                                                                     *
      *  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
      *                                                                     *
      *  04.10.2018  Th.Raddatz    Fixed external procedure name (typo).    *
      *                                                                     *
      *=====================================================================*
      * >>PRE-COMPILER<<                                                    *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
      *                           SRCFILE(&SL/&SF) +                        *
      *                           SRCMBR(&SM);                              *
      *   >>IMPORTANT<<                                                     *
      *     >>PARM<< TRUNCNBR(*NO);                                         *
      *     >>PARM<< DBGVIEW(*LIST);                                        *
      *     >>PARM<< TGTRLS(V6R1M0);                                        *
      *   >>END-IMPORTANT<<                                                 *
      *   >>EXECUTE<<                                                       *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
     H NOMAIN
      /COPY QEXPJRNE,H_SPEC
      *=====================================================================*
      /ENDIF
     FSRCFILE   IF A F  112        disk    usropn
     F                                     extfile(g_srcFile)
     F                                     extmbr(g_srcMbr)
      *
     D g_srcFile       S             21A   inz
     D g_srcMbr        S             10A   inz
      *
     D f_crtOutfile_DDS...
     D                 PR              N
     D                                     extproc('EXPJRNER5_+
     D                                     f_crtOutfile_DDS+
     D                                     ')
     D  i_tplFile                    10A   const
     D  i_tplLib                     10A   const
     D  i_outFile                    10A   const
     D  i_outLib                     10A   const
     D  i_outFilFmt                  10A   const
      *
      /IF DEFINED(EXPJRNE_PROTOTYPE)
      /EOF
      /ENDIF
      *
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library
      /COPY QEXPJRNE,CEELIB                        CEE APIs
      /COPY QEXPJRNE,SQL                           Embedded SQL type definitions and const.
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER6                     Tool: EXPJRNE SQL Call Level Interface
      /COPY QEXPJRNE,EXPJRNER7                     Tool: EXPJRNE Utilities
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
      *  typedefs
     D srcLine_t       DS                  qualified          based(pDummy)
     D  seq                           6S 2
     D  date                          6S 0
     D  data                        100A
      *
     D rcdFmt_t        DS                  qualified          based(pDummy)
     D  spec                   1      6A
     D  type                  17     17A
     D  name                  19     28A
      *
     D fldDef_t        DS                  qualified          based(pDummy)
     D  spec                   1      6A
     D  name                  19     28A
     D  length                30     34S 0
     D  type                  35     35A
     D  decPos                36     37S 0
      *
     D kwd_t           DS                  qualified          based(pDummy)
     D  spec                   1      6A
     D  value                 45     80A
      *
      *  Constants
      *  ... double quotes
     D cSINGLE_QUOTE   C                   const('''')
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Internal prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      *  Adds the record format definition to the source file member.
     D addRecordFormat...
     D                 PR              N   extproc('addRecordFormat')
     D  i_format                     10A   const
     D  i_fileCcsid                  10U 0 const
     D  o_msg                              const  likeds(msg_t )
      *
      *  Adds the fields of the record format to the source file member.
     D addFields...
     D                 PR              N   extproc('addFields')
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_fileCcsid                  10U 0 const
      *
      *  Adds a keyword to the source file member.
     D addKeyword...
     D                 PR              N   extproc('addKeyword')
     D  i_kwd                       256A   value  varying
      *
      *  Returns a file level CCSID if all character fields have the
      *  same CCSID.
     D getFileCcsid...
     D                 PR            10U 0 extproc('getFileCcsid')
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Create temporary source physical file.
     D crtSrcFile...
     D                 PR              N   extproc('crtSrcFile')
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_mbr                        10A   const
     D  i_text                       50A   const
      *
      *  Deletes a given physical file.
     D dltFile...
     D                 PR              N   extproc('dltFile')
     D  i_file                       10A   const
     D  i_lib                        10A   const
      *
     D p_abnEndProc...
     D                 PR                  extproc('p_abnEndProc')
     D  i_pRtxToken                    *   const
      *
     D RtxToken_t      DS                  qualified               based(pDummy)
     D  hList                              like(BasicList_handle_t )
     D  srcFile                            likeds(qObj_t   )
     D  srcMbr                       10A
      *
      *=====================================================================*
      *  Create outfile
      *=====================================================================*
      *
     P f_crtOutfile_DDS...
     P                 B                   export
     D                 PI              N
     D  i_tplFile                    10A   const
     D  i_tplLib                     10A   const
     D  i_outFile                    10A   const
     D  i_outLib                     10A   const
     D  i_outFilFmt                  10A   const
      *
      *  return value
     D isOK            S               N   inz(cFalse)
      *
      *  fields
     D x               S             10I 0 inz
     D tplFile         DS                  likeds(qObj_t    ) inz
     D fldAttr         DS                  likeds(fldAttr_t ) based(pFldAttr)
     D fileCcsid       S             10U 0 inz
      *
     D text            S             52A   inz
     D msg             DS                  likeds(msg_t)
      *
     D rtxToken        DS                  likeds(rtxToken_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear rtxToken;

         // Register abnormal end procedure
         CEERTX(%paddr('p_abnEndProc'): %addr(rtxToken): *omit);

         dou '1';

            // Create temporary source physical file
            Message_sendStatusMsg('USR0101');

            msg = f_newMsg('TXT0001');
            text = f_addQuotes(%trim(f_rtvMsgText(msg)): cSINGLE_QUOTE);

            rtxToken.srcFile = f_getTmpName();
            rtxToken.srcMbr  = rtxToken.srcFile;

            if (not crtSrcFile(rtxToken.srcFile.name
                               : rtxToken.srcFile.lib
                               : rtxToken.srcMbr
                               : text));
               isOK = cFalse;
               leave;
            endif;

            // Retrieve Outfile Record Format
            Message_sendStatusMsg('USR0102');

            // Produce field list ...
            rtxToken.hList = BasicList_new('*COLUMNS': 256);

            tplFile.name = i_tplFile;
            tplFile.lib  = i_tplLib;
            getOutputFileColumns(rtxToken.hList: i_outFilFmt: tplFile);

            g_srcFile = %trim(rtxToken.srcFile.lib ) + '/' +
                        %trim(rtxToken.srcFile.name);
            g_srcMbr = rtxToken.srcMbr;

            // Produce DDS source code:
            open SRCFILE;

            fileCcsid = getFileCcsid(rtxToken.hList);

            // ... add record format
            if (not addRecordFormat('EXPJRNE': fileCcsid: msg));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               isOK = cFalse;
               leave;
            endif;

            // ... add fields of QADSPJR*
            if (not addFields(rtxToken.hList: fileCcsid));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               isOK = cFalse;
               leave;
            endif;

            // Close source file
            close SRCFILE;

            // Create output file
            Message_sendStatusMsg('USR0103');

            if (not f_execute('CRTPF FILE(' + %trim(i_outLib)
                                            + '/'
                                            + %trim(i_outFile) + ') ' +
                                    'SRCFILE(' + %trim(g_srcFile) + ') ' +
                                    'SRCMBR('  + %trim(g_srcMbr)  + ') ' +
                                    'OPTION('  + '*NOSRC *NOLIST' + ') '
                                : *omit: msg));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               isOK = cFalse;
               leave;
            endif;

            // Unregister abnormal end procedure
            CEEUTX(%paddr('p_abnEndProc'): *omit);

            isOK = cTrue;
         enddo;

         // Delete temporary objects
         Message_sendStatusMsg('USR0104');

         // House keeping
         // ... list of columns
         if (not BasicList_isNull(rtxToken.hList));
            BasicList_delete(rtxToken.hList);
            rtxToken.hList = BasicList_null();
         endif;
         // ... source physical
         if (%open(SRCFILE));
            close SRCFILE;
         endif;
         // ... temporary source physical file
         if (f_exist(rtxToken.srcFile.name: rtxToken.srcFile.lib: '*FILE'));
            dltFile(rtxToken.srcFile.name: rtxToken.srcFile.lib);
            clear rtxToken.srcFile;
         endif;

         return isOK;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Adds the record format definition to the source file member.
      *=====================================================================*
     P addRecordFormat...
     P                 B
     D                 PI              N
     D  i_format                     10A   const
     D  i_fileCcsid                  10U 0 const
     D  o_msg                              const  likeds(msg_t )
      *
      *  Local fields
     D rcdFmt          DS                  likeds(rcdFmt_t   ) inz
     D srcLine         DS                  likeds(srcLine_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_fileCcsid = 0);
            addKeyword('CCSID(' + %char(i_fileCcsid) + ')');
         endif;

         clear rcdFmt;
         rcdFmt.spec   = 'A';
         rcdFmt.type   = 'R';
         rcdFmt.name   = xlate(i_format);

         clear srcLine;
         srcLine.data = rcdFmt;
         write SRCFILE srcLine;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Adds the fields of the record format to the source file member.
      *=====================================================================*
     P addFields...
     P                 B
     D                 PI              N
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_fileCcsid                  10U 0 const
      *
      *  Local fields
     D x               S             10I 0 inz
     D fldAttr         DS                  likeds(fldAttr_t ) based(pFldAttr)
     D fldDef          DS                  likeds(fldDef_t   ) inz
     D srcLine         DS                  likeds(srcLine_t  ) inz
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         for x = 1 to BasicList_getNumE(i_hList);
            pFldAttr = BasicList_get(i_hList: x);

            fldDef = *ALL' ';
            fldDef.spec   = 'A';
            fldDef.name   = fldAttr.flda0320.name;

            // Set properties depeding on data type
            select;
            // ... CHARACTER / VARCHAR
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_CHAR   );
               fldDef.length = fldAttr.flda0320.length;
               fldDef.type   = fldAttr.flda0320.type;
            // ... GRAPHIC / VARGRAPHIC
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_GRAPHIC);
               fldDef.length = fldAttr.flda0320.digits;
               fldDef.type   = fldAttr.flda0320.type;
            // ... BINARY
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_BINARY );
               fldDef.length = fldAttr.flda0320.digits;
               fldDef.decPos = fldAttr.flda0320.decPos;
               fldDef.type   = fldAttr.flda0320.type;
            // ... ZONED / PACKED / FLOAT
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_ZONED  ) or
                 (fldAttr.flda0320.type = cFLDDCT_TYPE_PACKED ) or
                 (fldAttr.flda0320.type = cFLDDCT_TYPE_FLOAT  );
               fldDef.length = fldAttr.flda0320.digits;
               fldDef.decPos = fldAttr.flda0320.decPos;
               fldDef.type   = fldAttr.flda0320.type;
            // ... DATE / TIME / TIMESTAMP
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_DATE   ) or
                 (fldAttr.flda0320.type = cFLDDCT_TYPE_TIME   ) or
                 (fldAttr.flda0320.type = cFLDDCT_TYPE_TMSTMP );
               fldDef.type   = fldAttr.flda0320.type;
            // ... BLOB / CLOB
            when (fldAttr.flda0320.type = cFLDDCT_TYPE_LOB    );
               fldDef.length = fldAttr.flda0320.buffLength;
               fldDef.type   = 'A';
            endsl;

            clear srcLine;
            srcLine.data = fldDef;
            Write SRCFILE srcLine;

            // Add FLTPCN keyword
            if (fldAttr.flda0320.type = cFLDDCT_TYPE_FLOAT);
               if (fldAttr.flda0320.length = 4);
                  addKeyword('FLTPCN(' + '*SINGLE' + ')');
               else;
                  addKeyword('FLTPCN(' + '*DOUBLE' + ')');
               endif;
            endif;

            // Add VARLEN keyword
            if (fldAttr.flda0320.varLength = cTrue);
               if (fldAttr.flda0320.alcLength = 0);
                  addKeyword('VARLEN');
               else;
                  addKeyword('VARLEN(' +
                             %char(fldAttr.flda0320.alcLength) + ')');
               endif;
            endif;

            // Add CCSID keyword
            if (hasCcsidClause(fldAttr.flda0320.type
                               : fldAttr.flda0320.ccsid));
               if (i_fileCcsid = 0);
                  addKeyword('CCSID(' + %char(fldAttr.flda0320.ccsid) + ')');
               endif;
            endif;

            // Add TEXT keyword
            addKeyword('TEXT(' + f_addQuotes(%trim(fldAttr.flda0320.text)
                                             : cSINGLE_QUOTE) + ')');

            // Add COLHDG keyword
            addKeyword('COLHDG(' + f_addQuotes(%trim(fldAttr.flda0320.colHdg1)
                                               : cSINGLE_QUOTE) + ' ' +
                                   f_addQuotes(%trim(fldAttr.flda0320.colHdg2)
                                               : cSINGLE_QUOTE) + ' ' +
                                   f_addQuotes(%trim(fldAttr.flda0320.colHdg3)
                                               : cSINGLE_QUOTE) + ')');

         endfor;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Adds a keyword to the source file member.
      *=====================================================================*
     P addKeyword...
     P                 B
     D                 PI              N
     D  i_kwd                       256A   value  varying
      *
      *  Local fields
     D kwd             DS                  likeds(kwd_t      ) inz
     D srcLine         DS                  likeds(srcLine_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         dow (%len(i_kwd) > 0);
            // Write field definition to source file:
            clear kwd;
            kwd.spec   = 'A';

            if (%len(i_kwd) > %len(kwd.value));
               kwd.value = %subst(i_kwd: 1: %len(kwd.value)-1) + '-';
               i_kwd = %subst(i_kwd: %len(kwd.value));
            else;
               kwd.value = i_kwd;
               i_kwd = '';
            endif;

            clear srcLine;
            srcLine.data = kwd;
            write SRCFILE srcLine;
         enddo;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Returns a file level CCSID if all character fields have the
      *  same CCSID.
      *=====================================================================*
     P getFileCcsid...
     P                 B
     D                 PI            10U 0
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Return value
     D ccsid           S             10U 0 inz(0)
      *
      *  Local fields
     D x               S             10I 0 inz
     D fldAttr         DS                  likeds(fldAttr_t ) based(pFldAttr)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         for x = 1 to BasicList_getNumE(i_hList);
            pFldAttr = BasicList_get(i_hList: x);
            if (hasCcsidClause(fldAttr.flda0320.type
                               : fldAttr.flda0320.ccsid));
               if (ccsid > 0 and ccsid <> fldAttr.flda0320.ccsid);
                  return 0;
               endif;
               ccsid = fldAttr.flda0320.ccsid;
            endif;
         endfor;

         return ccsid;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Create temporary source physical file.
      *=====================================================================*
     P crtSrcFile...
     P                 B
     D                 PI              N
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_mbr                        10A   const
     D  i_text                       50A   const
      *
      *  Return value
     D isOK            S               N   inz(cFalse)
      *
      *  Local fields
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         dou '1';

            if (not f_execute('CRTSRCPF ' +
                                 'FILE(' + %trim(i_lib) + '/' +
                                           %trim(i_file) + ') ' +
                                 'TEXT(' + i_text + ') '
                              : *omit: msg));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               isOK = cFalse;
               leave;
            endif;

            if (not f_execute('ADDPFM ' +
                                 'FILE(' + %trim(i_lib) + '/' +
                                           %trim(i_file) + ') ' +
                                 'MBR('  + %trim(i_mbr) + ') ' +

                                 'TEXT(' + i_text + ') ' +
                                 'SRCTYPE(' + 'PF' + ') '
                              : *omit: msg));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               isOK = cFalse;
               leave;
            endif;

            isOK = cTrue;
         enddo;

         if (not isOK);
            dltFile(i_file: i_lib);
         endif;

         isOK = cTrue;

         return isOK;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Deletes a given physical file.
      *=====================================================================*
     P dltFile...
     P                 B
     D                 PI              N
     D  i_file                       10A   const
     D  i_lib                        10A   const
      *
      *  Local fields
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (f_exist(i_file: i_lib: '*FILE'));
            if (not f_execute('DLTF ' + 'FILE(' + %trim(i_lib) + '/' +
                                                  %trim(i_file) + ') '
                              : *omit: msg));
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
               return cFalse;
            endif;
         endif;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Terminate SQL connection
      *=====================================================================*
      *
     P p_abnEndProc...
     P                 B
     D                 PI
     D  i_pRtxToken                    *   const
      *
     D rtxToken        DS                  likeds(rtxToken_t) based(i_pRtxToken)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%open(SRCFILE));
            close SRCFILE;
         endif;

         if (not BasicList_isNull(rtxToken.hList));
            BasicList_delete(rtxToken.hList);
            rtxToken.hList = BasicList_null();
         endif;

         dltFile(rtxToken.srcFile.name: rtxToken.srcFile.lib);

      /END-FREE
     P                 E
      *
