*&---------------------------------------------------------------------*
*& Report  ZPR_MM_MAESTRO_MATE_SERV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zpr_mm_maestro_mate_serv.

INCLUDE zpr_mm_maestro_mate_serv_top.
INCLUDE zpr_mm_maestro_mate_serv_f01.

START-OF-SELECTION.
  PERFORM f_get_data.
  PERFORM f_set_structure_out.
  PERFORM f_send_data_pi.
