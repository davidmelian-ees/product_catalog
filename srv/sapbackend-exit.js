import cds from '@sap/cds';

export default async (srv) => {
    const sapbackend = await cds.connect.to('sapbackend');
    const { IncidentsSet } = sapbackend.entities;

    srv.on('READ', 'Incidents', async (req) => {
        // Actividad 5: return await sapbackend.tx(req).send({ query: req.query });
        // Actividad 6: se desglosa la query por where y orderBy
        const query = SELECT.from(IncidentsSet);
        const { where, orderBy, limit, columns } = req.query.SELECT;
        if (columns) query.columns(columns);
        if (where) query.where(where);
        if (orderBy) query.orderBy(...orderBy);
        if (limit) query.limit(limit);
        return await sapbackend.tx(req).run(query);
    });
};
