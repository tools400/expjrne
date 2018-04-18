/* --------------------------------------------------------------- */
/* EXPJRNE    - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QEXPJRNE) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QEXPJRNE)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG ) XMBRATR(CLP  ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_GER ) XMBRATR(CLP  ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB2     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EXPJRNE.PF) XMBRATR(PF   ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EXPJRNE.SQ) XMBRATR(SQL  ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EXPJRNEC  ) XMBRATR(MAKPGM) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNECC ) XMBRATR(MAKPGM) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNECP ) XMBRATR(MAKPGM) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNECR ) XMBRATR(MAKPGM) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNECU ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNEC1 ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*CMD   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EXPJRNEE  ) XMBRATR(CMD   ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNEG  ) XMBRATR(CMD   ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNEPE ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNEPG ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER1 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER2 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER3 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER4 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER5 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER6 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNER7 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(EXPJRNEV  ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDINFDS   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDOBJD0400) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(FDQJOB    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(JRNETYPES ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QMHQRDQD  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSRJOBI  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSROBJD  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(QWCRDTAA  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(SDS       ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(SQL       ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(SQLCLI    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(TXT0001   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0012   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0018   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO)  XPARAM(*BLANKS)

             XMLGENMBR  XMBR(USR0019   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0020   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0021   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0022   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0023   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0024   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0025   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0026   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(USR0027   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEXPJRNE  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEXPJRNE  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QEXPJRNE  ) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&LANG'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

