FUNCTION zfu_sd_solped_liberar.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  ACTORID
*"     VALUE(IM_TIPOLIB) TYPE  CHAR02
*"  EXPORTING
*"     VALUE(EX_RETURN) LIKE  ZES_SD_RETURN STRUCTURE  ZES_SD_RETURN
*"  TABLES
*"      TA_SOLPED_LIBE STRUCTURE  ZES_SD_SOLPED_LIBE
*"----------------------------------------------------------------------
  CLEAR: zg_t_t16fw[], zg_e_et16f.

  TRANSLATE im_usuario TO UPPER CASE.

  IF im_usuario IS INITIAL.
    ex_return-codigo  = '4'.
    ex_return-mensaje = 'Debe ingresar Usuario'.
  ELSE.

    SELECT mandt frggr frgco werks otype objid
      INTO TABLE zg_t_t16fw
      FROM t16fw
     WHERE frggr = 'SV'
       AND objid = im_usuario.

    IF sy-subrc = 0.
*        zg_e_et16f-frggr = zg_e_t16fw-frggr.
*        zg_e_et16f-frgco = zg_e_t16fw-frgco.

      PERFORM f_buscar_estrategia_usuario USING zg_e_et16f
                                                im_tipolib
                                       CHANGING ex_return.

      CHECK zg_t_ebant[] IS NOT INITIAL.
      PERFORM f_set_salida TABLES ta_solped_libe.
    ELSE.
****      SELECT SINGLE mandt frggr frgco objid
****        INTO zg_e_zt16f
****        FROM zt16fw
****       WHERE frggr = 'SV'
****         AND objid = im_usuario.
      SELECT mandt frggr frgco objid
        INTO TABLE zg_t_zt16f
        FROM zt16fw
       WHERE frggr = 'SV'
         AND objid = im_usuario.

      IF sy-subrc = 0.
*        zg_e_et16f-frggr = zg_e_zt16f-frggr.
*        zg_e_et16f-frgco = zg_e_zt16f-frgco.

        LOOP AT zg_t_zt16f INTO zg_e_zt16f.
          zg_e_t16fw-frggr = zg_e_zt16f-frggr.
          zg_e_t16fw-frgco = zg_e_zt16f-frgco.
          APPEND zg_e_t16fw TO zg_t_t16fw.
        ENDLOOP.

        PERFORM f_buscar_estrategia_usuario USING zg_e_et16f
                                                  im_tipolib
                                         CHANGING ex_return.

        CHECK zg_t_ebant[] IS NOT INITIAL.
        PERFORM f_set_salida TABLES ta_solped_libe.
      ELSE.
        ex_return-codigo  = '4'.
        ex_return-mensaje = 'Usuario No Asignado para codigo de liberación'.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
