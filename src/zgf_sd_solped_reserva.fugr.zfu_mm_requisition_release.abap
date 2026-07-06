FUNCTION zfu_mm_requisition_release.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_BANFN) TYPE  BANFN
*"     VALUE(IM_BNFPO) TYPE  BNFPO
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"----------------------------------------------------------------------

  IF im_banfn IS NOT INITIAL AND im_bnfpo IS NOT INITIAL.
* BEGIN. 06-07-2026 - ATC - ATC-01
* OLD CODE
*    SELECT SINGLE banfn bnfpo badat ernam werks menge meins matnr frgst frgzu frggr frgkz
*        INTO zg_e_eban2
*        FROM eban
*       WHERE banfn EQ im_banfn
*         AND bnfpo EQ im_bnfpo.
*
* NEW CODE
    SELECT banfn bnfpo badat ernam werks menge meins matnr frgst frgzu frggr frgkz
    UP TO 1 ROWS 
        INTO zg_e_eban2
        FROM eban
       WHERE banfn EQ im_banfn
         AND bnfpo EQ im_bnfpo ORDER BY PRIMARY KEY.

    ENDSELECT.
* END. 06-07-2026 - ATC - ATC-01

    IF sy-subrc = 0.
      IF zg_e_eban2-frgkz <> '2'.

* BEGIN. 06-07-2026 - ATC - ATC-03
* OLD CODE
*        SELECT mandt frggr frgsx frgco frga1 frga2 frga3 frga4 frga5
*           frga6 frga7 frga8
*          FROM t16fv
*          INTO TABLE zg_t_t16fv
*         WHERE frggr = zg_e_eban2-frggr
*           AND frgsx = zg_e_eban2-frgst.
*
* NEW CODE
        SELECT mandt frggr frgsx frgco frga1 frga2 frga3 frga4 frga5
           frga6 frga7 frga8

          FROM t16fv
          INTO TABLE zg_t_t16fv
         WHERE frggr = zg_e_eban2-frggr
           AND frgsx = zg_e_eban2-frgst ORDER BY PRIMARY KEY.

* END. 06-07-2026 - ATC - ATC-03

        IF sy-subrc = 0.

          LOOP AT zg_t_t16fv INTO zg_e_t16fv.
            IF zg_e_eban2-frgzu = ''            AND zg_e_t16fv-frga1 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'X'       AND zg_e_t16fv-frga2 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XX'      AND zg_e_t16fv-frga3 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XXX'     AND zg_e_t16fv-frga4 = 'X'..
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XXXX'    AND zg_e_t16fv-frga5 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XXXXX'   AND zg_e_t16fv-frga6 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XXXXXX'  AND zg_e_t16fv-frga7 = 'X'.
              EXIT.
            ELSEIF zg_e_eban2-frgzu = 'XXXXXXX' AND zg_e_t16fv-frga8 = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          CALL FUNCTION 'BAPI_REQUISITION_RELEASE'
            EXPORTING
              number                       = im_banfn
              rel_code                     = zg_e_t16fv-frgco
              item                         = im_bnfpo
             use_exceptions                = ''
*           NO_COMMIT_WORK               = ' '
*         IMPORTING
*           REL_STATUS_NEW               =
*           REL_INDICATOR_NEW            =
           TABLES
             return                       = zg_t_retur
           EXCEPTIONS
             authority_check_fail         = 1
             requisition_not_found        = 2
             enqueue_fail                 = 3
             prerequisite_fail            = 4
             release_already_posted       = 5
             responsibility_fail          = 6
             OTHERS                       = 7.

          READ TABLE zg_t_retur INTO zg_e_retur WITH KEY type = 'E'.
          IF sy-subrc = 0.
            ex_return-codigo  = '4'.
            CONCATENATE '4-' zg_e_retur-message INTO ex_return-mensaje.
*            ex_return-mensaje = zg_e_retur-message.
          ELSE.
            PERFORM f_call_transaction_commit.
            ex_return-codigo  = '0'.
            ex_return-mensaje = '0-Liberado Exitosamente!!!'.
          ENDIF.
        ELSE.
          ex_return-codigo  = '4'.
          ex_return-mensaje = '4-Solped, No posee requisitos para liberación'.
        ENDIF.
      ELSE.
        ex_return-codigo  = '4'.
        ex_return-mensaje = '4-No existe Solped'.
      ENDIF.
    ELSE.
      ex_return-codigo  = '4'.
      ex_return-mensaje = '4-Solped se encuentra liberada'.
    ENDIF.
  ELSE.
    ex_return-codigo  = '4'.
    ex_return-mensaje = '4-Solped o Num.Solped vacio'.
  ENDIF.

ENDFUNCTION.
