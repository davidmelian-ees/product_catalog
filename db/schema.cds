namespace product_catalog;

using { cuid, managed } from '@sap/cds/common';

entity Categories : cuid {
    name     : String(60) not null;
    products : Association to many Products on products.category = $self;
}

entity Products : cuid, managed {
    name        : String(100) not null;
    description : String(500);
    price       : Decimal(10, 2);
    stock       : Integer;
    category    : Association to Categories;
}
