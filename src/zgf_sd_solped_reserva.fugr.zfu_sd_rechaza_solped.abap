FUNCTION zfu_sd_rechaza_solped.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_BANFN) TYPE  BANFN
*"     VALUE(IM_BNFPO) TYPE  BNFPO
*"  EXPORTING
*"     VALUE(EX_RETURN) LIKE  ZES_SD_RETURN STRUCTURE  ZES_SD_RETURN
*"----------------------------------------------------------------------
  DATA :lt_xeban TYPE STANDARD TABLE OF ueban.
  DATA: lt_xebkn TYPE STANDARD TABLE OF uebkn.
  DATA: lt_yeban TYPE STANDARD TABLE OF ueban.
  DATA: lt_yebkn TYPE STANDARD TABLE OF uebkn.
  DATA: ls_xeban TYPE ueban.
  DATA: ls_banpr TYPE eban-banpr.

  "Selecting the PR Details
  SELECT *
  FROM eban
  INTO CORRESPONDING FIELDS OF TABLE lt_xeban
  WHERE banfn = im_banfn
    AND bnfpo = im_bnfpo.

  IF sy-subrc = 0.
    "Selecting PR Accounting Details
    SELECT *
    FROM ebkn
    INTO CORRESPONDING FIELDS OF TABLE lt_xebkn
    WHERE banfn = im_banfn.

    "moving old data in internal table
    lt_yeban[] = lt_xeban[].
    lt_yebkn[] = lt_xebkn[].

    "passing the data of rejection
    LOOP AT lt_xeban INTO ls_xeban.
      ls_xeban-kz = 'U'.
      ls_xeban-banpr = '08'.
      MODIFY lt_xeban FROM ls_xeban.
    ENDLOOP.

    CALL FUNCTION 'ME_UPDATE_REQUISITION'
      TABLES
        xeban = lt_xeban
        xebkn = lt_xebkn
        yeban = lt_yeban
        yebkn = lt_yebkn.

    PERFORM f_call_transaction_commit.

    SELECT SINGLE banpr
      INTO ls_banpr
      FROM eban
     WHERE banfn = im_banfn
       AND bnfpo = im_bnfpo
       AND banpr = '08'.

      IF sy-subrc = 0.
        ex_return-codigo  = '0'.
        ex_return-mensaje = '0-Solped Rechazada satisfactoriamente!!!'.
      ELSE.
        ex_return-codigo  = '4'.
        ex_return-mensaje = '4-No Se pudo rechazar la solped'.
      ENDIF.
    ELSE.
      ex_return-codigo  = '4'.
      ex_return-mensaje = '4-No existe Solped o Posición'.
    ENDIF.

  ENDFUNCTION.
