using {com.logali as logali} from '../db/schema';

service CatalogService {
    @cds.redirection.target
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
    entity SelProducts       as projection on logali.SelProducts;
    entity SelProducts1      as projection on logali.SelProducts1;
    entity SelProducts2      as projection on logali.SelProducts2 {
        key Name,
            *
    };
    entity SelProducts3      as projection on logali.SelProducts3 {
        key Name,
            *
    };
    entity ProjProducts      as projection on logali.ProjProducts;
    entity ProjProducts2     as projection on logali.ProjProducts2;
    entity ProjProducts3     as projection on logali.ProjProducts3 {
        key Name,
            *
    };
    entity Course            as projection on logali.Course;
    entity Student           as projection on logali.Student;
    entity StudentCourse     as projection on logali.StudentCourse;
    entity Orders            as projection on logali.Orders;
    entity OrderItems        as projection on logali.OrderItems;
}
