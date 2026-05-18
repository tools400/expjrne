**free
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER1                                          *
//  Description . : Export Journal Entries - POP                       *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 19.09.2008                                         *
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

dcl-pr PGM_ENTRY_POINT extpgm('EXPJRNER1');
  gi_cmd    char(20) const;
  go_string varchar(32767);
end-pr;

//  Main procedure
dcl-pr main;
  i_cmd    like(gi_cmd) const;
  o_string like(go_string);
end-pr;

//==================================================================*
//  Program entry point
//==================================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_cmd    char(20) const;
  go_string varchar(32767);
end-pi;
//-------------------------------------------------------------------

main(gi_cmd: go_string);

*inlr = *on;


//==================================================================*
//  Main procedure
//==================================================================*

dcl-proc main;
  dcl-pi *n;
    i_cmd    like(gi_cmd) const;
    o_string like(go_string);
  end-pi;

  dcl-s today date inz;
  //-------------------------------------------------------------------

  today = %date();

  o_string = '??FROMDATE(' + %char(today: *JOBRUN0) + ') ' +
             '??TODATE(' + %char(today: *JOBRUN0) + ') ' +
             '??FROMTIME(000000) ' +
             '??TOTIME(235959)';

end-proc;

