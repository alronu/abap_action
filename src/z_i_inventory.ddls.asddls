@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Ingterface View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity z_i_inventory
  as select from zdp_inventory
{
  key product_id     as ProductId,
      product_name   as ProductName,      
      quantity       as Quantity,
      unit_price     as UnitPrice,
      currency_code  as CurrencyCode,
      @Semantics.amount.currencyCode : 'currencycode'
      total_value    as totalvalue,
      @Semantics.systemDateTime.lastChangedAt: true
      last_change_at as lastchangeat
}
