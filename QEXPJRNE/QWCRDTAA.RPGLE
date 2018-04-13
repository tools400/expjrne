      /if not defined(QWCRDTAA)
      /define QWCRDTAA

      // Retrieve Data Area (QWCRDTAA) API
     d QWCRDTAA...
     d                 pr                  extpgm('QWCRDTAA')
     d  o_rcvVar                  65535a          options(*varsize)
     d  i_lenRcvVar                  10i 0 const
     d  i_qDtaAra                    20a   const
     d  i_start                      10i 0 const
     d  i_length                     10i 0 const
     d  io_errCode                65535a          options(*varsize)

      // Format of Data Returned (attributes and value)
     d rtvDtaAra_t...
     d                 ds                  qualified               based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  type                         10a
     d  lib                          10a
     d  length                       10i 0
     d  decPos                       10i 0
     d  value                      2000a

      // Format of Data Returned (attributes only)
     d rtvDtaAraA_t...
     d                 ds                  qualified               based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  type                         10a
     d  lib                          10a
     d  length                       10i 0
     d  decPos                       10i 0

      /endif
