/* checksum : 0a1b61011281553d7fe7240e59bd2457 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
service sapbackend {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.content.version : '1'
  entity IncidentsSet {
    @sap.label : 'Incidencia'
    key IncidenceId : String(10) not null;
    @sap.label : 'Usuario SAP'
    key SapId : String(40) not null;
    @sap.label : 'Empleado'
    key EmployeeId : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.label : 'Fecha creación'
    CreationDate : Timestamp;
    @sap.label : 'Tipo'
    Type : String(1);
    @sap.label : 'Motivo'
    Reason : String(40);
  };
};

