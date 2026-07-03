*&---------------------------------------------------------------------*
*& Report: < ZEY_GDS_CORRECTION > *
*& Author: < EY_DES01 > *
*& Description: < ReSQ Correction > *
*& Date: <19-12-2019> *
*& Transport Number: < ECDK917080 > *
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZGF_SD_SOLPED_RESERVAF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAMPOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS  text
*      <--P_ZL_V_INDIC  text
*      <--P_ZL_V_TEXTO  text
*----------------------------------------------------------------------*
FORM f_valida_campos  TABLES ta_items STRUCTURE zes_sd_solped
                    CHANGING ch_indic ch_texto.

  DATA: zl_v_field TYPE c LENGTH 20.

  LOOP AT ta_items.

    IF ta_items-bbsrt        IS INITIAL.
      ch_texto = 'Campo BBSRT vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-bnfpo    IS INITIAL.
      ch_texto = 'Campo BNFPO vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-bstyp    IS INITIAL.
      ch_texto = 'Campo BSTYP vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-matnr    IS INITIAL.
      ch_texto = 'Campo MATNR vacio, favor completar'.
      EXIT.
    ELSE.
      PERFORM f_consul_matnr USING ta_items-matnr
                          CHANGING ch_texto.

      IF ch_texto IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDIF.

    IF ta_items-char64   IS INITIAL.
      ch_texto = 'Campo CHAR64 vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-bamng    IS INITIAL.
      ch_texto = 'Campo BAMNG vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-bapre    IS INITIAL.
      ch_texto = 'Campo BAPRE vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-eindt    IS INITIAL.
      ch_texto = 'Campo EINDT vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-ewerk    IS INITIAL.
      ch_texto = 'Campo EWERK vacio, favor completar'.
      EXIT.
    ELSE.
      PERFORM f_consul_ewerk USING ta_items-ewerk
                          CHANGING ch_texto.

      IF ch_texto IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDIF.

    IF ta_items-lgort_d  IS INITIAL.
      ch_texto = 'Campo LGORT_D vacio, favor completar'.
      EXIT.
    ELSE.
      PERFORM f_consul_lgord USING ta_items-lgort_d
                                   ta_items-ewerk
                          CHANGING ch_texto.

      IF ch_texto IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDIF.

    IF ta_items-afnam    IS INITIAL.
      ch_texto = 'Campo AFNAM vacio, favor completar'.
      EXIT.
    ENDIF.
  ENDLOOP.

  IF ch_texto IS NOT INITIAL.
    ch_indic = 'X'.
  ENDIF.

ENDFORM.                    " F_VALIDA_CAMPOS
*&---------------------------------------------------------------------*
*&      Form  F_CONSUL_EWERK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS_EWERK  text
*      <--P_CH_TEXTO  text
*----------------------------------------------------------------------*
FORM f_consul_ewerk  USING us_ewerk
                  CHANGING ch_texto.

  DATA: zl_v_werks TYPE t001w-werks.

  SELECT SINGLE werks
    INTO zl_v_werks
    FROM t001w
   WHERE werks = us_ewerk.

  IF sy-subrc <> 0.
    CONCATENATE 'El campo EWERK' us_ewerk
                'no existe en el maestro de Centros'
           INTO ch_texto
    SEPARATED BY '-'.
  ENDIF.

ENDFORM.                    " F_CONSUL_EWERK
*&---------------------------------------------------------------------*
*&      Form  F_CONSUL_LGORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS_LGORT_D  text
*      <--P_CH_TEXTO  text
*----------------------------------------------------------------------*
FORM f_consul_lgord  USING us_lgort
                           us_werks
                  CHANGING ch_texto.

  DATA: zl_v_lgort TYPE t001l-lgort.

  SELECT SINGLE lgort
    INTO zl_v_lgort
    FROM t001l
   WHERE werks = us_werks
     AND lgort = us_lgort.

  IF sy-subrc <> 0.
    CONCATENATE 'El campo LGORT_D' us_lgort
                'no existe en el maestro de Almacenes o el almacen no pertenece al centro'
           INTO ch_texto
    SEPARATED BY '-'.
  ENDIF.

ENDFORM.                    " F_CONSUL_LGORD
*&---------------------------------------------------------------------*
*&      Form  F_CONSUL_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS_MATNR  text
*      <--P_CH_TEXTO  text
*----------------------------------------------------------------------*
FORM f_consul_matnr  USING us_matnr
                  CHANGING ch_texto.

  DATA: zl_v_matnr TYPE mara-matnr.

  SELECT SINGLE matnr
    INTO zl_v_matnr
    FROM mara
   WHERE matnr = us_matnr.

  IF sy-subrc <> 0.
    CONCATENATE 'El campo MATNR' us_matnr
                'no existe en el maestro de materiales'
           INTO ch_texto
    SEPARATED BY '-'.
  ENDIF.

ENDFORM.                    " F_CONSUL_MATNR
*&---------------------------------------------------------------------*
*&      Form  F_SET_ITEMS_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS  text
*----------------------------------------------------------------------*
FORM f_set_items_text  TABLES ta_items STRUCTURE zes_sd_solped.
  DATA: zl_v_corre TYPE n LENGTH 10.
  DATA: zl_v_corr2 TYPE n LENGTH 10.
  DATA: zl_v_linea TYPE i.
  DATA: zl_v_posic TYPE n LENGTH 10.

  PERFORM f_get_mara_asmd TABLES ta_items.

  LOOP AT ta_items.
    CLEAR: zg_e_items, zg_e_itemt.

    ADD 1  TO zl_v_corre.
    ADD 1  TO zl_v_linea.
    ADD 10 TO zl_v_posic.

    zg_e_items-preq_item    = ta_items-bnfpo.
    zg_e_items-doc_type     = ta_items-bbsrt.
    zg_e_items-pur_group    = 'SUP'.
    zg_e_items-plant        = ta_items-ewerk.
    zg_e_items-store_loc    = ta_items-lgort_d.
    zg_e_items-deliv_date   = ta_items-eindt.
    zg_e_items-price_unit   = ta_items-bapre.
    zg_e_items-quantity     = ta_items-bamng.
    zg_e_items-acctasscat   = 'U'.
    zg_e_items-purch_org    = 'ABAS'.

    READ TABLE zg_t_marat INTO zg_e_marat WITH KEY matnr = ta_items-matnr.
    IF sy-subrc = 0.
      zg_e_items-mat_grp    = zg_e_marat-matkl.
      zg_e_items-unit       = zg_e_marat-meins.
      zg_e_items-material   = ta_items-matnr.
      zg_e_items-item_cat   = ''.
      zg_e_items-gr_ind     = ''.
      zg_e_items-gr_non_val = ''.
    ELSE.
      zg_e_items-short_text = ta_items-char64.
      zg_e_items-material   = ''.
      zg_e_items-item_cat   = '9'.
      zg_e_items-gr_ind     = 'X'.
      zg_e_items-gr_non_val = 'X'.
      zg_e_items-pckg_no    = zl_v_corre.
    ENDIF.
    APPEND zg_e_items TO zg_t_items.

    PERFORM f_set_item_text USING ta_items.

    IF ta_items-bstyp = 'S'.
      PERFORM f_set_item_serv USING ta_items "zl_v_linea zl_v_posic"zl_v_corre zl_v_linea zl_v_posic
                           CHANGING zl_v_corre."zl_v_corr2.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " F_SET_ITEMS_TEXT
*&---------------------------------------------------------------------*
*&      Form  F_SET_ITEM_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS  text
*----------------------------------------------------------------------*
FORM f_set_item_text  USING us_items STRUCTURE zes_sd_solped.
  CLEAR: zg_e_itemt.

  zg_e_itemt-preq_item    = us_items-bnfpo.
  zg_e_itemt-text_id      = 'B01'.
  zg_e_itemt-text_form    = 'X'.
  zg_e_itemt-text_line    = us_items-char64.
  APPEND zg_e_itemt TO zg_t_itemt.

  CLEAR: zg_e_itemt.
  zg_e_itemt-preq_item    = us_items-bnfpo.
  zg_e_itemt-text_id      = 'B05'.
  zg_e_itemt-text_form    = 'X'.
  zg_e_itemt-text_line    = us_items-produc.
  APPEND zg_e_itemt TO zg_t_itemt.

ENDFORM.                    " F_SET_ITEM_TEXT
*&---------------------------------------------------------------------*
*&      Form  F_SET_ITEM_SERV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS  text
*----------------------------------------------------------------------*
FORM f_set_item_serv  USING us_items STRUCTURE zes_sd_solped
                            "us_linea
                            "us_posic
                   CHANGING ch_corr2.

  CLEAR: zg_e_servi.
  zg_e_servi-pckg_no    = ch_corr2.
  zg_e_servi-line_no    = ch_corr2.
  zg_e_servi-outl_ind   = 'X'.

  ADD 1 TO ch_corr2.
  zg_e_servi-subpckg_no = ch_corr2.
  zg_e_servi-from_line  = 1.
  APPEND zg_e_servi TO zg_t_servi.

  CLEAR: zg_e_servi.
  zg_e_servi-pckg_no    = ch_corr2.
  zg_e_servi-line_no    = ch_corr2.
  zg_e_servi-ext_line   = us_items-bnfpo.
  zg_e_servi-service    = us_items-matnr.
  zg_e_servi-quantity   = us_items-bamng.
  zg_e_servi-price_unit = us_items-bapre.
  zg_e_servi-gr_price = us_items-bamng * us_items-bapre.

  READ TABLE zg_t_asmdt INTO zg_e_asmdt WITH KEY asnum = us_items-matnr.
  IF sy-subrc = 0.
    zg_e_servi-base_uom   = zg_e_asmdt-meins.
    zg_e_servi-matl_group = zg_e_asmdt-matkl.
  ENDIF.
  APPEND zg_e_servi TO zg_t_servi.

ENDFORM.                    " F_SET_ITEM_SERV
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA_ASMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_ITEMS  text
*----------------------------------------------------------------------*
FORM f_get_mara_asmd  TABLES ta_items STRUCTURE zes_sd_solped.
  CLEAR: zg_t_marat[], zg_t_asmdt[].

  SELECT matnr matkl meins
    FROM mara
    INTO TABLE zg_t_marat
    FOR ALL ENTRIES IN ta_items
   WHERE matnr = ta_items-matnr.

  SELECT asnum matkl meins
    FROM asmd
    INTO TABLE zg_t_asmdt
    FOR ALL ENTRIES IN ta_items
   WHERE asnum = ta_items-matnr.

ENDFORM.                    " F_GET_MARA_ASMD
*&---------------------------------------------------------------------*
*&      Form  F_VALIDA_CAMPOS_RE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_DETAIL  text
*      <--P_ZL_V_INDIC  text
*      <--P_ZL_V_TEXTO  text
*----------------------------------------------------------------------*
FORM f_valida_campos_re  TABLES ta_items STRUCTURE zes_sd_reser_de
                       CHANGING ch_indic
                                ch_texto.

  DATA: zl_v_field TYPE c LENGTH 20.

  LOOP AT ta_items.

    IF ta_items-matnr    IS INITIAL.
      ch_texto = 'Campo MATNR vacio, favor completar'.
      EXIT.
    ELSE.
      PERFORM f_consul_matnr USING ta_items-matnr
                          CHANGING ch_texto.

      IF ch_texto IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDIF.

    IF ta_items-meins   IS INITIAL.
      ch_texto = 'Campo MEINS vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-bdmng    IS INITIAL.
      ch_texto = 'Campo BDMNG vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-zzunid_pro    IS INITIAL.
      ch_texto = 'Campo ZZUNID_PRO vacio, favor completar'.
      EXIT.
    ENDIF.

    IF ta_items-lgort_d  IS INITIAL.
      ch_texto = 'Campo LGORT_D vacio, favor completar'.
      EXIT.
    ELSE.
*      PERFORM f_consul_lgord USING ta_items-lgort_d
*                                   ta_items-ewerk
*                          CHANGING ch_texto.
*
*      IF ch_texto IS NOT INITIAL.
*        EXIT.
*      ENDIF.
    ENDIF.
  ENDLOOP.

  IF ch_texto IS NOT INITIAL.
    ch_indic = 'X'.
  ENDIF.

ENDFORM.                    " F_VALIDA_CAMPOS_RE
*&---------------------------------------------------------------------*
*&      Form  F_SET_ITEMS_RE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_DETAIL  text
*----------------------------------------------------------------------*
FORM f_set_items_re TABLES ta_items STRUCTURE zes_sd_reser_de
                     USING us_heade STRUCTURE zes_sd_reser_ca.
  CLEAR: zg_t_itemr[].

  LOOP AT ta_items.
    CLEAR: zg_e_itemr.

    zg_e_itemr-material      = ta_items-matnr.
    zg_e_itemr-plant         = us_heade-werks_d.
    zg_e_itemr-stge_loc      = ta_items-lgort_d.
    zg_e_itemr-entry_qnt     = ta_items-bdmng.
    zg_e_itemr-item_text     = ta_items-zzunid_pro.
    zg_e_itemr-movement_auto = 'X'.
    APPEND zg_e_itemr TO zg_t_itemr.
  ENDLOOP.

ENDFORM.                    " F_SET_ITEMS_RE
*&---------------------------------------------------------------------*
*&      Form  F_CALL_TRANSACTION_COMMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_transaction_commit .

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.

ENDFORM.                    " F_CALL_TRANSACTION_COMMIT
*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_ESTRATEGIA_USUARIO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_buscar_estrategia_usuario USING us_t16fw LIKE zg_e_et16f
                                       us_tipol
                              CHANGING ch_retur STRUCTURE zes_sd_return.
  DATA: zl_v_frgzu TYPE frgzu.

  CLEAR: zg_t_t16fv[], zg_t_ebant[], zg_t_ekkot[], zg_t_ekpot[], zg_t_makt[],
         ra_frgsx[]  , ra_frgzu[]  , zg_t_frgst[].

  SELECT mandt frggr frgsx frgco frga1 frga2 frga3 frga4 frga5
         frga6 frga7 frga8
    FROM t16fv
    INTO TABLE zg_t_t16fv
    FOR ALL ENTRIES IN zg_t_t16fw
   WHERE frggr = zg_t_t16fw-frggr
     AND frgco = zg_t_t16fw-frgco.

  LOOP AT zg_t_t16fw INTO zg_e_t16fw.
    LOOP AT zg_t_t16fv INTO zg_e_t16fv WHERE frggr = zg_e_t16fw-frggr AND
                                             frgco = zg_e_t16fw-frgco.
      CLEAR: ra_frgsx[]  , ra_frgzu[], zl_v_frgzu, zg_e_frgst.

      IF zg_e_t16fv-frga1 ='X'.
        zl_v_frgzu = ''.
      ELSEIF zg_e_t16fv-frga2 ='X'.
        zl_v_frgzu ='X'.
      ELSEIF zg_e_t16fv-frga3 ='X'.
        zl_v_frgzu ='XX'.
      ELSEIF zg_e_t16fv-frga4 ='X'.
        zl_v_frgzu ='XXX'.
      ELSEIF zg_e_t16fv-frga5 ='X'.
        zl_v_frgzu ='XXXX'.
      ELSEIF zg_e_t16fv-frga6 ='X'.
        zl_v_frgzu ='XXXXX'.
      ELSEIF zg_e_t16fv-frga7 ='X'.
        zl_v_frgzu ='XXXXXX'.
      ELSEIF zg_e_t16fv-frga8 ='X'.
        zl_v_frgzu ='XXXXXXX'.
      ENDIF.

      zg_e_frgst-frgst = zg_e_t16fv-frgsx.
      zg_e_frgst-frgzu = zl_v_frgzu.
      APPEND zg_e_frgst TO zg_t_frgst.

    ENDLOOP.
  ENDLOOP.

  IF zg_t_frgst[] IS NOT INITIAL.

    IF us_tipol = 'SP'.
      SELECT banfn bnfpo badat ernam werks menge meins matnr frgst frggr
        INTO TABLE zg_t_ebant
        FROM eban
        FOR ALL ENTRIES IN zg_t_frgst
       WHERE ( frgkz = ' ' OR frgkz = 'X')
         AND frgst EQ zg_t_frgst-frgst
         AND frgzu EQ zg_t_frgst-frgzu.

      IF sy-subrc <> 0.
        ch_retur-codigo  = '4'.
        ch_retur-mensaje = 'No posee Solped para liberar'.
      ELSE.

        SELECT matnr maktx
          INTO TABLE zg_t_makt
          FROM makt
          FOR ALL ENTRIES IN zg_t_ebant
         WHERE matnr = zg_t_ebant-matnr
           AND spras = 'S'.
      ENDIF.
    ELSEIF us_tipol = 'PE'.

      SELECT ebeln waers bedat lifnr
        FROM ekko
        INTO TABLE zg_t_ekkot
        FOR ALL ENTRIES IN zg_t_frgst
        WHERE ( frgke = '' OR frgke = '1')
         AND frgsx EQ zg_t_frgst-frgst
         AND frgzu EQ zg_t_frgst-frgzu
         AND bstyp EQ 'F'.

      IF sy-subrc <> 0.
        ch_retur-codigo  = '4'.
        ch_retur-mensaje = 'No posee Pedidos para liberar'.
      ELSE.

        SELECT lifnr name1 name2
          FROM lfa1
          INTO TABLE zg_t_lfa1
          FOR ALL ENTRIES IN zg_t_ekkot
         WHERE lifnr = zg_t_ekkot-lifnr.

        SELECT ebeln ebelp matnr werks knttp menge meins netpr banfn bnfpo
          FROM ekpo
          INTO TABLE zg_t_ekpot
          FOR ALL ENTRIES IN zg_t_ekkot
         WHERE ebeln = zg_t_ekkot-ebeln.

        IF sy-subrc = 0.
          PERFORM f_get_liberador.

          SELECT matnr maktx
            INTO TABLE zg_t_makt
            FROM makt
            FOR ALL ENTRIES IN zg_t_ekpot
           WHERE matnr = zg_t_ekpot-matnr
             AND spras = 'S'.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    ch_retur-codigo  = '4'.
    ch_retur-mensaje = 'Usuario No Tiene requisitos para liberación'.
  ENDIF.

ENDFORM.                    " F_BUSCAR_ESTRATEGIA_USUARIO
*&---------------------------------------------------------------------*
*&      Form  F_SET_SALIDA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_salida TABLES ta_solped STRUCTURE zes_sd_solped_libe.
  DATA: zl_v_name TYPE thead-tdname.

  CLEAR: zg_t_t001w[].

  SELECT werks name1
    INTO TABLE zg_t_t001w
    FROM t001w
    FOR ALL ENTRIES IN zg_t_ebant
   WHERE werks = zg_t_ebant-werks.

  LOOP AT zg_t_ebant INTO zg_e_ebant.
    CLEAR: zl_v_name, ta_solped.

    ta_solped-banfn = zg_e_ebant-banfn.
    ta_solped-bnfpo = zg_e_ebant-bnfpo.
    ta_solped-badat = zg_e_ebant-badat.
    ta_solped-ernam = zg_e_ebant-ernam.
    ta_solped-menge = zg_e_ebant-menge.
    ta_solped-meins = zg_e_ebant-meins.

    READ TABLE zg_t_makt INTO zg_e_makt WITH KEY matnr = zg_e_ebant-matnr.
    IF sy-subrc = 0.
      ta_solped-matnr = zg_e_makt-maktx.
    ENDIF.

    READ TABLE zg_t_t001w INTO zg_e_t001w WITH KEY werks = zg_e_ebant-werks.
    IF sy-subrc = 0.
      ta_solped-name1 = zg_e_t001w-name1.
    ENDIF.

    CONCATENATE zg_e_ebant-banfn zg_e_ebant-bnfpo INTO zl_v_name.
    PERFORM f_get_read_text USING 'B01' zl_v_name 'EBAN'
                         CHANGING ta_solped-texto.

    zl_v_name = zg_e_ebant-banfn.
    PERFORM f_get_read_text USING 'B01' zl_v_name 'EBANH'
                         CHANGING ta_solped-ncabe.

    APPEND ta_solped.
  ENDLOOP.

ENDFORM.                    " F_SET_SALIDA
*&---------------------------------------------------------------------*
*&      Form  F_GET_READ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0961   text
*      -->P_ZL_V_NAME  text
*      -->P_0963   text
*      <--P_TA_SOLPED_TEXTO  text
*----------------------------------------------------------------------*
FORM f_get_read_text  USING us_id   TYPE thead-tdid
                            us_name TYPE thead-tdname
                            us_obje TYPE thead-tdobject
                   CHANGING ch_solp TYPE zes_sd_solped_libe-texto.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
     client                        = sy-mandt
      id                            = us_id
      language                      = sy-langu
      name                          = us_name
      object                        = us_obje
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    TABLES
      lines                         = zg_t_lines
   EXCEPTIONS
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     OTHERS                        = 8.

  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    READ TABLE zg_t_lines INTO zg_e_lines INDEX 1.
    IF sy-subrc = 0.
      ch_solp = zg_e_lines-tdline.
    ENDIF.
  ENDIF.

ENDFORM.                    " F_GET_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  F_SET_SALIDA_PEDIDOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_PEDIDOS  text
*----------------------------------------------------------------------*
FORM f_set_salida_pedidos  TABLES ta_pedidos STRUCTURE zes_sd_pedidos_libe.
  DATA: zl_v_name TYPE thead-tdname.

  CLEAR: zg_t_t001w[].

  SELECT werks name1
    INTO TABLE zg_t_t001w
    FROM t001w
    FOR ALL ENTRIES IN zg_t_ekpot
   WHERE werks = zg_t_ekpot-werks.

  LOOP AT zg_t_ekpot INTO zg_e_ekpot.
    CLEAR: zl_v_name.

    ta_pedidos-ebeln = zg_e_ekpot-ebeln.
    ta_pedidos-ebelp = zg_e_ekpot-ebelp.
    ta_pedidos-menge = zg_e_ekpot-menge.
    ta_pedidos-meins = zg_e_ekpot-meins.
    ta_pedidos-netpr = zg_e_ekpot-netpr.

    PERFORM f_set_liberador CHANGING ta_pedidos-liber.

    READ TABLE zg_t_ekkot INTO zg_e_ekkot WITH KEY ebeln = zg_e_ekpot-ebeln.
    IF sy-subrc = 0.
      ta_pedidos-bedat = zg_e_ekkot-bedat.
      ta_pedidos-waers = zg_e_ekkot-waers.

      IF zg_e_ekkot-waers <> 'UF'.
        ta_pedidos-total = ( zg_e_ekpot-netpr * zg_e_ekpot-menge ) * 100.
      ENDIF.

      READ TABLE zg_t_lfa1 INTO zg_e_lfa1 WITH KEY lifnr = zg_e_ekkot-lifnr.
      IF sy-subrc = 0.
        ta_pedidos-prove = zg_e_lfa1-name1.
      ENDIF.
    ENDIF.

    READ TABLE zg_t_t001w INTO zg_e_t001w WITH KEY werks = zg_e_ekpot-werks.
    IF sy-subrc = 0.
      ta_pedidos-name1 = zg_e_t001w-name1.
    ENDIF.

    CONCATENATE zg_e_ekpot-ebeln zg_e_ekpot-ebelp INTO zl_v_name.
    PERFORM f_get_read_text USING 'F06' zl_v_name 'EKPO'
                         CHANGING ta_pedidos-texto.

    zl_v_name = zg_e_ekpot-ebeln.
    PERFORM f_get_read_text USING 'F01' zl_v_name 'EKKO'
                         CHANGING ta_pedidos-notac.

    APPEND ta_pedidos.
  ENDLOOP.

ENDFORM.                    " F_SET_SALIDA_PEDIDOS
*&---------------------------------------------------------------------*
*&      Form  F_GET_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ZG_E_RETURN  text
*      <--P_ZL_V_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_message  USING us_return STRUCTURE bapiret2
                 CHANGING us_texto.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = us_return-id
      msgnr               = us_return-number
      msgv1               = us_return-message_v1
      msgv2               = us_return-message_v2
      msgv3               = us_return-message_v3
      msgv4               = us_return-message_v4
    IMPORTING
      message_text_output = us_texto.

ENDFORM.                    " F_GET_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  F_GET_MESSAGE_S
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ZG_E_RETUR  text
*      <--P_ZL_V_TEXT  text
*----------------------------------------------------------------------*
FORM f_get_message_s  USING us_return STRUCTURE bapireturn
                   CHANGING us_texto.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = us_return-code
      msgnr               = us_return-log_no
      msgv1               = us_return-message_v1
      msgv2               = us_return-message_v2
      msgv3               = us_return-message_v3
      msgv4               = us_return-message_v4
    IMPORTING
      message_text_output = us_texto.

ENDFORM.                    " F_GET_MESSAGE_S
*&---------------------------------------------------------------------*
*&      Form  F_SET_SALIDA_PEDIDOS_PE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TA_PEDIDOS  text
*----------------------------------------------------------------------*
FORM f_set_salida_pedidos_pe  TABLES ta_pedidos STRUCTURE zes_sd_pedidos_libe.
  DATA: zl_v_name TYPE thead-tdname.

  CLEAR: zg_t_t001w[], zg_t_makt[].

  READ TABLE zg_t_ekpot INTO zg_e_ekpot INDEX 1.
  IF sy-subrc = 0.
    SELECT SINGLE werks name1
      INTO zg_e_t001w
      FROM t001w
     WHERE werks = zg_e_ekpot-werks.
  ENDIF.

  SELECT matnr maktx
    INTO TABLE zg_t_makt
    FROM makt
    FOR ALL ENTRIES IN zg_t_ekpot
   WHERE matnr = zg_t_ekpot-matnr
     AND spras = 'S'.

  LOOP AT zg_t_ekpot INTO zg_e_ekpot.
    CLEAR: zl_v_name.

    ta_pedidos-ebeln = zg_e_ekpot-ebeln.
    ta_pedidos-ebelp = zg_e_ekpot-ebelp.
    "ta_pedidos-matnr = zg_e_ekpot-matnr.
    ta_pedidos-menge = zg_e_ekpot-menge.
    ta_pedidos-meins = zg_e_ekpot-meins.
    ta_pedidos-netpr = zg_e_ekpot-netpr * 100.
    ta_pedidos-total = ( zg_e_ekpot-netpr * zg_e_ekpot-menge ) * 100.
    ta_pedidos-bedat = zg_e_ekkot-bedat.
    ta_pedidos-waers = zg_e_ekkot-waers.
    ta_pedidos-name1 = zg_e_t001w-name1.

    READ TABLE zg_t_makt INTO zg_e_makt WITH KEY matnr = zg_e_ekpot-matnr.
    IF sy-subrc = 0.
      ta_pedidos-matnr = zg_e_makt-maktx.
    ENDIF.


    CONCATENATE zg_e_ekpot-ebeln zg_e_ekpot-ebelp INTO zl_v_name.
    PERFORM f_get_read_text USING 'F06' zl_v_name 'EKPO'
                         CHANGING ta_pedidos-texto.

    zl_v_name = zg_e_ekpot-ebeln.
    PERFORM f_get_read_text USING 'F01' zl_v_name 'EKKO'
                         CHANGING ta_pedidos-notac.

    APPEND ta_pedidos.
  ENDLOOP.

ENDFORM.                    " F_SET_SALIDA_PEDIDOS_PE
*&---------------------------------------------------------------------*
*&      Form  F_GET_LIBERADOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_liberador .
  CLEAR: zg_t_ebanl[], zg_t_cdpos[], zg_t_t16fs[], zg_e_t16fs, zg_e_cdpos, zg_e_ebant.

  SELECT banfn bnfpo badat ernam werks menge meins matnr frgst frggr
    FROM eban
    INTO TABLE zg_t_ebanl
    FOR ALL ENTRIES IN zg_t_ekpot
   WHERE banfn = zg_t_ekpot-banfn(10)
     AND bnfpo = zg_t_ekpot-bnfpo.

  IF sy-subrc = 0.
    SELECT objectclas objectid changenr tcode
      FROM cdhdr
      INTO TABLE zg_t_cdhdr
      FOR ALL ENTRIES IN zg_t_ebanl
     WHERE objectclas EQ 'BANF'
       AND objectid   EQ zg_t_ebanl-banfn
       AND tcode      IN ('ME54N', 'ME55').

    IF sy-subrc = 0.
SELECT objectclas objectid changenr tabname fname chngind value_new
FROM cdpos
INTO TABLE zg_t_cdpos
FOR ALL ENTRIES IN zg_t_cdhdr
WHERE objectclas = zg_t_cdhdr-objectclas
AND objectid = zg_t_cdhdr-objectid
AND changenr = zg_t_cdhdr-changenr
AND tabname = 'EBAN'
AND fname = 'FRGZU'
*Begin of change: ReSQ Correction for Addition ORDER BY PRIMARY KEY 19/12/2019 EY_DES01 ECDK917080 *
*AND chngind = 'U'.
AND CHNGIND = 'U' ORDER BY PRIMARY KEY .
*End of change: ReSQ Correction for Addition ORDER BY PRIMARY KEY 19/12/2019 EY_DES01 ECDK917080 *

      IF sy-subrc = 0.
        SELECT frggr frgsx frgc1 frgc2 frgc3 frgc4 frgc5 frgc6 frgc7 frgc8
          INTO TABLE zg_t_t16fs
          FROM t16fs
          FOR ALL ENTRIES IN zg_t_ebanl
         WHERE frggr EQ zg_t_ebanl-frggr
           AND frgsx EQ zg_t_ebanl-frgst.
      ENDIF.
    ENDIF.

    SORT zg_t_cdhdr BY changenr DESCENDING.
  ENDIF.

ENDFORM.                    " F_GET_LIBERADOR
*&---------------------------------------------------------------------*
*&      Form  F_SET_LIBERADOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_TA_PEDIDOS_LIBER  text
*----------------------------------------------------------------------*
FORM f_set_liberador  CHANGING ch_liber.
  DATA: zg_v_frgco TYPE t16fd-frgco.
  DATA: zg_v_frgct TYPE t16fd-frgct.

  READ TABLE zg_t_ebanl INTO zg_e_ebant WITH KEY banfn = zg_e_ekpot-banfn
                                                   bnfpo = zg_e_ekpot-bnfpo.
  IF sy-subrc = 0.
    READ TABLE zg_t_cdhdr INTO zg_e_cdhdr WITH KEY objectid = zg_e_ebant-banfn.
    IF sy-subrc = 0.

      READ TABLE zg_t_cdpos INTO zg_e_cdpos WITH KEY objectclas = zg_e_cdhdr-objectclas
                                                     objectid   = zg_e_cdhdr-objectid
                                                     changenr   = zg_e_cdhdr-changenr.
      IF sy-subrc = 0.
        READ TABLE zg_t_t16fs INTO zg_e_t16fs WITH KEY frggr = zg_e_ebant-frggr
                                                       frgsx = zg_e_ebant-frgst.
        IF sy-subrc = 0.
          CASE zg_e_cdpos-value_new.
            WHEN 'X'.
              zg_v_frgco = zg_e_t16fs-frgc1.
            WHEN 'XX'.
              zg_v_frgco = zg_e_t16fs-frgc2.
            WHEN 'XXX'.
              zg_v_frgco = zg_e_t16fs-frgc3.
            WHEN 'XXXX'.
              zg_v_frgco = zg_e_t16fs-frgc4.
            WHEN 'XXXXX'.
              zg_v_frgco = zg_e_t16fs-frgc5.
            WHEN 'XXXXXX'.
              zg_v_frgco = zg_e_t16fs-frgc6.
            WHEN 'XXXXXXX'.
              zg_v_frgco = zg_e_t16fs-frgc7.
            WHEN 'XXXXXXXX'.
              zg_v_frgco = zg_e_t16fs-frgc8.
          ENDCASE.

          IF zg_v_frgco IS NOT INITIAL.
            SELECT SINGLE frgct
              FROM t16fd
              INTO zg_v_frgct
              WHERE spras = 'S'
                AND frggr = zg_e_ebant-frggr
                AND frgco = zg_v_frgco.

            IF sy-subrc = 0.
              ch_liber = zg_v_frgct.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " F_SET_LIBERADOR
