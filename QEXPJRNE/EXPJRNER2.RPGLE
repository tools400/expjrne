**free
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER2                                          *
//  Description . : Export Journal Entries - CHOICE                    *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 23.12.2002                                         *
//                                                                     *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Date        Name          Comment                                  *
//  ----------  ------------  ---------------------------------------  *
//  19.09.2008  Th.Raddatz    Replace copy book FDJOBI0400 by          *
//                            QUSRJOBI.                                *
//                                                                     *
//  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
//                            object types, starting with *DTAARA.     *
//                                                                     *
//=====================================================================*
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//   >>IMPORTANT<<                                                     *
//     >>PARM<< TRUNCNBR(*NO);                                         *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< OPTION(*EVENTF);                                       *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//   >>END-IMPORTANT<<                                                 *
//   >>EXECUTE<<                                                       *
// >>END-PRE-COMPILER<<                                                *
//=====================================================================*
/copy QEXPJRNE,H_SPEC
//=====================================================================*
//
//  Constants
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Exported prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dcl-pr EXPJRNER2 extpgm('EXPJRNER2');
  gi_parm1  char(21) const;
  gio_parm2 char(2000);
end-pr;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Internal prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dcl-pr main;
  i_parm1  like(gi_parm1) const;
  io_parm2 like(gio_parm2);
end-pr;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  External prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/copy QBASICS1,PBASICS1                      Tools/400 Runtime Library

/define EXPJRNE_PROTOTYPE
/copy QEXPJRNE,EXPJRNER7
/undefine EXPJRNE_PROTOTYPE

//=====================================================================*
//  Program entry point
//=====================================================================*
dcl-pi EXPJRNER2;
  gi_parm1  char(21) const;
  gio_parm2 char(2000);
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(gi_parm1: gio_parm2);

*inlr = *on;


//====================================================================
//  Main control block with local fields
//====================================================================

dcl-proc main;
  dcl-pi *n;
    i_parm1  like(gi_parm1) const;
    io_parm2 like(gio_parm2);
  end-pi;

  //  Local fields
  dcl-ds parm1 qualified;
    cmd  char(10) inz;
    kwd  char(10) inz;
    type char(1) inz;
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

