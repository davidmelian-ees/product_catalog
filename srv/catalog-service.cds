using {com.logali as logali} from '../db/schema';

service CatalogService {
    entity Products          as projection on logali.Products;
    entity Suppliers         as projection on logali.Suppliers;
    entity Categories        as projection on logali.Categories;
    entity StockAvailability as projection on logali.StockAvailability;
    entity Currencies        as projection on logali.Currencies;
    entity UnitOfMeasures    as projection on logali.UnitOfMeasures;
    entity DimensionUnits    as projection on logali.DimensionUnits;
    entity Months            as projection on logali.Months;
    entity ProductReview     as projection on logali.ProductReview;
    entity SalesData         as projection on logali.SalesData;
}
