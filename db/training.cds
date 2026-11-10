namespace com.training;

type EmailsAddresses_01 : array of {
    kind  : String;
    email : String;
};

type EmailsAddresses_02 {
    kind  : String;
    email : String;
};

entity Emails {
    email_01 :      EmailsAddresses_01;
    email_02 : many EmailsAddresses_02;
    email_03 : many {
        kind  : String;
        email : String;
    }
};

type Gender : String enum {
    male;
    female;
};

entity Order {
    clientGender : Gender;
    status       : Integer enum {
        submitted = 1;
        fulfiller = 2;
        shipped   = 3;
        cancel    = -1;
    };
    priority     : String @assert.range enum {
        high;
        medium;
        low;
    };
};

entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal;
        virtual discount_2 : Decimal;
};

// Entidades con parámetros: no soportadas en SQLite (se usarán con HANA)
// entity ParamProducts(pName : String)     as
//     select from com.logali.materials.Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pName;
//
// entity ProjParamProducts(pName : String) as projection on com.logali.materials.Products
//     where
//         Name = :pName;

entity Course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;
};

entity Student {
    key ID     : UUID;
        Course : Association to many StudentCourse
                     on Course.Student = $self;
};

entity StudentCourse {
    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;
};
