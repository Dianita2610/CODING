*&---------------------------------------------------------------------*
*& Report: < ZEY_GDS_CORRECTION > *
*& Author: < EY_DES01 > *
*& Description: < ReSQ Correction > *
*& Date: <19-12-2019> *
*& Transport Number: < ECDK917080 > *
*&---------------------------------------------------------------------*
FUNCTION zfu_sd_num_solped_pedidos.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_USUARIO) TYPE  ACTORID
*"  EXPORTING
*"     VALUE(EX_NUM_SOLPED) TYPE  INT1
*"     VALUE(EX_NUM_PEDIDOS) TYPE  INT1
*"----------------------------------------------------------------------
* Definición Tablas Internas
*--------------------------------------------------------------------------------------------------*
  DATA: zg_t_pedidos TYPE TABLE OF zes_sd_pedidos_libe.
  DATA: zg_t_solpedi TYPE TABLE OF zes_sd_solped_libe.
*"-------------------------------------------------------------------------------------------------*
* Definición Estructuras
*--------------------------------------------------------------------------------------------------*
  DATA: zg_e_retorno TYPE zes_sd_return.

*"-------------------------------------------------------------------------------------------------*
* Definición Variables
*--------------------------------------------------------------------------------------------------*
  DATA: zg_v_line TYPE i.
*--------------------------------------------------------------------------------------------------*

  TRANSLATE im_usuario TO UPPER CASE.

  CALL FUNCTION 'ZFU_SD_PEDIDOS_LIBERAR'
    EXPORTING
      im_usuario = im_usuario
      im_tipolib = 'PE'
    IMPORTING
      ex_return  = zg_e_retorno
    TABLES
      ta_pedidos = zg_t_pedidos.

*Begin of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
SORT ZG_T_PEDIDOS BY EBELN .
*End of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
  DELETE ADJACENT DUPLICATES FROM zg_t_pedidos COMPARING ebeln.
  DESCRIBE TABLE zg_t_pedidos LINES zg_v_line.

  ex_num_pedidos = zg_v_line.

  CLEAR: zg_e_retorno, zg_v_line.
  CALL FUNCTION 'ZFU_SD_SOLPED_LIBERAR'
    EXPORTING
      im_usuario     = im_usuario
      im_tipolib     = 'SP'
    IMPORTING
      ex_return      = zg_e_retorno
    TABLES
      ta_solped_libe = zg_t_solpedi.

*Begin of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
SORT ZG_T_SOLPEDI BY BANFN .
*End of change: ReSQ Correction for DELETE ADJACENT DUPLICATE 19/12/2019 EY_DES01 ECDK917080 *
  DELETE  ADJACENT DUPLICATES FROM zg_t_solpedi COMPARING banfn.
  DESCRIBE TABLE zg_t_solpedi LINES zg_v_line.

  ex_num_solped = zg_v_line.

ENDFUNCTION.
