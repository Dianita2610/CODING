FUNCTION zfu_sd_crea_reserva.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_HEADER) LIKE  ZES_SD_RESER_CA STRUCTURE
*"        ZES_SD_RESER_CA
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"     VALUE(EX_RSNUM) TYPE  RSNUM
*"  TABLES
*"      TA_DETAIL STRUCTURE  ZES_SD_RESER_DE
*"----------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------*
* Declaración Variables
*--------------------------------------------------------------------------------------------------*
  DATA: zl_v_texto TYPE c LENGTH 200.
  DATA: zl_v_indic TYPE c LENGTH 1.
  DATA: zl_v_text  TYPE c LENGTH 220.

*--------------------------------------------------------------------------------------------------*
  CLEAR: zg_t_itemp[], zg_t_retor[].

  IF im_header-bdter = '00000000' OR im_header-werks_d = '' OR im_header-kostl = ''.
    zl_v_texto = 'Existen Datos de Estructura de Cabecera vacia'.
    zl_v_indic = 'X'.
  ENDIF.

  IF ta_detail[] IS INITIAL AND zl_v_indic = ''.
    zl_v_texto = 'Estructura de Pos. Sin Registros'.
  ELSE.

    PERFORM f_valida_campos_re TABLES ta_detail
                             CHANGING zl_v_indic
                                      zl_v_texto.

    IF zl_v_indic IS INITIAL.
      CLEAR: zg_e_heade.
      zg_e_heade-res_date   = im_header-bdter.
      zg_e_heade-move_type  = '201'.
      zg_e_heade-costcenter = im_header-kostl.

      PERFORM f_set_items_re TABLES ta_detail
                              USING im_header.

      CALL FUNCTION 'BAPI_RESERVATION_CREATE1'
        EXPORTING
          reservationheader          = zg_e_heade
       IMPORTING
         reservation                = ex_rsnum
        TABLES
          reservationitems           = zg_t_itemr
          profitabilitysegment       = zg_t_itemp
          return                     = zg_t_retor
*         EXTENSIONIN                =
                .

      READ TABLE zg_t_retor INTO zg_e_retor WITH KEY type = 'E'.
      IF sy-subrc = 0.
        PERFORM f_get_message   USING zg_e_retor
                             CHANGING zl_v_text.

        ex_return-codigo  = '4'.
        ex_return-mensaje = zl_v_text.
      ELSE.
        PERFORM f_call_transaction_commit.
        ex_return-codigo  = '0'.
        ex_return-mensaje = 'OK'.
      ENDIF.
    ELSE.
      ex_rsnum          = ''.
      ex_return-codigo  = '4'.
      ex_return-mensaje = zl_v_texto.
    ENDIF.
  ENDIF.

ENDFUNCTION.
