FUNCTION zfu_sd_pedidos_liberar_d.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(EX_EBELN) TYPE  EBELN
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"  TABLES
*"      TA_PEDIDOS STRUCTURE  ZES_SD_PEDIDOS_LIBE
*"----------------------------------------------------------------------
  CLEAR: zg_e_ekkot, zg_t_ekpot[].

  SELECT SINGLE ebeln waers bedat lifnr
    FROM ekko
    INTO zg_e_ekkot
   WHERE ebeln = ex_ebeln.

  IF sy-subrc <> 0.
    EX_RETURN-codigo  = '4'.
    EX_RETURN-mensaje = 'Pedido No Existe'.
  ELSE.


    SELECT ebeln ebelp matnr werks knttp menge meins netpr
      FROM ekpo
      INTO TABLE zg_t_ekpot
     WHERE ebeln = zg_e_ekkot-ebeln.

    IF sy-subrc = 0.
      PERFORM f_set_salida_pedidos_pe TABLES ta_pedidos.
    ENDIF.
  ENDIF.


ENDFUNCTION.
