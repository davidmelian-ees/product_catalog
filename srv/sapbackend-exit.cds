using {sapbackend as external} from './external/sapbackend';

define service SAPBackendExit {

    // Actividad 2: selección sobre la entidad del servicio externo
    // entity Incidents as select from external.IncidentsSet;

    // Actividad 6: proyección sobre la misma entidad
    @cds.persistence: {
        table: false,
        skip : true
    }
    entity Incidents as projection on external.IncidentsSet;
}

@protocol: 'rest'
service RestService {
    entity Incidents as projection on SAPBackendExit.Incidents;
}
