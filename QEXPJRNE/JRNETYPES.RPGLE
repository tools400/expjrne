      /if not defined(JRNETYPES)
      /define JRNETYPES

      // --------------------------------------------------
      // Layouts for var.-length portion of journal entries
      // --------------------------------------------------

      // --------------------------------------------------
      //   Data area
      // --------------------------------------------------

      // Common data area journal entry
     d jrnEType_e_t...
     d                 ds                  qualified               based(pDummy)
     d  start                        10i 0
     d  length                       10i 0
     d  decPos                       10i 0
     d  offset                       10i 0
     d  type                         10a

      // Update data area (E EA, E EB) journal entries
     d jrnEType_e_ea_t...
     d                 ds                  qualified               based(pDummy)
     d  start                        10i 0
     d  length                       10i 0
     d  decPos                       10i 0
     d  offset                       10i 0
     d  type                         10a
      // padding                     char (*)
      // value                       char (*)

     d jrnEType_e_eb_t...
     d                 ds                  likeds(jrnEType_e_ea_t) based(pDummy)

      // Create data area (E EE) journal entry
     d jrnEType_e_ee_t...
     d                 ds                  qualified               based(pDummy)
     d  crtTmstmp                     8a
     d  dtaAra_name                  10a
     d  dtaAra_lib                   10a
     d  type                          5a
     d  reserved_1                    3a
     d  numE                         10i 0
     d  length                       10i 0
     d  decPos                       10i 0
     d  curLength                    10i 0
     d  value                      2000a
     d  pubAuth                      10a
     d  text                         50a
     d  owner                        10a
     d  objExistAuth                  1a
     d  objMgtAuth                    1a
     d  objOprAuth                    1a
     d  reserved_2                    1a
     d  authListMgt                   1a
     d  readAuth                      1a
     d  addAuth                       1a
     d  updAuth                       1a
     d  delAuth                       1a
     d  exclAuth                      1a
     d  execAuth                      1a
     d  objAltAuth                    1a
     d  objRefAuth                    1a
     d  resultAuth                   10a

      // --------------------------------------------------
      //   Data queue
      // --------------------------------------------------

      // Common data queue journal entry
     d jrnEType_q_t...
     d                 ds                  qualified               based(pDummy)
     d  sysInf_1                     16a
     d  sysInf_2                      2a
     d  sysInf_3                     10a
     d  order                         2a
     d  keyLength                    10i 0
     d  dataLength                   10i 0
     d  apiInf                       16a
      // key                         char (*)
      // data                        char (*)

      // Send data queue, has key (Q QK) journal entry
     d jrnEType_q_qk_t...
     d                 ds                  qualified               based(pDummy)
     d  dataLength                   10i 0
     d  ofsData                      10i 0
     d  reserved_1                    2a
     d  keyLength                     5i 0
     d  reserved_2                    4a
      // key                         char (*)
      // padding                     char (*)
      // data                        char (*)

      // Received data queue, has key (Q QL) journal entry
     d jrnEType_q_ql_t...
     d                 ds                  qualified               based(pDummy)
     d  sysInf_1                     16a
     d  sysInf_2                      2a
     d  keyLength                     5i 0
     d  order                         2a
      // key                         char (*)

      // Data queue cleared, has key (Q QJ) journal entry
     d jrnEType_q_qj_t...
     d                 ds                  qualified               based(pDummy)
     d  reserved_1                    2a
     d  keyLength                     5i 0
     d  order                         2a
      // key                         char (*)

      // Send data queue, no key (Q QS) journal entry
     d jrnEType_q_qs_t...
     d                 ds                  qualified               based(pDummy)
     d  sysInf_1                     16a
     d  sysInf_2                      2a
     d  sysInf_3                     10a
     d  dataLength                   10i 0
      // data                        char (*)

      // Receive data queue entry, no key (Q QR)
     d jrnEType_q_qr_t...
     d                 ds                  qualified               based(pDummy)
     d  sysInf_1                     16a
     d  sysInf_2                      2a

      // Clear data queue entry, no key (Q QC)
     d jrnEType_q_qc_t...
     d                 ds                  qualified               based(pDummy)
     d  sysInf_2                      2a

      /endif
