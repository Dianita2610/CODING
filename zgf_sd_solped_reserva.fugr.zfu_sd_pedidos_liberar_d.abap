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

* BEGIN. 06-07-2026 - ATC - ATC-01
* OLD CODE
*  SELECT SINGLE ebeln waers bedat lifnr
*    FROM ekko
*    INTO zg_e_ekkot
*   WHERE ebeln = ex_ebeln.
*
* NEW CODE
  SELECT ebeln waers bedat lifnr
  UP TO 1 ROWS 
    FROM ekko
    INTO zg_e_ekkot
   WHERE ebeln = ex_ebeln ORDER BY PRIMARY KEY.

  ENDSELECT.
* END. 06-07-2026 - ATC - ATC-01

  IF sy-subrc <> 0.
    EX_RETURN-codigo  = '4'.
    EX_RETURN-mensaje = 'Pedido No Existe'.
  ELSE.


* BEGIN. 06-07-2026 - ATC - ATC-03
* OLD CODE
*    SELECT ebeln ebelp matnr werks knttp menge meins netpr
*      FROM ekpo
*      INTO TABLE zg_t_ekpot
*     WHERE ebeln = zg_e_ekkot-ebeln.
*
* NEW CODE
    SELECT ebeln ebelp matnr werks knttp menge meins netpr

      FROM ekpo
      INTO TABLE zg_t_ekpot
     WHERE ebeln = zg_e_ekkot-ebeln ORDER BY PRIMARY KEY.

* END. 06-07-2026 - ATC - ATC-03

    IF sy-subrc = 0.
      PERFORM f_set_salida_pedidos_pe TABLES ta_pedidos.
    ENDIF.
  ENDIF.


ENDFUNCTION.
