using {com.logali as logali} from '../db/schema';

service CatalogService {

    entity Products          as
        select from logali.reports.Products {
            // ID,
            // Name          as ProductName     @mandatory,
            // Description                      @mandatory,
            // ImageUrl,
            // ReleaseDate,
            // DiscontinuedDate,
            // Price                            @mandatory,
            // Height,
            // Width,
            // Depth,
            // Quantity                         @(
            //     mandatory,
            //     assert.range: [
            //         0.00,
            //         20.00
            //     ]
            // ),
            *,
            Name          as ProductName     @mandatory,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Category      as ToCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailability
        };

    entity Supplier          as
        select from logali.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    @readonly
    entity Reviews           as
        select from logali.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from logali.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from logali.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from logali.materials.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from logali.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from logali.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    // Proyección con postfix: las columnas van entre select y from
    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from logali.materials.DimensionUnits;
}

service MyService {

    // Expresión de ruta con filtro en Name y where sobre el código postal
    entity SuppliersProduct as
        select from logali.materials.Products[Name = 'Monitor 27'] {
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = '35002';

    entity SuppliersToSales as
        select from logali.materials.Products {
            key ID,
                Supplier.Email,
                Category.Name               as CategoryName,
                SalesData.Currency.ID       as CurrencyKey,
                SalesData.Currency.Description as CurrencyDescription
        };

    // Filtro infix sobre la asociación Supplier
    entity EntityInfix      as
        select from logali.materials.Products {
            key ID,
                Supplier[Name = 'Tecnología Canaria S.L.'].Phone
        }
        where
            Products.Name = 'Portátil Pro 14';

    // La misma definición con select y left join
    entity EntityJoin       as
        select from logali.materials.Products
        left join logali.sales.Suppliers as supp
            on  supp.ID   = Products.Supplier.ID
            and supp.Name = 'Tecnología Canaria S.L.'
        {
            key Products.ID,
                supp.Phone
        }
        where
            Products.Name = 'Portátil Pro 14';
}

service Reports {
    entity AverageRating as projection on logali.reports.AverageRating;
    entity EntityCasting as projection on logali.reports.EntityCasting;
    entity EntityExists  as projection on logali.reports.EntityExists;
}
