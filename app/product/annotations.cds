using CatalogService as service from '../../srv/catalog-service';

// Textos de los campos (i18n en español e inglés)
annotate service.Products with {
    ImageUrl          @title: '{i18n>ImageUrl}'  @UI.IsImageURL;
    ProductName       @title: '{i18n>ProductName}';
    Description       @title: '{i18n>Description}';
    ReleaseDate       @title: '{i18n>ReleaseDate}';
    DiscontinuedDate  @title: '{i18n>DiscontinuedDate}';
    Price             @title: '{i18n>Price}'  @Measures.ISOCurrency: ToCurrency_ID;
    Height            @title: '{i18n>Height}';
    Width             @title: '{i18n>Width}';
    Depth             @title: '{i18n>Depth}';
    Quantity          @title: '{i18n>Quantity}';
    Rating            @title: '{i18n>Rating}';
    StockAvailability @title: '{i18n>StockAvailability}';
    ToCategory        @title: '{i18n>Category}';
    ToCurrency        @title: '{i18n>Currency}';
    Supplier          @title: '{i18n>Supplier}';
};

// Ayudas de búsqueda de los campos de selección
annotate service.Products with {
    ToCategory        @(Common: {
        Text           : Category,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues,
        ValueList      : {
            Label         : '{i18n>Category}',
            CollectionPath: 'VH_Categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Text'
                }
            ]
        }
    });
    ToCurrency        @(Common: {ValueList: {
        Label         : '{i18n>Currency}',
        CollectionPath: 'VH_Currencies',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: ToCurrency_ID,
                ValueListProperty: 'Code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Text'
            }
        ]
    }});
    StockAvailability @(Common: {
        Text           : ToStockAvailability.Description,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues,
        ValueList: {
            Label         : '{i18n>StockAvailability}',
            CollectionPath: 'StockAvailability',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: StockAvailability,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Description'
                }
            ]
        }
    });
};

annotate service.VH_Categories with {
    Code @title: '{i18n>Code}'  @Common.Text: Text  @Common.TextArrangement: #TextOnly;
    Text @title: '{i18n>Category}';
};

annotate service.VH_Currencies with {
    Code @title: '{i18n>Currency}';
    Text @title: '{i18n>Description}';
};

annotate service.StockAvailability with {
    ID          @title: '{i18n>StockAvailability}'  @Common.Text: Description  @Common.TextArrangement: #TextOnly;
    Description @title: '{i18n>Description}';
};

// Contacto de comunicación del proveedor: Email, Phone y Fax
annotate service.Supplier with @(Communication.Contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    role : '{i18n>Supplier}',
    photo: 'sap-icon://supplier',
    email: [{
        type   : #work,
        address: Email
    }],
    tel  : [
        {
            type: #work,
            uri : Phone
        },
        {
            type: #fax,
            uri : Fax
        }
    ]
});

annotate service.Products with @(
    // El botón Borrar no se muestra en la página de detalle
    UI.DeleteHidden              : true,

    UI.HeaderInfo                : {
        TypeName      : '{i18n>Product}',
        TypeNamePlural: '{i18n>Products}',
        ImageUrl      : ImageUrl,
        Title         : {Value: ProductName},
        Description   : {Value: Description}
    },

    UI.SelectionFields           : [
        ToCategory_ID,
        ToCurrency_ID,
        StockAvailability
    ],

    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: ImageUrl
        },
        {
            $Type: 'UI.DataField',
            Value: ProductName
        },
        {
            $Type: 'UI.DataField',
            Value: Description
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Supplier}',
            Target: 'Supplier/@Communication.Contact'
        },
        {
            $Type: 'UI.DataField',
            Value: ReleaseDate
        },
        {
            $Type: 'UI.DataField',
            Value: DiscontinuedDate
        },
        {
            $Type      : 'UI.DataField',
            Value      : StockAvailability,
            Criticality: StockAvailability
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Rating}',
            Target: '@UI.DataPoint#AverageRating'
        },
        {
            $Type            : 'UI.DataField',
            Value            : Price,
            ![@UI.Importance]: #High
        }
    ],

    UI.DataPoint #AverageRating  : {
        Value        : Rating,
        Title        : '{i18n>Rating}',
        TargetValue  : 5,
        Visualization: #Rating
    },

    UI.HeaderFacets              : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#AverageRating'
    }],

    // FieldGroup generado por el asistente de Fiori Elements, sin los
    // campos que ya se muestran en la cabecera (ImageUrl, ProductName, Description)
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {Value: ReleaseDate},
            {Value: DiscontinuedDate},
            {Value: Price},
            {Value: Height},
            {Value: Width},
            {Value: Depth},
            {Value: Quantity},
            {Value: ToCategory_ID},
            {Value: ToCurrency_ID}
        ]
    },

    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : '{i18n>GeneralInformation}',
            Target: '@UI.FieldGroup#GeneratedGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ProductData',
            Label : '{i18n>ProductData}',
            Target: '@UI.FieldGroup#GeneratedGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ReviewsFacet',
            Label : '{i18n>Reviews}',
            Target: 'Reviews/@UI.LineItem'
        }
    ]
);

annotate service.Reviews with {
    Name      @title: '{i18n>Reviewer}';
    Rating    @title: '{i18n>Rating}';
    Comment   @title: '{i18n>Comment}';
    createdAt @title: '{i18n>CreatedAt}';
};

annotate service.Reviews with @(
    UI.HeaderInfo        : {
        TypeName      : '{i18n>Review}',
        TypeNamePlural: '{i18n>Reviews}',
        Title         : {Value: Name},
        Description   : {Value: Comment}
    },
    UI.DataPoint #Rating : {
        Value        : Rating,
        TargetValue  : 5,
        Visualization: #Rating
    },
    UI.LineItem          : [
        {Value: Name},
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Rating}',
            Target: '@UI.DataPoint#Rating'
        },
        {Value: Comment},
        {Value: createdAt}
    ],
    UI.FieldGroup #Review: {Data: [
        {Value: Name},
        {Value: Rating},
        {Value: Comment},
        {Value: createdAt}
    ]},
    UI.Facets            : [{
        $Type : 'UI.ReferenceFacet',
        Label : '{i18n>Review}',
        Target: '@UI.FieldGroup#Review'
    }]
);
