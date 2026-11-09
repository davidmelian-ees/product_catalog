using { CatalogService } from '../srv/catalog-service';

annotate CatalogService.Products with @(
    UI.SelectionFields: [ name, category_ID ],
    UI.LineItem: [
        { Value: name,  Label: 'Producto' },
        { Value: price, Label: 'Precio' },
        { Value: stock, Label: 'Stock' }
    ]
);
