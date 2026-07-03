*----------------------------------------------------------------------*
***INCLUDE ZPR_MM_MAESTRO_MATE_SERV_F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.

  PERFORM f_get_log.
  PERFORM f_get_mara.
  PERFORM f_get_asmd.

ENDFORM.                    " F_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_mara .
  CLEAR: zg_t_mara[], zg_t_makt[].

  IF s_matnr[] IS INITIAL.
    SELECT matnr mtart meins ersda laeda
      INTO TABLE zg_t_mara
      FROM mara
     WHERE "matnr IN s_matnr
          ( ersda IN s_ersda ) OR
          ( laeda IN s_ersda ).
  ELSE.
    SELECT matnr mtart meins ersda laeda
      INTO TABLE zg_t_mara
      FROM mara
     WHERE matnr IN s_matnr.
  ENDIF.

  IF sy-subrc = 0.
    SELECT matnr maktx
      INTO TABLE zg_t_makt
      FROM makt
      FOR ALL ENTRIES IN zg_t_mara
     WHERE matnr = zg_t_mara-matnr
       AND spras = 'S'.
  ENDIF.

ENDFORM.                    " F_GET_MARA
*&---------------------------------------------------------------------*
*&      Form  F_GET_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_log .
  CLEAR: zg_t_loge[].

  IF s_ersda[] IS INITIAL.
    SELECT mandt progr fecha hora
      INTO TABLE zg_t_loge
      FROM zta_mm_log_eje.

    IF sy-subrc = 0.
      SORT zg_t_loge DESCENDING BY fecha.

      READ TABLE zg_t_loge INTO zg_e_loge INDEX 1.
      IF sy-subrc = 0.
        s_ersda-option  = 'GE'.
        s_ersda-sign    = 'I'.
        s_ersda-low     = zg_e_loge-fecha.
        APPEND s_ersda.
      ENDIF.
    ELSE.
      s_ersda-option  = 'GE'.
      s_ersda-sign    = 'I'.
      s_ersda-low     = sy-datum.
      APPEND s_ersda.
    ENDIF.
  ENDIF.

ENDFORM.                    " F_GET_LOG
*&---------------------------------------------------------------------*
*&      Form  F_GET_ASMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_asmd.
  CLEAR: zg_t_asmd[], zg_t_asmt[].

  SELECT asnum astyp meins erdat aedat
    INTO TABLE zg_t_asmd
    FROM asmd
   WHERE ( erdat IN s_ersda ) OR
         ( aedat IN s_ersda ).

  IF sy-subrc = 0.
    SELECT asnum asktx
      INTO TABLE zg_t_asmt
      FROM asmdt
      FOR ALL ENTRIES IN zg_t_asmd
     WHERE asnum = zg_t_asmd-asnum
       AND spras = 'S'.
  ENDIF.

ENDFORM.                    " F_GET_ASMD
*&---------------------------------------------------------------------*
*&      Form  F_SET_STRUCTURE_OUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_structure_out .
  CLEAR: zg_t_prxo[], zg_e_prxo.

  LOOP AT zg_t_mara INTO zg_e_mara.
    zg_e_prxo-material      = zg_e_mara-matnr.
    zg_e_prxo-tipo          = zg_e_mara-mtart.
    zg_e_prxo-unidad_medida = zg_e_mara-meins.

    READ TABLE zg_t_makt INTO zg_e_makt WITH KEY matnr = zg_e_mara-matnr.
    IF sy-subrc = 0.
      zg_e_prxo-descripcion = zg_e_makt-maktx.
    ENDIF.

    APPEND zg_e_prxo TO zg_t_prxo.
  ENDLOOP.

  LOOP AT zg_t_asmd INTO zg_e_asmd.
    zg_e_prxo-material      = zg_e_asmd-asnum.
    zg_e_prxo-tipo          = zg_e_asmd-astyp.
    zg_e_prxo-unidad_medida = zg_e_asmd-meins.

    READ TABLE zg_t_asmt INTO zg_e_asmt WITH KEY asnum = zg_e_asmd-asnum.
    IF sy-subrc = 0.
      zg_e_prxo-descripcion = zg_e_asmt-asktx.
    ENDIF.

    APPEND zg_e_prxo TO zg_t_prxo.
  ENDLOOP.

ENDFORM.                    " F_SET_STRUCTURE_OUT
*&---------------------------------------------------------------------*
*&      Form  F_SEND_DATA_PI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_data_pi .
  DATA: zl_o_proxy TYPE REF TO zco_mi_solped_legado_maestro_m.
  DATA: zl_e_outpu TYPE zmt_solped_legado_maestro_mat1.
  DATA: zl_e_input TYPE zmt_solped_legado_maestro_mate.
  DATA: zl_o_sysex TYPE REF TO cx_ai_system_fault.
  DATA: zl_o_exobj TYPE REF TO cx_sy_create_object_error.
  DATA: zl_s_retur TYPE string.
  data: zl_v_texto TYPE c LENGTH 200.

  LOOP AT zg_t_prxo INTO zg_e_prxo.
    CLEAR: zl_e_input, zl_s_retur, zl_e_outpu-mt_solped_legado_maestro_mater, zl_v_texto.

    zl_e_outpu-mt_solped_legado_maestro_mater = zg_e_prxo.

    TRY.
        TRY.
            CREATE OBJECT zl_o_proxy.

            CALL METHOD zl_o_proxy->mi_solped_legado_maestro_mater
              EXPORTING
                output = zl_e_outpu
              IMPORTING
                input  = zl_e_input.
          CATCH cx_ai_system_fault INTO zl_o_sysex.
            zl_s_retur = zl_o_sysex->get_longtext( ).
            zl_s_retur = zl_o_sysex->get_text( ).
        ENDTRY.

      CATCH cx_sy_create_object_error INTO zl_o_exobj.
        zl_s_retur = zl_o_exobj->get_longtext( ).
        zl_s_retur = zl_o_exobj->get_text( ).
    ENDTRY.

    CONCATENATE zg_e_prxo-material '-' zl_e_input-MT_SOLPED_LEGADO_MAESTRO_MATER-mensaje
      INTO zl_v_texto.
    write:  zl_v_texto, /.
  ENDLOOP.

ENDFORM.                    " F_SEND_DATA_PI
