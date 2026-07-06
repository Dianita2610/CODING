*&---------------------------------------------------------------------*
*&  Include           ZPR_MM_MAESTRO_MATE_SERV_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   Definición Tables                                                   *
*----------------------------------------------------------------------*
TABLES: mara.

*----------------------------------------------------------------------*
*   Definición Types                                                   *
*----------------------------------------------------------------------*
TYPES: BEGIN OF y_mara,
        matnr         TYPE mara-matnr,
        mtart         TYPE mara-mtart,
        meins         TYPE mara-meins,
        ersda         TYPE mara-ersda,
        laeda         TYPE mara-laeda,
       END OF y_mara.

TYPES: BEGIN OF y_makt,
        matnr         TYPE makt-matnr,
        maktx         TYPE makt-maktx,
       END OF y_makt.

TYPES: BEGIN OF y_asmd,
        asnum         TYPE asmd-asnum,
        astyp         TYPE asmd-astyp,
        meins         TYPE asmd-meins,
        erdat         TYPE asmd-erdat,
        aedat         TYPE asmd-aedat,
       END OF y_asmd.

TYPES: BEGIN OF y_asmdt,
        asnum         TYPE asmdt-asnum,
        asktx         TYPE asmdt-asktx,
       END OF y_asmdt.

*----------------------------------------------------------------------*
*   Definición Tablas internas                                         *
*----------------------------------------------------------------------*
DATA: zg_t_mara       TYPE STANDARD TABLE OF y_mara.
DATA: zg_t_makt       TYPE STANDARD TABLE OF y_makt.
DATA: zg_t_asmd       TYPE STANDARD TABLE OF y_asmd.
DATA: zg_t_asmt       TYPE STANDARD TABLE OF y_asmdt.
DATA: zg_t_loge       TYPE STANDARD TABLE OF zta_mm_log_eje.
DATA: zg_t_prxo       TYPE STANDARD TABLE OF zdt_solped_legado_maestro_mat1.

*----------------------------------------------------------------------*
*   Definición Work Area                                               *
*----------------------------------------------------------------------*
DATA: zg_e_mara       TYPE y_mara.
DATA: zg_e_makt       TYPE y_makt.
DATA: zg_e_asmd       TYPE y_asmd.
DATA: zg_e_asmt       TYPE y_asmdt.
DATA: zg_e_loge       TYPE zta_mm_log_eje.
DATA: zg_e_prxo       TYPE zdt_solped_legado_maestro_mat1.

*----------------------------------------------------------------------*
*   Definición Parametros de entrada                                   *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS: s_matnr FOR mara-matnr.
SELECT-OPTIONS: s_ersda FOR mara-ersda.
SELECTION-SCREEN END OF BLOCK b1.
