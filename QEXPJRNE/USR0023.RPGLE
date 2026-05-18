**FREE
// ---------------------------------------------------------------
//  Data structure for message ID: USR0023

//  &1: &2

dcl-ds USR0023;
  USR00231        packed(0010) inz(*ZEROS );
  USR00232        char(0256) inz(*BLANKS);
end-ds;
dcl-s USR0023_SIZE    int(10) inz(0262);
