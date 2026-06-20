@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Projection View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity z_c_inventory
  provider contract transactional_query 
as projection on z_i_inventory
{
    key ProductId,
    ProductName,
    @Semantics.quantity.unitOfMeasure : 'UnitPrice'
    Quantity,    
    UnitPrice,
    CurrencyCode,
    @Semantics.amount.currencyCode : 'currencycode'
    totalvalue,
    lastchangeat
}
