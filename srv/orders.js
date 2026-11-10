import cds from '@sap/cds';

export default (srv) => {
    const { Orders } = cds.entities('com.training');

    // ************ READ ************
    srv.on('READ', 'Orders', async (req) => {
        // Pedido concreto: /Orders('client1@client1.com')
        if (req.data.ClientEmail !== undefined) {
            return await SELECT.one.from(Orders).where({ ClientEmail: req.data.ClientEmail });
        }
        return await SELECT.from(Orders);
    });

    srv.after('READ', 'Orders', (data) => {
        const orders = Array.isArray(data) ? data : [data];
        return orders.map((order) => order && (order.Reviewed = true));
    });

    // ************ CREATE ************
    srv.before('CREATE', 'Orders', (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
        return req;
    });

    srv.on('CREATE', 'Orders', async (req) => {
        const result = await cds.transaction(req).run(INSERT.into(Orders).entries({
            ClientEmail: req.data.ClientEmail,
            FirstName: req.data.FirstName,
            LastName: req.data.LastName,
            CreatedOn: req.data.CreatedOn,
            Reviewed: req.data.Reviewed,
            Approved: req.data.Approved
        })).then(
            (resolve) => (resolve.affectedRows ?? resolve) ? req.data : req.error(409, 'Record not inserted'),
            (reject) => req.error(reject.code ?? 400, reject.message)
        );
        return result;
    });

    // ************ UPDATE ************
    srv.on('UPDATE', 'Orders', async (req) => {
        const affected = await cds.transaction(req).run(
            UPDATE(Orders, req.data.ClientEmail).set({
                FirstName: req.data.FirstName,
                LastName: req.data.LastName
            })
        );
        if (affected !== 1) return req.error(404, 'Record not found');
        return await SELECT.one.from(Orders).where({ ClientEmail: req.data.ClientEmail });
    });

    // ************ DELETE ************
    srv.on('DELETE', 'Orders', async (req) => {
        const affected = await cds.transaction(req).run(
            DELETE.from(Orders).where({ ClientEmail: req.data.ClientEmail })
        );
        if (affected !== 1) return req.error(404, 'Record not found');
    });
};
