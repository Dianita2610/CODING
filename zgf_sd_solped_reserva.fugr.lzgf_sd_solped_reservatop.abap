FUNCTION-POOL zgf_sd_solped_reserva.        "MESSAGE-ID ..
*--------------------------------------------------------------------------------------------------*
* Declaración Types                                                                                *
*--------------------------------------------------------------------------------------------------*
TYPES: BEGIN OF ty_mara,
        matnr    TYPE mara-matnr,
        matkl    TYPE mara-matkl,
        meins    TYPE mara-meins,
       END OF ty_mara.

TYPES: BEGIN OF ty_makt,
        matnr    TYPE mara-matnr,
        maktx    TYPE makt-maktx,
       END OF ty_makt.

TYPES: BEGIN OF ty_asmd,
        asnum    TYPE asmd-asnum,
        matkl    TYPE asmd-matkl,
        meins    TYPE asmd-meins,
       END OF ty_asmd.

TYPES: BEGIN OF ty_eban,
        banfn    TYPE cdobjectv,"eban-banfn,
        bnfpo    TYPE eban-bnfpo,
        badat    TYPE eban-badat,
        ernam    TYPE eban-ernam,
        werks    TYPE eban-werks,
        menge    TYPE eban-menge,
        meins    TYPE eban-meins,
        matnr    TYPE eban-matnr,
        frgst    TYPE eban-frgst,
        frggr    TYPE eban-frggr,
       END OF ty_eban.

TYPES: BEGIN OF ty_eban2,
        banfn    TYPE cdobjectv,"eban-banfn,
        bnfpo    TYPE eban-bnfpo,
        badat    TYPE eban-badat,
        ernam    TYPE eban-ernam,
        werks    TYPE eban-werks,
        menge    TYPE eban-menge,
        meins    TYPE eban-meins,
        matnr    TYPE eban-matnr,
        frgst    TYPE eban-frgst,
        frgzu    TYPE eban-frgzu,
        frggr    TYPE eban-frggr,
        frgkz    TYPE eban-frgkz,
       END OF ty_eban2.

TYPES: BEGIN OF ty_t001w,
        werks    TYPE t001w-werks,
        name1    TYPE t001w-name1,
       END OF ty_t001w.

TYPES: BEGIN OF ty_t16fw,
        frggr    TYPE t16fv-frggr,
        frgco    TYPE t16fv-frgco,
       END OF ty_t16fw.

TYPES: BEGIN OF ty_ekko,
        ebeln    TYPE ekko-ebeln,
        waers    TYPE ekko-waers,
        bedat    TYPE ekko-bedat,
        lifnr    TYPE ekko-lifnr,
       END OF ty_ekko.

TYPES: BEGIN OF ty_ekko2,
        ebeln    TYPE ekko-ebeln,
        waers    TYPE ekko-waers,
        bedat    TYPE ekko-bedat,
        lifnr    TYPE ekko-lifnr,
        frggr    TYPE ekko-frggr,
        frgsx    TYPE ekko-frgsx,
        frgke    TYPE ekko-frgke,
        frgzu    TYPE ekko-frgzu,
       END OF ty_ekko2.

TYPES: BEGIN OF ty_ekpo,
        ebeln    TYPE ekpo-ebeln,
        ebelp    TYPE ekpo-ebelp,
        matnr    TYPE ekpo-matnr,
        werks    TYPE ekpo-werks,
        knttp    TYPE ekpo-knttp,
        menge    TYPE ekpo-menge,
        meins    TYPE ekpo-meins,
        netpr    TYPE ekpo-netpr,
        banfn    TYPE ekpo-banfn,
        bnfpo    TYPE ekpo-bnfpo,
       END OF ty_ekpo.

TYPES: BEGIN OF ty_frgst,
        frgst    TYPE eban-frgst,
        frgzu    TYPE eban-frgzu,
       END OF ty_frgst.

TYPES: BEGIN OF ty_lfa1,
        lifnr    TYPE lfa1-lifnr,
        name1    TYPE lfa1-name1,
        name2    TYPE lfa1-name2,
       END OF ty_lfa1.

TYPES: BEGIN OF ty_cdhdr,
        objectclas TYPE cdhdr-objectclas,
        objectid   TYPE cdhdr-objectid,
        changenr   TYPE cdhdr-changenr,
        tcode      TYPE cdhdr-tcode,
       END OF ty_cdhdr.

TYPES: BEGIN OF ty_cdpos,
        objectclas TYPE cdpos-objectclas,
        objectid   TYPE cdpos-objectid,
        changenr   TYPE cdpos-changenr,
        tabname    TYPE cdpos-tabname,
        fname      TYPE cdpos-fname,
        chngind    TYPE cdpos-chngind,
        value_new  TYPE cdpos-value_new,
       END OF ty_cdpos.

TYPES: BEGIN OF ty_t16fs,
        frggr    TYPE t16fs-frggr,
        frgsx    TYPE t16fs-frgsx,
        frgc1    TYPE t16fs-frgc1,
        frgc2    TYPE t16fs-frgc2,
        frgc3    TYPE t16fs-frgc3,
        frgc4    TYPE t16fs-frgc4,
        frgc5    TYPE t16fs-frgc5,
        frgc6    TYPE t16fs-frgc6,
        frgc7    TYPE t16fs-frgc7,
        frgc8    TYPE t16fs-frgc8,
       END OF ty_t16fs.

*--------------------------------------------------------------------------------------------------*
* Declaración Tablas Internas                                                                      *
*--------------------------------------------------------------------------------------------------*
DATA: zg_t_items TYPE TABLE OF bapiebanc.
DATA: zg_t_itemt TYPE TABLE OF bapiebantx.
DATA: zg_t_servi TYPE TABLE OF bapiesllc.
DATA: zg_t_retur TYPE TABLE OF bapireturn.
DATA: zg_t_retor TYPE TABLE OF bapiret2.
DATA: zg_t_marat TYPE TABLE OF ty_mara.
DATA: zg_t_asmdt TYPE TABLE OF ty_asmd.
DATA: zg_t_itemr TYPE TABLE OF bapi2093_res_item.
DATA: zg_t_itemp TYPE TABLE OF bapi_profitability_segment.
DATA: zg_t_t16fw TYPE TABLE OF t16fw.
DATA: zg_t_t16fv TYPE TABLE OF t16fv.
DATA: zg_t_ebant TYPE TABLE OF ty_eban.
DATA: zg_t_eban2 TYPE TABLE OF ty_eban2.
DATA: zg_t_ebanl TYPE TABLE OF ty_eban.
DATA: zg_t_t001w TYPE TABLE OF ty_t001w.
DATA: zg_t_lines TYPE TABLE OF tline.
DATA: zg_t_zt16f TYPE TABLE OF zt16fw.
DATA: zg_t_ekkot TYPE TABLE OF ty_ekko.
DATA: zg_t_ekko2 TYPE TABLE OF ty_ekko2.
DATA: zg_t_ekpot TYPE TABLE OF ty_ekpo.
DATA: zg_t_makt  TYPE TABLE OF ty_makt.
DATA: zg_t_frgst TYPE TABLE OF ty_frgst.
DATA: zg_t_lfa1  TYPE TABLE OF ty_lfa1.
DATA: zg_t_cdhdr TYPE TABLE OF ty_cdhdr.
DATA: zg_t_cdpos TYPE TABLE OF ty_cdpos.
DATA: zg_t_t16fs TYPE TABLE OF ty_t16fs.
*DATA: zg_t_retur TYPE TABLE OF bapireturn.

*--------------------------------------------------------------------------------------------------*
* Declaración Tablas Internas                                                                      *
*--------------------------------------------------------------------------------------------------*
DATA: zg_e_items TYPE bapiebanc.
DATA: zg_e_itemt TYPE bapiebantx.
DATA: zg_e_servi TYPE bapiesllc.
DATA: zg_e_retur TYPE bapireturn.
DATA: zg_e_marat TYPE ty_mara.
DATA: zg_e_asmdt TYPE ty_asmd.
DATA: zg_e_itemr TYPE bapi2093_res_item.
DATA: zg_e_heade TYPE bapi2093_res_head.
DATA: zg_e_retor TYPE bapiret2.
DATA: zg_e_t16fw TYPE t16fw.
DATA: zg_e_t16fv TYPE t16fv.
DATA: zg_e_ebant TYPE ty_eban.
DATA: zg_e_t001w TYPE ty_t001w.
DATA: zg_e_lines TYPE tline.
DATA: zg_e_zt16f TYPE zt16fw.
DATA: zg_e_et16f TYPE ty_t16fw.
DATA: zg_e_ekkot TYPE ty_ekko.
DATA: zg_e_ekko2 TYPE ty_ekko2.
DATA: zg_e_ekpot TYPE ty_ekpo.
DATA: zg_e_makt  TYPE ty_makt.
DATA: zg_e_frgst TYPE ty_frgst.
DATA: zg_e_lfa1  TYPE ty_lfa1.
DATA: zg_e_cdhdr TYPE ty_cdhdr.
DATA: zg_e_cdpos TYPE ty_cdpos.
DATA: zg_e_t16fs TYPE ty_t16fs.
DATA: zg_e_eban2 TYPE ty_eban2.
*DATA: zg_e_retur TYPE bapireturn.

*--------------------------------------------------------------------------------------------------*
* Declaración variables                                                                            *
*--------------------------------------------------------------------------------------------------*
DATA: zg_v_banfn TYPE bapiebanc-preq_no.

*--------------------------------------------------------------------------------------------------*
* Declaración Ranges                                                                               *
*--------------------------------------------------------------------------------------------------*
RANGES: ra_frgsx FOR t16fv-frgsx.
RANGES: ra_frgzu FOR eban-frgzu.
