*&---------------------------------------------------------------------*
*& Report: < ZEY_GDS_CORRECTION > *
*& Author: < EY_DES01 > *
*& Description: < ReSQ Correction > *
*& Date: <19-12-2019> *
*& Transport Number: < ECDK917080 > *
*&---------------------------------------------------------------------*
FUNCTION zfu_sd_pedidos_liberar_h.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  ACTORID
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZES_SD_RETURN
*"  TABLES
*"      TA_PEDIDOS STRUCTURE  ZES_SD_PEDIDOS_LIBE
*"----------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------*
* Declaración Tablas Internas                                                                      *
*--------------------------------------------------------------------------------------------------*
  DATA: zg_t_pedidos TYPE TABLE OF zes_sd_pedidos_libe.

*--------------------------------------------------------------------------------------------------*
* Declaración Work areas                                                                           *
*--------------------------------------------------------------------------------------------------*
  DATA: zg_e_pedidos TYPE zes_sd_pedidos_libe.

*--------------------------------------------------------------------------------------------------*
* Declaración Variables                                                                            *
*--------------------------------------------------------------------------------------------------*
  DATA: zg_v_monto     TYPE menge_d.
  DATA: zg_v_netpr     TYPE netpr.
  DATA: zg_v_indic     TYPE i.
*------------------------------------------------------------->

  TRANSLATE im_usuario TO UPPER CASE.

  CALL FUNCTION 'ZFU_SD_PEDIDOS_LIBERAR'
    EXPORTING
      im_usuario = im_usuario
      im_tipolib = 'PE'
    IMPORTING
      ex_return  = ex_return
    TABLES
      ta_pedidos = zg_t_pedidos.

  ta_pedidos[] = zg_t_pedidos[].

*Begin of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
SORT TA_PEDIDOS BY EBELN .
*End of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
  DELETE ADJACENT DUPLICATES FROM ta_pedidos COMPARING ebeln.

*Begin of change: ReSQ Correction for MODIFY on an unsorted Internal Table 19/12/2019 EY_DES01 ECDK917080 *
SORT TA_PEDIDOS .
*End of change: ReSQ Correction for MODIFY on an unsorted Internal Table 19/12/2019 EY_DES01 ECDK917080 *
  LOOP AT ta_pedidos.
    CLEAR: zg_v_monto, zg_v_indic, zg_v_netpr.

    zg_v_indic = sy-tabix.
    LOOP AT zg_t_pedidos INTO zg_e_pedidos WHERE ebeln = ta_pedidos-ebeln.
      zg_v_monto = zg_v_monto + zg_e_pedidos-menge.
      zg_v_netpr = zg_v_netpr + zg_e_pedidos-total.
    ENDLOOP.

    IF zg_v_monto > 0.
      ta_pedidos-menge = zg_v_monto.
      ta_pedidos-total = zg_v_netpr.
      MODIFY ta_pedidos INDEX zg_v_indic TRANSPORTING menge total.
    ENDIF.
  ENDLOOP.

  IF ta_pedidos[] IS NOT INITIAL.
    ex_return-codigo  = '0'.
    ex_return-mensaje = 'OK'.
  ELSE.
    ex_return-codigo  = '4'.
    ex_return-mensaje = 'No existen Pedidos'.
  ENDIF.

ENDFUNCTION.
