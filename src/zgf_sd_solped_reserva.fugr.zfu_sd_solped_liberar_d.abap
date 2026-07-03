FUNCTION zfu_sd_solped_liberar_d.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_BANFN) TYPE  BANFN
*"     VALUE(IM_BNFPO) TYPE  BNFPO
*"  EXPORTING
*"     VALUE(EX_SOLPED) LIKE  ZES_SD_SOLPED_LIBE STRUCTURE
*"        ZES_SD_SOLPED_LIBE
*"     VALUE(EX_RETURN) LIKE  ZES_SD_RETURN STRUCTURE  ZES_SD_RETURN
*"----------------------------------------------------------------------
  DATA: zl_v_name TYPE thead-tdname.

  CLEAR: zg_e_t001w, zg_e_ebant, ex_solped.

  SELECT SINGLE banfn bnfpo badat ernam werks menge meins
    INTO zg_e_ebant
    FROM eban
   WHERE banfn = im_banfn
     AND bnfpo = im_bnfpo.

  IF sy-subrc = 0.
    SELECT SINGLE werks name1
      INTO zg_e_t001w
      FROM t001w
     WHERE werks = zg_e_ebant-werks.

    ex_solped-banfn = zg_e_ebant-banfn.
    ex_solped-bnfpo = zg_e_ebant-bnfpo.
    ex_solped-badat = zg_e_ebant-badat.
    ex_solped-ernam = zg_e_ebant-ernam.
    ex_solped-menge = zg_e_ebant-menge.
    ex_solped-meins = zg_e_ebant-meins.
    ex_solped-name1 = zg_e_t001w-name1.

    CONCATENATE zg_e_ebant-banfn zg_e_ebant-bnfpo INTO zl_v_name.
    PERFORM f_get_read_text USING 'B01' zl_v_name 'EBAN'
                         CHANGING ex_solped-texto.

    zl_v_name = zg_e_ebant-banfn.
    PERFORM f_get_read_text USING 'B01' zl_v_name 'EBANH'
                         CHANGING ex_solped-ncabe.

    ex_return-codigo  = '0'.
    ex_return-mensaje = 'OK'.
  ELSE.
    ex_return-codigo  = '4'.
    ex_return-mensaje = 'Posición de Solped no existe'.
  ENDIF.

ENDFUNCTION.
