      /IF NOT DEFINED(EXPJRNE_PROTOTYPE)
      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER7                                          *
      *  Description . : Export Journal Entries - UTIL                      *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 19.09.2008                                         *
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
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
      *                                                                     *
      *  12.08.2009  Th.Raddatz    Added mappings:                          *
      *                               SQL_WCHAR    -> cSQL_TYPE_GRAPHIC     *
      *                               SQL_WVARCHAR -> cSQL_TYPE_VARGRAPHIC  *
      *                                                                     *
      *  19.08.2009  Th.Raddatz    Added procedure: hasCcsidClause()        *
      *                                                                     *
      *  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
      *                                                                     *
      *  03.02.2015  Th.Raddatz    Changed to support CLOB/BLOB fields:     *
      *                            sqlTypeToString() / hasCcsidClause().    *
      *                                                                     *
      *  04.10.2018  Th.Raddatz    Added outfile types *TYPE4 and *TYPE5.   *
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
      *
      *  Returns the date format of the job.
     D rtvJobDateFmt...
     D                 PR            10A          varying
     D                                     extproc('EXPJRNER7_+
     D                                     rtvJobDateFmt+
     D                                     ')
      *
      *  Retrieve Journal Information
     D rtvJrnInf...
     D                 PR              N
     D                                     extproc('EXPJRNER7_+
     D                                     rtvJrnInf+
     D                                     ')
     D  i_obj                        10A   const
     D  i_lib                        10A   const
     D  i_objType                    10A   const
     D  o_file                       10A
     D  o_lib                        10A
     D  o_active                       N
     D  o_jrn                        10A
     D  o_jrnLib                     10A
     D  o_images                     10A
     D  o_omtJrnE                    10A
      *
      *  Converts a given SQL raw data type (integer value) to
      *  its external character representation.
     D sqlTypeToString...
     D                 PR            32A          varying
     D                                     extproc('EXPJRNER7_+
     D                                     sqlTypeToString+
     D                                     ')
     D  i_sqltype                    10I 0 const
      *
      *  Converts a given RPG data type to its SQL representation.
     D rpgTypeToSqlString...
     D                 PR            32A          varying
     D                                     extproc('EXPJRNER7_+
     D                                     rpgTypeToSqlString+
     D                                     ')
     D  i_rpgType                     1A   const
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Converts invalid characters.
     D xlate...
     D                 PR           512A          varying
     D                                     extproc('EXPJRNER7_+
     D                                     xlate+
     D                                     ')
     D  i_string                    512A   const  varying
      *
      *  Returns the list of columns of the output file.
     D getOutputFileColumns...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     getOutputFileColumns+
     D                                     ')
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_outFilFmt                  10A   const
     D  i_tplFile                          const  likeds(qObj_t   )
      *
      *  Returns cTrue if the field has a CCSID clause.
     D hasCcsidClause...
     D                 PR              N
     D                                     extproc('EXPJRNER7_+
     D                                     hasCcsidClause+
     D                                     ')
     D  i_type                        1A   const
     D  i_ccsid                      10U 0 const
      *
      *  Sets the name of the output file.
     D OutputFile_setName...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_setName+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Returns the name of the output file.
     D OutputFile_getName...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_getName+
     D                                     ')
      *
      *  Sets the name of the library that contains the output file.
     D OutputFile_setLibrary...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_setLibrary+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Returns the name of the library that contains the output file.
     D OutputFile_getLibrary...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_getLibrary+
     D                                     ')
      *
      *  Sets the name of the member of the output file that is used to
      *  receive the exported journal entries.
     D OutputFile_setMember...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_setMember+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Returns the name of the member of the output file that is used to
      *  receive the exported journal entries.
     D OutputFile_getMember...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_getMember+
     D                                     ')
      *
      *  Sets the type of the output format.
     D OutputFile_setOutputFileFormat...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_setOutputFileFormat+
     D                                     ')
     D  i_outFilFmt                  10A   const
      *
      *  Returns the type of the output format.
     D OutputFile_getOutputFileFormat...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_getOutputFileFormat+
     D                                     ')
      *
      *  Sets the name of the template file.
     D TemplateFile_setName...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     TemplateFile_setName+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Returns the name of the template file.
     D TemplateFile_getName...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     TemplateFile_getName+
     D                                     ')
      *
      *  Sets the name of the library that contains the template file.
     D TemplateFile_setLibrary...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     TemplateFile_setLibrary+
     D                                     ')
     D  i_lib                        10A   const
      *
      *  Returns the name of the library that contains the template file.
     D TemplateFile_getLibrary...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     TemplateFile_getLibrary+
     D                                     ')
      *
      *  Returns cTrue if the output file format does not matches the required format.
     D OutputFile_isLevelCheck...
     D                 PR              N
     D                                     extproc('EXPJRNER7_+
     D                                     OutputFile_isLevelCheck+
     D                                     ')
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass)
      *
      *  Sets the name of object whose journal entries are exported.
     D Object_setName...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Object_setName+
     D                                     ')
     D  i_obj                        10A   const
      *
      *  Returns the name of object whose journal entries are exported.
     D Object_getName...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     Object_getName+
     D                                     ')
      *
      *  Sets the name of the library that contains
      *  the object whose journal entries are exported.
     D Object_setLibrary...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Object_setLibrary+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Rteurns the name of the library that contains
      *  the object whose journal entries are exported.
     D Object_getLibrary...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     Object_getLibrary+
     D                                     ')
      *
      *  Sets the type of the object whose journal entries are exported.
     D Object_setType...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Object_setType+
     D                                     ')
     D  i_file                       10A   const
      *
      *  Returns the type of the object whose journal entries are exported.
     D Object_getType...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     Object_getType+
     D                                     ')
      *
      *  Resets the error counter.
     D Error_resetCounter...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Error_resetCounter+
     D                                     ')
      *
      *  Increments the error counter by one.
     D Error_incrementCounter...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Error_incrementCounter+
     D                                     ')
      *
      *  Returns the number of errors.
     D Error_getCounterAsString...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     Error_getCounterAsString+
     D                                     ')
      *
      *  Sends a status message.
     D Message_sendStatusMsg...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Message_sendStatusMsg+
     D                                     ')
     D  i_ID                               const  like(msg_t.ID   )
     D  i_data                             const  like(msg_t.data )
     D                                            options(*nopass)
      *
      *  Sends a diagnostic message.
     D Message_sendDiagMsg...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Message_sendDiagMsg+
     D                                     ')
     D  i_msg                              value  likeds(msg_t    )
      *
      *  Sends an escape message.
     D Message_sendEscapeMsg...
     D                 PR
     D                                     extproc('EXPJRNER7_+
     D                                     Message_sendEscapeMsg+
     D                                     ')
     D  i_msg                              value  likeds(msg_t    )
      *
      *  Returns the current release level of the operating system.
     D System_getCurrentRelease...
     D                 PR             6A
     D                                     extproc('EXPJRNER7_+
     D                                     System_getCurrentRelease+
     D                                     ')
      *
      *  Returns the application library of the EXPJRNE utility.
     D Application_getLibrary...
     D                 PR            10A
     D                                     extproc('EXPJRNER7_+
     D                                     Application_getLibrary+
     D                                     ')
      *
      /IF DEFINED(EXPJRNE_PROTOTYPE)
      /EOF
      /ENDIF
      *
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library
      /COPY QEXPJRNE,QUSRJOBI                      Retrieve Job Information (QUSRJOBI) API
      /COPY QEXPJRNE,FDQJOB                        typedef: Qualified Job Name
      /COPY QEXPJRNE,FDOBJD0400                    typedef: QUSROBJD API - OBJD0400
      /COPY QEXPJRNE,QUSROBJD                      Retrieve Object Description (QUSROBJD) API
      /COPY QEXPJRNE,SQLCLI                        SQL-Call Level Interface
      /COPY QEXPJRNE,SQL                           Embedded SQL type definitions and const.
      /COPY QEXPJRNE,QWCRDTAA                      Retrieve Data Area (QWCRDTAA) API
      /COPY QEXPJRNE,QMHQRDQD                      Retrieve Data Queue Description (QMHQRDQD)
      /COPY QEXPJRNE,JRNETYPES                     Layouts for var.-length portion of jrnE
      /COPY QEXPJRNE,CEELIB                        CEE APIs
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER6                     EXPJRNE: SQL type definitions and const.
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
      *  Adds the columns of a given file to a given column list.
     D addColumns...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER7_+
     D                                     addColumns+
     D                                     ')
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_file                             const  likeds(qObj_t   )
     D  i_lastField                  10A   const  options(*nopass)
      *
      *  Adds variable-length portion of journal entries of type *DTAARA.
     D addDataAreaVarLenFields...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER7_+
     D                                     addDataAreaVarLenFields+
     D                                     ')
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Adds variable-length portion of journal entries of type *DTAQ.
     D addDataQueueVarLenFields...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER7_+
     D                                     addDataQueueVarLenFields+
     D                                     ')
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Produces a field attribute structure.
     D produceFldAttr...
     D                 PR                         likeds(fldAttr_t  )
     D                                     extproc('EXPJRNER7_+
     D                                     produceFldAttr+
     D                                     ')
     D  i_name                       10A   const
     D  i_type                        1A   const
     D  i_length                     10I 0 const
     D  i_decPos                     10I 0 const  options(*omit)
     D  i_text                       50A   const
     D  i_colHdg                     60A   const
      *
      *  Returns the data type of a given data area.
     D getDataAreaType...
     D                 PR                         likeds(fldAttr_t  )
     D                                     extproc('EXPJRNER7_+
     D                                     getDataAreaType+
     D                                     ')
     D  i_dtaAra                     10A   const
     D  i_lib                        10A   const
      *
      *  Returns the data type of a given data queue.
     D getDataQueueType...
     D                 PR                         likeds(fldAttr_t  )
     D                                     extproc('EXPJRNER7_+
     D                                     getDataQueueType+
     D                                     ')
     D  i_dtaAra                     10A   const
     D  i_lib                        10A   const
      *
      *  Returns the key type of a given keyed data queue.
     D getDataQueueKey...
     D                 PR                         likeds(fldAttr_t  )
     D                                     extproc('EXPJRNER7_+
     D                                     getDataQueueKey+
     D                                     ')
     D  i_dtaAra                     10A   const
     D  i_lib                        10A   const
      *
      /DEFINE SDS_EXTENDED
      /COPY QEXPJRNE,SDS
      *
      *  Current program state
     D g_state         DS                  qualified   inz
     D  qObj                               likeds(qObj_t )
     D  objType                      10A
     D  qOutFile                           likeds(qObj_t )
     D  outMbr                       10A
     D  outFilFmt                    10A
     D  qTplFile                           likeds(qObj_t )
     D  errCount                     10I 0
      *
      *  Constants
      *  ... TYPE1 outfile
     D cType1File      C                   const('QADSPJRN')
     D cType1Lib       C                   const('QTEMP'   )
      *
      *  ... TYPE2 outfile
     D cType2File      C                   const('QADSPJR2')
     D cType2Lib       C                   const('QTEMP'   )
      *
      *  ... TYPE3 outfile
     D cType3File      C                   const('QADSPJR3')
     D cType3Lib       C                   const('QTEMP'   )
      *
      *  ... TYPE4 outfile
     D cType4File      C                   const('QADSPJR4')
     D cType4Lib       C                   const('QTEMP'   )
      *
      *  ... TYPE5 outfile
     D cType5File      C                   const('QADSPJR5')
     D cType5Lib       C                   const('QTEMP'   )
      *
      *==================================================================*
      *  Returns the date format of the job.
      *==================================================================*
     P rtvJobDateFmt...
     P                 B                   export
     D                 PI            10A          varying
      *
      *  Return value
     D dateFmt         S             10A   varying inz
      *
      *  Local fields
     D qJob            DS                  likeds(qJob_t     ) inz
     D jobi0400        DS                  likeds(jobi0400_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qJob.name = '*';
         qJob.user = '';
         qJob.nbr  = '';

         QUSRJOBI(JOBI0400: %size(JOBI0400): 'JOBI0400': qJob: '');

         dateFmt = jobi0400.dateFmt;

         return dateFmt;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Retrieve Journal Information
      *====================================================================
      *  Input :  i_file     - The name of the file about which the
      *                        information is to be retrieved from.
      *           i_lib      - The library of the file.
      *                        Special values: *LIBL, *CURLIB
      *
      *  Output:  o_file     - The actual file name from which the
      *                        information was retrieved from.
      *           o_lib      - The actual library of the file.
      *           o_active   - Journaling active.
      *                            TRUE    = File is beeing journaled.
      *                            FALSE   = File is not beeing journaled.
      *           o_jrn      - The name of the journal.
      *           o_jrnLib   - The library of the journal.
      *           o_images   - Record images that are journaled.
      *                            *BOTH   = Both images are written
      *                                      to the journal.
      *                            *AFTER  = Only after images are written
      *                                      to the journal.
      *           o_omtJrnE  - Journal entries that are omitted.
      *                            *NONE   = No journal entries are omitted.
      *                            *OPNCLO = Open and close entries are omitted.
      *
      *====================================================================
     P rtvJrnInf...
     P                 B                   export
     D                 PI              N
     D  i_obj                        10A   const
     D  i_lib                        10A   const
     D  i_objType                    10A   const
     D  o_obj                        10A
     D  o_lib                        10A
     D  o_active                       N
     D  o_jrn                        10A
     D  o_jrnLib                     10A
     D  o_images                     10A
     D  o_omtJrnE                    10A
      *
      *  return value
     D isOK            S               N   inz(cFalse)
      *
      *  work fields
     D qObj            DS                  likeds(qObj_t     ) inz
     D objd0400        DS                  likeds(objd0400_t ) inz
     D errCode         DS                  likeds(errCode_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Determine initial size of memory needed ...
         qObj.name = i_obj;
         qObj.lib  = i_lib;
         errCode    = f_newApiErrCode(cTrue);

         QUSROBJD(objd0400: %size(objd0400): 'OBJD0400'
                  : qObj: i_objType: errCode);

         // Is there was an error, ...
         if (f_isApiError(errCode));
            // ... then clear return values
            o_obj     = '';
            o_lib     = '';
            o_active  = cFalse;
            o_jrn     = '';
            o_jrnLib  = '';
            o_images  = '';
            o_omtJrnE = '';
            return cFalse;
         endif;

         o_obj     = objd0400.name;
         o_lib     = objd0400.rtnLib;

         if (objd0400.jrnStat = '1');
            o_active  = cTrue;
            o_jrn     = objd0400.jrnName;
            o_jrnLib  = objd0400.jrnLibName;

            if (objd0400.jrnImages = '0');
               o_images  = '*AFTER';
            else;
               o_images  = '*BOTH';
            endif;

            if (objd0400.jrnOmitE = '0');
               o_omtJrnE = '*NONE';
            else;
               o_omtJrnE = '*OPNCLO';
            endif;

         else;
            o_active  = cFalse;
            o_jrn     = '';
            o_jrnLib  = '';
            o_images  = '';
            o_omtJrnE = '';
         endif;

         return cTrue;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Converts a given SQL raw data type (integer value) to
      *  its external character representation.
      *====================================================================
      *  Input :  i_sqlType  - Internal SQL data type as returned by
      *                        SQLColAttributes().
      *
      *  Return:  extType    - Character representation of i_sqlType.
      *====================================================================
     P sqlTypeToString...
     P                 B                   export
     D                 PI            32A          varying
     D  i_sqltype                    10I 0 const
      *
      *  return value
     D dataType        S             10A   varying inz('*N')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Determine initial size of memory needed ...
         Select;
         When (i_sqltype = SQL_CHAR);
            dataType = cSQL_TYPE_CHARACTER;
         When (i_sqltype = SQL_VARCHAR);
            dataType = cSQL_TYPE_VARCHAR;
         When (i_sqltype = SQL_GRAPHIC);
            dataType = cSQL_TYPE_GRAPHIC;
         When (i_sqltype = SQL_VARGRAPHIC);
            dataType = cSQL_TYPE_VARGRAPHIC;
         When (i_sqltype = SQL_WCHAR);
            dataType = cSQL_TYPE_GRAPHIC;
         When (i_sqltype = SQL_WVARCHAR);
            dataType = cSQL_TYPE_VARGRAPHIC;
         When (i_sqltype = SQL_SMALLINT);
            dataType = cSQL_TYPE_SMALLINT;
         When (i_sqltype = SQL_INTEGER);
            dataType = cSQL_TYPE_INTEGER;
         When (i_sqltype = SQL_BIGINT);
            dataType = cSQL_TYPE_BIGINT;
         When (i_sqltype = SQL_DECIMAL);
            dataType = cSQL_TYPE_DECIMAL;
         When (i_sqltype = SQL_NUMERIC);
            dataType = cSQL_TYPE_NUMERIC;
         When (i_sqltype = SQL_DOUBLE);
            dataType = cSQL_TYPE_DOUBLE;
         When (i_sqltype = SQL_FLOAT);
            dataType = cSQL_TYPE_FLOAT;
         When (i_sqltype = SQL_REAL);
            dataType = cSQL_TYPE_REAL;
         When (i_sqltype = SQL_DATE);
            dataType = cSQL_TYPE_DATE;
         When (i_sqltype = SQL_TIME);
            dataType = cSQL_TYPE_TIME;
         When (i_sqltype = SQL_TIMESTAMP);
            dataType = cSQL_TYPE_TIMESTAMP;
         When (i_sqltype = SQL_BLOB);
            dataType = cSQL_TYPE_BLOB;
         When (i_sqltype = SQL_CLOB);
            dataType = cSQL_TYPE_CLOB;
         Other;
            dataType = '*INVALID_DATA_TYPE';
         Endsl;

         return dataType;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Converts a given SQL raw data type (integer value) to
      *  its external character representation.
      *====================================================================
      *  Input :  i_sqlType  - Internal SQL data type as returned by
      *                        SQLColAttributes().
      *
      *  Return:  extType    - Character representation of i_sqlType.
      *====================================================================
     P rpgTypeToSqlString...
     P                 B                   export
     D                 PI            32A          varying
     D  i_rpgType                     1A   const
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Parameter positions
     D p_length        C                   2
      *
      *  Fields for optional parameters
     D length          S                   like(i_length) inz
      *
      *  return value
     D dataType        S             10A   varying inz('*N')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_length);
            length = i_length;
         else;
            length = 0;
         endif;

         // Determine initial size of memory needed ...
         select;
         when (i_rpgType = 'A');
            dataType = sqlTypeToString(SQL_CHAR);

         when (i_rpgType = 'B');
            select;
            when (length <= 4);
               dataType = sqlTypeToString(SQL_SMALLINT);
            when (length <=  9);
               dataType = sqlTypeToString(SQL_INTEGER);
            when (length <= 18);
               dataType = sqlTypeToString(SQL_BIGINT);
            other;
               dataType = sqlTypeToString(SQL_BIGINT);
            endsl;

         when (i_rpgType = 'I');
            select;
            when (length <= 3);
               dataType = sqlTypeToString(SQL_SMALLINT);
            when (length <= 5);
               dataType = sqlTypeToString(SQL_SMALLINT);
            when (length <= 10);
               dataType = sqlTypeToString(SQL_INTEGER);
            when (length <= 20);
               dataType = sqlTypeToString(SQL_BIGINT);
            other;
               dataType = sqlTypeToString(SQL_BIGINT);
            endsl;

         when (i_rpgType = 'P');
            dataType = sqlTypeToString(SQL_DECIMAL);

         when (i_rpgType = 'S');
            dataType = sqlTypeToString(SQL_NUMERIC);

         when (i_rpgType = 'F');
            select;
            when (length = 4);
               dataType = sqlTypeToString(SQL_REAL);
            when (length = 8);
               dataType = sqlTypeToString(SQL_DOUBLE);
            other;
               dataType = sqlTypeToString(SQL_DOUBLE);
            endsl;

         when (i_rpgType = 'D');
            dataType = sqlTypeToString(SQL_DATE);

         when (i_rpgType = 'T');
            dataType = sqlTypeToString(SQL_TIME);

         when (i_rpgType = 'Z');
            dataType = sqlTypeToString(SQL_TIMESTAMP);

         other;
            dataType = '*INVALID_DATA_TYPE';
         endsl;

         return dataType;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Converts invalid characters.
      *====================================================================
      *  Input :  i_string   - Input string.
      *
      *  Return:  string     - Output string.
      *====================================================================
     P xlate...
     P                 B                   export
     D                 PI           512A          varying
     D  i_string                    512A   const  varying
      *
      *  Return value
     D string          S            512A   varying inz
      *
      *  Local fields
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Messages
      /COPY QEXPJRNE,USR0019
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = %xlate('.': '_': i_string);

         if (i_string <> string);
            clear USR0019;
            USR00191 = i_string;
            USR00192 = string;
            msg = f_newMsg('USR0019': USR0019);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy: *omit: sds.pgmContProc);
         endif;

         return string;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the list of columns of the output file.
      *====================================================================
      *  Input :  i_hList    - Handle of the list the columns are added to.
      *           i_outFilFmt- Format of the output file.
      *           i_tplFile  - Qualified file name of the template file.
      *
      *  Return:  void
      *====================================================================
     P getOutputFileColumns...
     P                 B                   export
     D                 PI
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_outFilFmt                  10A   const
     D  i_tplFile                          const  likeds(qObj_t   )
      *
      *  Local fields
     D fldAttr         DS                  likeds(fldAttr_t        ) inz
     D expType         DS                  likeds(qObj_t           ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Determine type of output file
         select;
         when (i_outFilFmt = '*TYPE1');
            expType.name = cType1File;
            expType.lib  = cType1Lib;
         when (i_outFilFmt = '*TYPE2');
            expType.name = cType2File;
            expType.lib  = cType2Lib ;
         when (i_outFilFmt = '*TYPE3');
            expType.name = cType3File;
            expType.lib  = cType3Lib;
         when (i_outFilFmt = '*TYPE4');
            expType.name = cType4File;
            expType.lib  = cType4Lib;
         when (i_outFilFmt = '*TYPE5');
            expType.name = cType5File;
            expType.lib  = cType5Lib;
         endsl;

         // ... add columns of QADSPJR*, depending of export type
         addColumns(i_hList: expType: 'JOESD');

         // ... add variable-length portion of journal entries of ...
         select;
         // ... data areas
         when (Object_getType() = '*DTAARA');
            addDataAreaVarLenFields(i_hList);
         // ... data queues
         when (Object_getType() = '*DTAQ');
            addDataQueueVarLenFields(i_hList);
         endsl;

         // ... add columns of template file
         select;
         when (Object_getType() = '*DTAARA');
            fldAttr = getDataAreaType(Object_getName(): Object_getLibrary());
            BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         when (Object_getType() = '*DTAQ');
            fldAttr = getDataQueueKey(Object_getName(): Object_getLibrary());
            if (fldAttr.flda0320.name <> '');
               BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));
            endif;

            fldAttr = getDataQueueType(Object_getName(): Object_getLibrary());
            BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         other;
            addColumns(i_hList: i_tplFile);
         endsl;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns cTrue if the field has a CCSID clause.
      *====================================================================
      *  Input :  i_fldAttr  - Field attribute structure.
      *
      *  Return:  hasCcsid   -
      *====================================================================
     P hasCcsidClause...
     P                 B                   export
     D                 PI              N
     D  i_type                        1A   const
     D  i_ccsid                      10U 0 const
      *
      *  Return value
     D hasCcsid        S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_ccsid > 0 and i_type <> cFLDDCT_TYPE_DATE   and
                             i_type <> cFLDDCT_TYPE_TIME   and
                             i_type <> cFLDDCT_TYPE_TMSTMP and
                             i_type <> cFLDDCT_TYPE_ERROR ); // returned for BLOB/CLOB
            hasCcsid = cTrue;
         else;
            hasCcsid = cFalse;
         endif;

         return hasCcsid;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Adds the columns of a given file to a given column list.
      *====================================================================
      *  Input :  i_hList    - Handle of the list the columns are added to.
      *           i_file     - Name of the file.
      *           i_lastField- Qualified file name of the template file.
      *
      *  Return:  void
      *====================================================================
     P addColumns...
     P                 B
     D                 PI                         like(SQLRETCODE_t )
     D  i_hList                            const  like(BasicList_handle_t )
     D  i_file                             const  likeds(qObj_t     )
     D  i_lastField                  10A   const  options(*nopass)
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Parameter positions
     D p_lastField     C                   3
      *
      *  Fields for optional parameters
     D lastField       S                   like(i_lastField  ) inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D hColumns        DS                  likeds(hColumns_t ) inz
     D fldAttr         DS                  likeds(fldAttr_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_lastField);
            lastField = i_lastField;
         else;
            lastField = '';
         endif;

         hColumns = SQLCLI_Columns_null();

         dou '1';

            if (SQLCLI_Columns_open(hColumns: i_file) <> SQL_SUCCESS);
               rc = SQL_ERROR;
               leave;
            endif;

            for x = 1 to SQLCLI_Columns_numE(hColumns);
               SQLCLI_Columns_get(hColumns: fldAttr);

               if (lastField <> '' and fldAttr.flda0320.name = lastField);
                  leave;
               endif;

               BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));
            endfor;

         enddo;

         if (not SQLCLI_Columns_isNull(hColumns));
            SQLCLI_Columns_close(hColumns);
            hColumns = SQLCLI_Columns_null();
         endif;

         return rc;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Adds variable-length portion of journal entries of type *DTAARA.
      *====================================================================
      *  Input :  i_hList    - Handle of the list the columns are added to.
      *
      *  Return:  rc         - Returns SQL_SUCCESS on success, else SQL_ERROR.
      *====================================================================
     P addDataAreaVarLenFields...
     P                 B
     D                 PI                         like(SQLRETCODE_t )
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D fldAttr         DS                  likeds(fldAttr_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         fldAttr = produceFldAttr('X_START' : 'B': 9: 0
                                  : 'Starting position of change'
                                  : 'Start pos.');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_LENGTH': 'B': 9: 0
                                  : 'Length of change'
                                  : 'Length');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_DECPOS': 'B': 9: 0
                                  : 'Number of decimal positions'
                                  : 'Dec.Pos.');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_OFFSET': 'B': 9: 0
                                  : 'Offset to change'
                                  : 'Offset');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_TYPE'  : 'A': 10: *omit
                                  : 'Type of data area'
                                  : 'type');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         rc = SQL_SUCCESS;

         return rc;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Adds variable-length portion of journal entries of type *DTAQ.
      *====================================================================
      *  Input :  i_hList    - Handle of the list the columns are added to.
      *
      *  Return:  rc         - Returns SQL_SUCCESS on success, else SQL_ERROR.
      *====================================================================
     P addDataQueueVarLenFields...
     P                 B
     D                 PI                         like(SQLRETCODE_t )
     D  i_hList                            const  like(BasicList_handle_t )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D fldAttr         DS                  likeds(fldAttr_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         fldAttr = produceFldAttr('X_SYSINF1': 'A':  16: 0
                                  : 'Reserved for future use'
                                  : 'Reserved 1');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_SYSINF2': 'A':   2: 0
                                  : 'Reserved for future use'
                                  : 'Reserved 2');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_SYSINF3': 'A':  10: 0
                                  : 'Reserved for future use'
                                  : 'Reserved 3');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_ORDER'  : 'A':   2: 0
                                  : 'Key order'
                                  : 'Key order');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_KEYLEN' : 'B':   9: 0
                                  : 'Key length '
                                  : 'Key length');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_DTALEN' : 'B':   9: 0
                                  : 'Data length '
                                  : 'Data length');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         fldAttr = produceFldAttr('X_APIINF' : 'A':  16: 0
                                  : 'Send data queue API information'
                                  : 'API Inf.');
         BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

         rc = SQL_SUCCESS;

         return rc;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Produces a field attribute structure.
      *====================================================================
      *  Input :  i_name     - Field name.
      *           i_type     - Data type.
      *           i_length   - Field length.
      *           i_decPos   - Decimal positions.
      *           i_text     - Field description.
      *           i_colHdg   - Field column heading.
      *
      *  Return:  fldAttr    - Field attribute structure.
      *====================================================================
     P produceFldAttr...
     P                 B
     D                 PI                         likeds(fldAttr_t  )
     D  i_name                       10A   const
     D  i_type                        1A   const
     D  i_length                     10I 0 const
     D  i_decPos                     10I 0 const  options(*omit)
     D  i_text                       50A   const
     D  i_colHdg                     60A   const
      *
      *  Return value
     D fldAttr         DS                  likeds(fldAttr_t ) inz
      *
      *  Parameter positions
     D p_decPos        C                   4
      *
      *  Fields for optional parameters
     D decPos          S                   like(i_decPos    ) inz
      *
      *  Local fields
     D isDecPos        S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_type = 'A' or i_type = 'I' or i_type = 'B' or i_type = 'P'
                  : 'Unexpected value in i_type: ' + i_type);

         CEETSTA(isDecPos: p_decPos: *omit);
         if (isDecPos = 1);
            decPos = i_decPos;
         else;
            decPos = 0;
         endif;

         fldAttr.flda0320.name    = i_name;
         fldAttr.flda0320.type    = i_type;

         select;
         when (fldAttr.flda0320.type = 'A');
            fldAttr.flda0320.length  = i_length;
            fldAttr.flda0320.digits  = 0;

         when (fldAttr.flda0320.type = 'P');
            fldAttr.flda0320.length  =
                                 %unsh(((((i_length + 1) / 2) * 10) + 5) / 10);
            fldAttr.flda0320.digits  = i_length;

         when (fldAttr.flda0320.type = 'B' or fldAttr.flda0320.type = 'I');
            select;
            when (i_length <= 3);
               fldAttr.flda0320.length = 1;
            when (i_length <= 5);
               fldAttr.flda0320.length = 2;
            when (i_length <= 10);
               fldAttr.flda0320.length = 4;
            when (i_length <= 20);
               fldAttr.flda0320.length = 8;
            endsl;
            fldAttr.flda0320.digits  = i_length;
         endsl;

         fldAttr.flda0320.decPos  = decPos;
         fldAttr.flda0320.text    = i_text;
         fldAttr.flda0320.colHdg1 = %subst(i_colHdg:  1: 20);
         fldAttr.flda0320.colHdg2 = %subst(i_colHdg: 21: 20);
         fldAttr.flda0320.colHdg3 = %subst(i_colHdg: 41: 20);
         fldAttr.flda0320.alias   = i_name;
         fldAttr.sqlType          = rpgTypeToSqlString(i_type: i_length);

         return fldAttr;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Returns the data type of a given data area.
      *====================================================================
      *  Input :  i_dtaAra   - Data area whose data type is returned
      *
      *  Return:  fldAttr    - Field definition of the data type of the
      *                        data area.
      *====================================================================
     P getDataAreaType...
     P                 B
     D                 PI                         likeds(fldAttr_t  )
     D  i_dtaAra                     10A   const
     D  i_lib                        10A   const
      *
      *  Return value
     D fldAttr         DS                  likeds(fldAttr_t   ) inz
      *
      *  Local fields
     D start           S             10I 0 inz
     D length          S             10I 0 inz
     D qDtaAra         DS                  likeds(qObj_t       ) inz
     D rtvDtaAra       DS                  likeds(rtvDtaAra_t  ) inz
     D errCode         DS                  likeds(errCode_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qDtaAra.name = i_dtaAra;
         qDtaAra.lib  = i_lib;
         start  = -1;
         length = %len(rtvDtaAra.value);
         errCode = f_newApiErrCode(cFalse);
         QWCRDTAA(rtvDtaAra: %size(rtvDtaAra): qDtaAra: start: length: errCode);

         select;
         when (rtvDtaAra.type = '*CHAR');
            fldAttr = produceFldAttr('X_VALUE' : 'A'
                                     : rtvDtaAra.length
                                     : 0
                                     : 'Changed string value'
                                     : 'Changed value       (string)');

         when (rtvDtaAra.type = '*DEC');
            fldAttr = produceFldAttr('X_VALUE' : 'P'
                                      : rtvDtaAra.length
                                      : rtvDtaAra.decPos
                                     : 'Changed numeric value'
                                     : 'Changed value       (numeric)');

         when (rtvDtaAra.type = '*LGL');
            fldAttr = produceFldAttr('X_VALUE' : 'A'
                                      : rtvDtaAra.length
                                      : 0
                                     : 'Changed boolean value'
                                     : 'Changed value       (boolean)');

         endsl;

         return fldAttr;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Returns the data type of a given data queue.
      *====================================================================
      *  Input :  i_dtaAra   - Data queue whose data type is returned
      *
      *  Return:  fldAttr    - Field definition of the data type of the
      *                        data queue.
      *====================================================================
     P getDataQueueType...
     P                 B
     D                 PI                         likeds(fldAttr_t  )
     D  i_dtaQ                       10A   const
     D  i_lib                        10A   const
      *
      *  Return value
     D fldAttr         DS                  likeds(fldAttr_t   ) inz
      *
      *  Local fields
     D qDtaQ           DS                  likeds(qObj_t       ) inz
     D rdqd0100        DS                  likeds(rdqd0100_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qDtaQ.name = i_dtaQ;
         qDtaQ.lib  = i_lib;
         QMHQRDQD(rdqd0100: %size(rdqd0100): 'RDQD0100': qDtaQ);
                                                                                         //RAD
         fldAttr = produceFldAttr('X_DATA' : 'A'
                                  : rdqd0100.msgLength
                                  : 0
                                  : 'Message Data'
                                  : 'Message data');

         return fldAttr;

      /END-FREE
     P                 E
      *
      *====================================================================
    R *  *** private ***
      *  Returns the key type of a given keyed data queue.
      *====================================================================
      *  Input :  i_dtaAra   - Data queue whose data type is returned
      *
      *  Return:  fldAttr    - Field definition of the data type of the
      *                        data queue.
      *====================================================================
     P getDataQueueKey...
     P                 B
     D                 PI                         likeds(fldAttr_t  )
     D  i_dtaQ                       10A   const
     D  i_lib                        10A   const
      *
      *  Return value
     D fldAttr         DS                  likeds(fldAttr_t   ) inz
      *
      *  Local fields
     D qDtaQ           DS                  likeds(qObj_t       ) inz
     D rdqd0100        DS                  likeds(rdqd0100_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qDtaQ.name = i_dtaQ;
         qDtaQ.lib  = i_lib;
         QMHQRDQD(rdqd0100: %size(rdqd0100): 'RDQD0100': qDtaQ);

         if (rdqd0100.sequence <> 'K');
            return fldAttr;
         endif;
                                                                                         //RAD
         fldAttr = produceFldAttr('X_KEY' : 'A'
                                  : rdqd0100.keyLength
                                  : 0
                                  : 'Key value'
                                  : 'Key value');

         return fldAttr;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the output file.
      *====================================================================
      *  Input :  i_file     - Name of the output file.
      *
      *  Return:  void
      *====================================================================
     P OutputFile_setName...
     P                 B                   export
     D                 PI
     D  i_file                       10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qOutFile.name = i_file;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the library that contains the output file.
      *====================================================================
      *  Input :  i_lib      - Name of the library that contains the
      *                        output file.
      *
      *  Return:  void
      *====================================================================
     P OutputFile_setLibrary...
     P                 B                   export
     D                 PI
     D  i_lib                        10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qOutFile.lib = i_lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the member of the output file that is used to
      *  receive the exported journal entries.
      *====================================================================
      *  Input :  i_mbr      - Name of the member that receives the
      *                        exported journal entries.
      *
      *  Return:  void
      *====================================================================
     P OutputFile_setMember...
     P                 B                   export
     D                 PI
     D  i_mbr                        10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.outMbr = i_mbr;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the type of the output format.
      *====================================================================
      *  Input :  i_type     - Sets the type of the output format.
      *
      *  Return:  void
      *====================================================================
     P OutputFile_setOutputFileFormat...
     P                 B                   export
     D                 PI
     D  i_outFilFmt                  10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.outFilFmt = i_outFilFmt;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the template file.
      *====================================================================
      *  Input :  i_file     - Name of the template file.
      *
      *  Return:  void
      *====================================================================
     P TemplateFile_setName...
     P                 B                   export
     D                 PI
     D  i_file                       10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qTplFile.name = i_file;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the library that contains the template file.
      *====================================================================
      *  Input :  i_lib      - Name of the library that contains the
      *                        template file.
      *
      *  Return:  void
      *====================================================================
     P TemplateFile_setLibrary...
     P                 B                   export
     D                 PI
     D  i_lib                        10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qTplFile.lib = i_lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the template file.
      *====================================================================
      *  Input :  void
      *
      *  Return:  file       - Name of the template file.
      *====================================================================
     P TemplateFile_getName...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qTplFile.name;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the library that contains the template file.
      *====================================================================
      *  Input :  void
      *
      *  Return:  lib        - Name of the library that contains
      *                        the template file.
      *====================================================================
     P TemplateFile_getLibrary...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qTplFile.lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the output file.
      *====================================================================
      *  Input :  void
      *
      *  Return:  file       - Name of the output file.
      *====================================================================
     P OutputFile_getName...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qOutFile.name;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the library that contains the output file.
      *====================================================================
      *  Input :  void
      *
      *  Return:  lib        - Name of the library that contains the
      *                        output file.
      *====================================================================
     P OutputFile_getLibrary...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qOutFile.lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the member of the output file that is used to
      *  receive the exported journal entries.
      *====================================================================
      *  Input :  void
      *
      *  Return:  mbr        - Name of the member that receives the
      *                        exported journal entries.
      *====================================================================
     P OutputFile_getMember...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.outMbr;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the type of the output format.
      *====================================================================
      *  Input :  void
      *
      *  Return:  type       - Returns the type of the output format.
      *====================================================================
     P OutputFile_getOutputFileFormat...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.outFilFmt;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns cTrue if the output file format does not matches
      *  the required format.
      *====================================================================
      *  Input :  void
      *
      *  Return:  isLevelCheck
      *====================================================================
     P OutputFile_isLevelCheck...
     P                 B                   export
     D                 PI              N
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass)
      *
      *  Return value
     D isLevelCheck    S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_msg           C                   1
      *
      *  Local fields
     D x               S             10I 0 inz
     D hOutFile        S                   like(BasicList_handle_t ) inz
     D hReqFile        S                   like(BasicList_handle_t ) inz
     D attrOut         DS                  likeds(fldAttr_t ) based(pAttrOut)
     D attrReq         DS                  likeds(fldAttr_t ) based(pAttrReq)
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Messages
      /COPY QEXPJRNE,USR0021
      /COPY QEXPJRNE,USR0022
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg(cMSG_ID_OK);

         hOutFile = BasicList_null();
         hReqFile = BasicList_null();

         dou '1';

            monitor;

               hOutFile = BasicList_new('*COLUMNS': 256);
               getOutputFileColumns(hOutFile
                                    : g_state.outFilFmt: g_state.qTplFile);

               hReqFile = BasicList_new('*COLUMNS': 256);
               addColumns(hReqFile: g_state.qOutFile: '');

               if (BasicList_getNumE(hOutFile) <> BasicList_getNumE(hReqFile));
                  clear USR0021;
                  USR00211 = g_state.qOutFile.name;
                  USR00212 = g_state.qOutFile.lib;
                  msg = f_newMsg('USR0021': USR0021);
                  isLevelCheck = cTrue;
                  leave;
               endif;

               for x = 1 to BasicList_getNumE(hOutFile);

                  pAttrOut = BasicList_get(hOutFile: x);
                  pAttrReq = BasicList_get(hReqFile: x);

                  if (
                   attrOut.flda0320.name       <> attrReq.flda0320.name       or
                   attrOut.flda0320.type       <> attrReq.flda0320.type       or
                   attrOut.flda0320.length     <> attrReq.flda0320.length     or
                   attrOut.flda0320.digits     <> attrReq.flda0320.digits     or
                   attrOut.flda0320.decPos     <> attrReq.flda0320.decPos     or
                   attrOut.flda0320.datTimFmt  <> attrReq.flda0320.datTimFmt  or
                   attrOut.flda0320.datTimSep  <> attrReq.flda0320.datTimSep  or
                   attrOut.flda0320.alwNull    <> attrReq.flda0320.alwNull    );

                     clear USR0022;
                     USR00221 = g_state.qOutFile.name;
                     USR00222 = g_state.qOutFile.lib;
                     USR00223 = attrOut.flda0320.name;
                     msg = f_newMsg('USR0022': USR0022);
                     isLevelCheck = cTrue;
                     leave;
                  endif;

               endfor;

            on-error;
            endmon;

         enddo;

         if (not BasicList_isNull(hOutFile));
            BasicList_delete(hOutFile);
         endif;

         if (not BasicList_isNull(hReqFile));
            BasicList_delete(hReqFile);
         endif;

         if (%parms() > p_msg);
            o_msg = msg;
         else;
            if (msg.ID <> cMSG_ID_OK);
               Message_sendDiagMsg(msg);
            endif;
         endif;

         return isLevelCheck;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of object whose journal entries are exported.
      *====================================================================
      *  Input :  i_obj      - Name of the object whose journal entries
      *                        are exported.
      *
      *  Return:  void
      *====================================================================
     P Object_setName...
     P                 B                   export
     D                 PI
     D  i_obj                        10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qObj.name = i_obj;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the name of the library that contains
      *  the object whose journal entries are exported.
      *====================================================================
      *  Input :  i_lib      - Name of the library that contains the
      *                        object whose journal entries are exported.
      *
      *  Return:  void
      *====================================================================
     P Object_setLibrary...
     P                 B                   export
     D                 PI
     D  i_lib                        10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.qObj.lib = i_lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sets the type of the object whose journal entries are exported.
      *====================================================================
      *  Input :  i_type     - Sets the type of the object whose journal
      *                        entries are exported.
      *
      *  Return:  void
      *====================================================================
     P Object_setType...
     P                 B                   export
     D                 PI
     D  i_type                       10A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.objType = i_type;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of object whose journal entries are exported.
      *====================================================================
      *  Input :  void
      *
      *  Return:  obj        - Name of the object whose journal entries
      *                        are exported.
      *====================================================================
     P Object_getName...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qObj.name;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the library that contains
      *  the object whose journal entries are exported.
      *====================================================================
      *  Input :  void
      *
      *  Return:  lib        - Name of the library that contains the object
      *                        whose journal entries are exported.
      *====================================================================
     P Object_getLibrary...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.qObj.lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the type of the object whose journal entries are exported.
      *====================================================================
      *  Input :  void
      *
      *  Return:  type       - Type of the object whose journal entries
      *                        are exported.
      *====================================================================
     P Object_getType...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_state.objType;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Resets the error counter.
      *====================================================================
      *  Input :  void
      *
      *  Return:  void
      *====================================================================
     P Error_resetCounter...
     P                 B                   export
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.errCount = 0;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Increments the error counter by one.
      *====================================================================
      *  Input :  void
      *
      *  Return:  void
      *====================================================================
     P Error_incrementCounter...
     P                 B                   export
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_state.errCount = g_state.errCount + 1;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the number of errors.
      *====================================================================
      *  Input :  void
      *
      *  Return:  counter    - Number of errors that occured.
      *====================================================================
     P Error_getCounterAsString...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return %char(g_state.errCount);

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sends a status message.
      *====================================================================
      *  Input :  i_id       - Message ID.
      *           i_data     - Message data.
      *
      *  Return:  void
      *====================================================================
     P Message_sendStatusMsg...
     P                 B                   export
     D                 PI
     D  i_ID                               const  like(msg_t.ID   )
     D  i_data                             const  like(msg_t.data )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D c_data          C                   2
      *
      *  Local fields
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= c_data);
            msg = f_newMsg(i_ID: i_data: cMsg_Status);
         else;
            msg = f_newMsg(i_ID: '': cMsg_Status);
         endif;

         f_sndPgmMsg(msg: cMsg_Ext);

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sends a diagnostic message.
      *====================================================================
      *  Input :  i_id       - Message ID.
      *           i_data     - Message data.
      *
      *  Return:  void
      *====================================================================
     P Message_sendDiagMsg...
     P                 B                   export
     D                 PI
     D  i_msg                              value  likeds(msg_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         i_msg.type = cMsg_Diag;
         f_sndPgmMsg(i_msg: cMsg_Prv: cMsg_ToCtlBdy);

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Sends an escape message.
      *====================================================================
      *  Input :  i_id       - Message ID.
      *           i_data     - Message data.
      *
      *  Return:  void
      *====================================================================
     P Message_sendEscapeMsg...
     P                 B                   export
     D                 PI
     D  i_msg                              value  likeds(msg_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         i_msg.type = cMsg_Escape;
         f_sndPgmMsg(i_msg: cMsg_Prv: cMsg_ToCtlBdy);

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the current release level of the operating system.
      *====================================================================
      *  Input :  void
      *
      *  Return:  VxRxMx
      *====================================================================
     P System_getCurrentRelease...
     P                 B                   export
     D                 PI             6A
      *
      *  QSZRTVPR API
     D QSZRTVPR...
     D                 PR                  extpgm('QSZRTVPR')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  o_prodInf                 65535A   const  options(*varsize)
     D  io_errCode                65535A          options(*varsize)
      *
     D prdi0100        DS                  qualified
     D  productID              1      7A   inz('*OPSYS')
     D  releaseLvl             8     13A   inz('*CUR'  )
     D  productOpt            14     17A   inz('0000'  )
     D  loadID                18     27A   inz('*CODE' )
      *  Shortened!:
     D prdr0100        DS                  qualified
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  reserved_1             9     12I 0
     D  productID             13     19A
     D  releaseLvl            20     25A
      *
      *  API error code
     D errCode         DS                  likeds(errCode_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         errCode = f_newApiErrCode(cFalse);

         QSZRTVPR(prdr0100: %size(prdr0100): 'PRDR0100': prdi0100: errCode);

         return prdr0100.releaseLvl;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  Returns the name of the library that contains the output file.
      *====================================================================
      *  Input :  void
      *
      *  Return:  library-name
      *====================================================================
     P Application_getLibrary...
     P                 B                   export
     D                 PI            10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return sds.pgmLib;

      /END-FREE
     P                 E
      *
