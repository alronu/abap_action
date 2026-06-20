CLASS lhc_Inventory DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Inventory RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Inventory RESULT result.

    METHODS Trigger_determine_action FOR MODIFY
      IMPORTING keys FOR ACTION Inventory~Trigger_determine_action RESULT result.

    METHODS totalCalc FOR DETERMINE ON SAVE
      IMPORTING keys FOR Inventory~totalCalc.

    METHODS checkQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR Inventory~checkQuantity.


ENDCLASS.

CLASS lhc_Inventory IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD Trigger_determine_action.

    READ ENTITIES OF z_i_inventory IN LOCAL MODE
    ENTITY Inventory
    FIELDS ( ProductId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result_prdt).


    LOOP AT lt_result_prdt INTO DATA(ls_result).
      MODIFY ENTITIES OF z_i_inventory IN LOCAL MODE
           ENTITY Inventory
           EXECUTE calc_total
           FROM VALUE #( ( ProductId = ls_result-ProductId ) )

           MAPPED FINAL(lt_mapped)
           FAILED FINAL(lt_failed)
           REPORTED FINAL(lt_reported).
      mapped-inventory = lt_mapped-inventory.
*    COMMIT ENTITIES.
    ENDLOOP.

  ENDMETHOD.

  METHOD totalCalc.

    READ ENTITIES OF z_i_inventory IN LOCAL MODE
    ENTITY Inventory
    FIELDS ( quantity  unitprice  )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).



    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      LOOP AT lt_result INTO DATA(ls_result).
        IF ls_result-%tky = <fs_keys>-%tky.
          ls_result-totalvalue = ls_result-quantity * ls_result-unitprice.

          MODIFY ENTITIES OF z_i_inventory IN LOCAL MODE
          ENTITY Inventory
          UPDATE
          FIELDS ( totalvalue ) WITH VALUE #( ( %tky = <fs_keys>-%tky
                                                 totalvalue = ls_result-totalvalue ) ).
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkQuantity.

    READ ENTITIES OF z_i_inventory IN LOCAL MODE
    ENTITY Inventory
    FIELDS ( quantity )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result_qua).

    DATA(ls_res_qua) = lt_result_qua[ 1 ].
    IF ls_res_qua-Quantity IS INITIAL.
      APPEND VALUE #( %tky = ls_res_qua-%tky
                    %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Please provide quantity'
                    ) ) TO reported-inventory.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
