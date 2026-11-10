using {com.logali as logali} from '../db/schema';
using {com.training as training} from '../db/training';

service CatalogService {
    @cds.redirection.target
    entity Products          as projection on logali.materials.Products;
    entity Categories        as projection on logali.materials.Categories;
    entity StockAvailability as projection on logali.materials.StockAvailability;
    entity Currencies        as projection on logali.materials.Currencies;
    entity UnitOfMeasures    as projection on logali.materials.UnitOfMeasures;
    entity DimensionUnits    as projection on logali.materials.DimensionUnits;
    entity ProductReview     as projection on logali.materials.ProductReview;
    entity SelProducts       as projection on logali.materials.SelProducts;
    entity ProjProducts      as projection on logali.materials.ProjProducts;
    entity ProjProducts2     as projection on logali.materials.ProjProducts2;
    entity ProjProducts3     as projection on logali.materials.ProjProducts3 {
        key Name,
            *
    };
    entity Orders            as projection on logali.sales.Orders;
    entity OrderItems        as projection on logali.sales.OrderItems;
    entity Suppliers         as projection on logali.sales.Suppliers;
    entity Months            as projection on logali.sales.Months;
    entity SelProducts1      as projection on logali.sales.SelProducts1;
    entity SelProducts2      as projection on logali.sales.SelProducts2 {
        key Name,
            *
    };
    entity SelProducts3      as projection on logali.sales.SelProducts3 {
        key Name,
            *
    };
    entity SalesData         as projection on logali.sales.SalesData;
    entity Course            as projection on training.Course;
    entity Student           as projection on training.Student;
    entity StudentCourse     as projection on training.StudentCourse;
}
