      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER2                                          *
      *  Description . : Export Journal Entries - CHOICE                    *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 23.12.2002                                         *
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
      *  19.09.2008  Th.Raddatz    Replace copy book FDJOBI0400 by          *
      *                            QUSRJOBI.                                *
      *                                                                     *
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
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
      /COPY QEXPJRNE,H_SPEC
      *=====================================================================*
      *
      *  Constants
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Exported prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     D EXPJRNER2...
     D                 PR                  extpgm('EXPJRNER2')
     D  gi_parm1                     21A   const
     D  gio_parm2                  2000A
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Internal prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     D main...
     D                 PR
     D  i_parm1                            const  like(gi_parm1  )
     D  io_parm2                                  like(gio_parm2 )
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  External prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER7
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
      *=====================================================================*
      *  Program entry point
      *=====================================================================*
      *
     D EXPJRNER2...
     D                 PI
     D  gi_parm1                     21A   const
     D  gio_parm2                  2000A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_parm1: gio_parm2);

         *inlr = *on;

      /END-FREE
      *
      *====================================================================
      *  Main control block with local fields
      *====================================================================
      *
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_parm1                            const  like(gi_parm1  )
     D  io_parm2                                  like(gio_parm2 )
      *
      *  Local fields
     D parm1           DS                  qualified
     D  cmd                          10A   inz
     D  kwd                          10A   inz
     D  type                          1A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         parm1 = i_parm1;

         select;
         when (parm1.kwd = 'FROMDATE' or parm1.kwd = 'TODATE');
            io_parm2 = 'Date (' + rtvJobDateFmt() + ')';
         when (parm1.kwd = 'OBJTYPE');
            if (System_getCurrentRelease() <= 'V5R3M0');
               io_parm2 = '*FILE';
            else;
               io_parm2 = '*FILE, *DTAARA, *DTAQ';
            endif;
         endsl;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
