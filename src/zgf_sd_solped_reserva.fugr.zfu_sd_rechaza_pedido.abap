FUNCTION zfu_sd_rechaza_pedido.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_EBELN) TYPE  EBELN
*"  EXPORTING
*"     VALUE(EX_RETURN) LIKE  ZES_SD_RETURN STRUCTURE  ZES_SD_RETURN
*"----------------------------------------------------------------------
  DATA lc_po  TYPE REF TO cl_po_header_handle_mm.
  DATA ls_document TYPE mepo_document.
  DATA lv_ebeln TYPE ekko-ebeln.

*  prepare creation of PO instance
  ls_document-doc_type    = 'F'.
  ls_document-process     = mmpur_po_process.
  ls_document-trtyp       = 'V'.
  ls_document-doc_key(10) = im_ebeln.
  ls_document-initiator-initiator = mmpur_initiator_rel.

*  object creation and initialization
  lv_ebeln = im_ebeln.
  CREATE OBJECT lc_po.
  lc_po->for_bapi = mmpur_yes.
  CALL METHOD lc_po->po_initialize( im_document = ls_document ).
  CALL METHOD lc_po->set_po_number( im_po_number = lv_ebeln ).
  CALL METHOD lc_po->set_state( cl_po_header_handle_mm=>c_available ).

*  read purchase order from database
  CALL METHOD lc_po->po_read
    EXPORTING
      im_tcode     = 'ME29N'
      im_trtyp     = ls_document-trtyp
      im_aktyp     = ls_document-trtyp
      im_po_number = lv_ebeln
      im_document  = ls_document.

  IF lc_po->if_releasable_mm~is_rejection_allowed( ) = 'X'.
    CALL METHOD lc_po->if_releasable_mm~reject
      EXPORTING
        im_reset = space
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.
  ELSE.
    ex_return-codigo = '4'.
    CONCATENATE '4-Pedido:' im_ebeln '-se encuentra Rechazado:' im_ebeln INTO ex_return-mensaje.
  ENDIF.

  CHECK ex_return-mensaje IS INITIAL.
  CALL METHOD lc_po->po_post
    EXCEPTIONS
      failure = 1
      OTHERS  = 2.

  IF sy-subrc = 0.
    PERFORM f_call_transaction_commit.
    ex_return-codigo  = '0'.
    ex_return-mensaje = '0-OK'.
  ELSE.
    ex_return-codigo = '4'.
    CONCATENATE '4-NO se pudo Rechazar el Pedido:' im_ebeln INTO ex_return-mensaje.
  ENDIF.

ENDFUNCTION.
