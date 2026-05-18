**free
/if not defined(JRNETYPES)
/define JRNETYPES

// --------------------------------------------------
// Layouts for var.-length portion of journal entries
// --------------------------------------------------

// --------------------------------------------------
//   Data area
// --------------------------------------------------

// Common data area journal entry
dcl-ds jrnEType_e_t qualified based(pDummy);
  start  int(10);
  length int(10);
  decPos int(10);
  offset int(10);
  type   char(10);
end-ds;

// Update data area (E EA, E EB) journal entries
dcl-ds jrnEType_e_ea_t qualified based(pDummy);
  start  int(10);
  length int(10);
  decPos int(10);
  offset int(10);
  type   char(10);
end-ds;
// padding                     char (*)
// value                       char (*)

dcl-ds jrnEType_e_eb_t likeds(jrnEType_e_ea_t) based(pDummy);

// Create data area (E EE) journal entry
dcl-ds jrnEType_e_ee_t qualified based(pDummy);
  crtTmstmp    char(8);
  dtaAra_name  char(10);
  dtaAra_lib   char(10);
  type         char(5);
  reserved_1   char(3);
  numE         int(10);
  length       int(10);
  decPos       int(10);
  curLength    int(10);
  value        char(2000);
  pubAuth      char(10);
  text         char(50);
  owner        char(10);
  objExistAuth char(1);
  objMgtAuth   char(1);
  objOprAuth   char(1);
  reserved_2   char(1);
  authListMgt  char(1);
  readAuth     char(1);
  addAuth      char(1);
  updAuth      char(1);
  delAuth      char(1);
  exclAuth     char(1);
  execAuth     char(1);
  objAltAuth   char(1);
  objRefAuth   char(1);
  resultAuth   char(10);
end-ds;

// --------------------------------------------------
//   Data queue
// --------------------------------------------------

// Common data queue journal entry
dcl-ds jrnEType_q_t qualified based(pDummy);
  sysInf_1   char(16);
  sysInf_2   char(2);
  sysInf_3   char(10);
  order      char(2);
  keyLength  int(10);
  dataLength int(10);
  apiInf     char(16);
end-ds;
// key                         char (*)
// data                        char (*)

// Send data queue, has key (Q QK) journal entry
dcl-ds jrnEType_q_qk_t qualified based(pDummy);
  dataLength int(10);
  ofsData    int(10);
  reserved_1 char(2);
  keyLength  int(5);
  reserved_2 char(4);
end-ds;
// key                         char (*)
// padding                     char (*)
// data                        char (*)

// Received data queue, has key (Q QL) journal entry
dcl-ds jrnEType_q_ql_t qualified based(pDummy);
  sysInf_1  char(16);
  sysInf_2  char(2);
  keyLength int(5);
  order     char(2);
end-ds;
// key                         char (*)

// Data queue cleared, has key (Q QJ) journal entry
dcl-ds jrnEType_q_qj_t qualified based(pDummy);
  reserved_1 char(2);
  keyLength  int(5);
  order      char(2);
end-ds;
// key                         char (*)

// Send data queue, no key (Q QS) journal entry
dcl-ds jrnEType_q_qs_t qualified based(pDummy);
  sysInf_1   char(16);
  sysInf_2   char(2);
  sysInf_3   char(10);
  dataLength int(10);
end-ds;
// data                        char (*)

// Receive data queue entry, no key (Q QR)
dcl-ds jrnEType_q_qr_t qualified based(pDummy);
  sysInf_1 char(16);
  sysInf_2 char(2);
end-ds;

// Clear data queue entry, no key (Q QC)
dcl-ds jrnEType_q_qc_t qualified based(pDummy);
  sysInf_2 char(2);
end-ds;

/endif
