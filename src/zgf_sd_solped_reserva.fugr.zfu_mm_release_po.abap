FUNCTION zfu_mm_release_po.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_EBELN) TYPE  EBELN
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"----------------------------------------------------------------------

  IF im_ebeln IS NOT INITIAL.
    SELECT SINGLE ebeln waers bedat lifnr frggr frgsx frgke frgzu
      FROM ekko
      INTO zg_e_ekko2
     WHERE ebeln = im_ebeln.

    IF sy-subrc = 0.
      IF zg_e_ekko2-frgke <> '2'.

        SELECT mandt frggr frgsx frgco frga1 frga2 frga3 frga4 frga5
           frga6 frga7 frga8
          FROM t16fv
          INTO TABLE zg_t_t16fv
         WHERE frggr = zg_e_ekko2-frggr
           AND frgsx = zg_e_ekko2-frgsx.

        IF sy-subrc = 0.

          LOOP AT zg_t_t16fv INTO zg_e_t16fv.
            IF zg_e_ekko2-frgzu = ''            AND zg_e_t16fv-frga1 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'X'       AND zg_e_t16fv-frga2 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XX'      AND zg_e_t16fv-frga3 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XXX'     AND zg_e_t16fv-frga4 = 'X'..
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XXXX'    AND zg_e_t16fv-frga5 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XXXXX'   AND zg_e_t16fv-frga6 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XXXXXX'  AND zg_e_t16fv-frga7 = 'X'.
              EXIT.
            ELSEIF zg_e_ekko2-frgzu = 'XXXXXXX' AND zg_e_t16fv-frga8 = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          CALL FUNCTION 'BAPI_PO_RELEASE'
            EXPORTING
              purchaseorder          = im_ebeln
              po_rel_code            = zg_e_t16fv-frgco
              use_exceptions         = ''
            TABLES
              return                 = zg_t_retur
            EXCEPTIONS
              authority_check_fail   = 1
              document_not_found     = 2
              enqueue_fail           = 3
              prerequisite_fail      = 4
              release_already_posted = 5
              responsibility_fail    = 6
              OTHERS                 = 7.
          READ TABLE zg_t_retur INTO zg_e_retur WITH KEY type = 'E'.
          IF sy-subrc = 0.
            ex_return-codigo  = '4'.
            CONCATENATE '4-' zg_e_retur-message INTO ex_return-mensaje.
            "ex_return-mensaje = zg_e_retur-message.
          ELSE.
            PERFORM f_call_transaction_commit.
            ex_return-codigo  = '0'.
            ex_return-mensaje = '0-Liberado Exitosamente!!!'.
          ENDIF.
        ELSE.
          ex_return-codigo  = '4'.
          ex_return-mensaje = '4-Doc. Compra, No posee requisitos para liberación'.
        ENDIF.
      ELSE.
        ex_return-codigo  = '4'.
        ex_return-mensaje = '4-Doc. Compra se encuentra liberado'.
      ENDIF.
    ELSE.
      ex_return-codigo  = '4'.
      ex_return-mensaje = '4-No existe Doc. Compra'.
    ENDIF.
  ELSE.
    ex_return-codigo  = '4'.
    ex_return-mensaje = '4-Doc. Compra vacio'.
  ENDIF.

ENDFUNCTION.
