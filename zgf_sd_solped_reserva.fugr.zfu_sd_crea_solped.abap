FUNCTION zfu_sd_crea_solped.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  EXPORTING
*"     VALUE(EX_SOLPED) TYPE  BANFN
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"  TABLES
*"      TA_ITEMS STRUCTURE  ZES_SD_SOLPED
*"----------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------*
* Declaración Variables
*--------------------------------------------------------------------------------------------------*
  DATA: zl_v_texto TYPE c LENGTH 200.
  DATA: zl_v_indic TYPE c LENGTH 1.
  DATA: zl_v_text  TYPE c LENGTH 220.

*--------------------------------------------------------------------------------------------------*
  CLEAR: zg_t_items[], zg_t_itemt[], zg_t_servi[], zg_t_retur[], zg_e_items, zg_e_itemt,
         zg_e_servi, zg_e_retur, zg_v_banfn.

  IF ta_items[] IS INITIAL.
    zl_v_texto = 'Estructura de Pos. Solped sin Registros.'.
  ELSE.
    PERFORM f_valida_campos TABLES ta_items
                          CHANGING zl_v_indic
                                   zl_v_texto.

    IF zl_v_indic IS INITIAL.
      PERFORM f_set_items_text TABLES ta_items.

      CALL FUNCTION 'BAPI_REQUISITION_CREATE' "#EC CI_USAGE_OK[2438131]
*       EXPORTING
*         SKIP_ITEMS_WITH_ERROR                =
*         AUTOMATIC_SOURCE                     = 'X'
       IMPORTING
         number                               = zg_v_banfn
        TABLES
          requisition_items                    = zg_t_items
*         REQUISITION_ACCOUNT_ASSIGNMENT       =
         requisition_item_text                = zg_t_itemt
*         REQUISITION_LIMITS                   =
*         REQUISITION_CONTRACT_LIMITS          =
         requisition_services                 = zg_t_servi
*         REQUISITION_SRV_ACCASS_VALUES        =
         return                               = zg_t_retur
*         REQUISITION_SERVICES_TEXT            =
*         REQUISITION_ADDRDELIVERY             =
*         EXTENSIONIN                          =
                .

      READ TABLE zg_t_retur INTO zg_e_retur WITH KEY type = 'E'.
      IF sy-subrc = 0.
        PERFORM f_get_message_s USING zg_e_retur
                             CHANGING zl_v_text.
        ex_solped         = ''.
        ex_return-codigo  = '4'.
        ex_return-mensaje = zl_v_text.
      ELSE.
        PERFORM f_call_transaction_commit.
        ex_solped         = zg_v_banfn.
        ex_return-codigo  = '0'.
        ex_return-mensaje = 'OK'.
      ENDIF.
    ELSE.
      ex_solped         = ''.
      ex_return-codigo  = '4'.
      ex_return-mensaje = zl_v_texto.
    ENDIF.
  ENDIF.

ENDFUNCTION.
