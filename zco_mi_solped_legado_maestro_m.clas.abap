class ZCO_MI_SOLPED_LEGADO_MAESTRO_M definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

*"* public components of class ZCO_MI_SOLPED_LEGADO_MAESTRO_M
*"* do not include other source files here!!!
public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods MI_SOLPED_LEGADO_MAESTRO_MATER
    importing
      !OUTPUT type ZMT_SOLPED_LEGADO_MAESTRO_MAT1
    exporting
      !INPUT type ZMT_SOLPED_LEGADO_MAESTRO_MATE
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
protected section.
*"* protected components of class ZCO_MI_SOLPED_LEGADO_MAESTRO_M
*"* do not include other source files here!!!
private section.
*"* private components of class ZCO_MI_SOLPED_LEGADO_MAESTRO_M
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCO_MI_SOLPED_LEGADO_MAESTRO_M IMPLEMENTATION.


method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_MI_SOLPED_LEGADO_MAESTRO_M'
    logical_port_name   = logical_port_name
  ).

endmethod.


method MI_SOLPED_LEGADO_MAESTRO_MATER.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'MI_SOLPED_LEGADO_MAESTRO_MATER'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.
ENDCLASS.
