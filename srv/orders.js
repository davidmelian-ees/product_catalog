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

    // ************ FUNCTION ************
    srv.on('getClientTaxRate', async (req) => {
        const { clientEmail } = req.data;
        const result = await cds.transaction(req).run(
            SELECT.one.from(Orders, ['Country_code']).where({ ClientEmail: clientEmail })
        );
        switch (result?.Country_code) {
            case 'ES': return 21.5;
            case 'UK': return 24.6;
            default: return 0;
        }
    });

    // ************ ACTION ************
    srv.on('cancelOrder', async (req) => {
        const { clientEmail } = req.data;
        const db = cds.transaction(req);
        const order = await db.run(
            SELECT.one.from(Orders, ['FirstName', 'LastName', 'Approved']).where({ ClientEmail: clientEmail })
        );
        const returnOrder = { status: '', message: '' };
        if (!order) {
            returnOrder.status = 'Failed';
            returnOrder.message = `Order ${clientEmail} not found`;
        } else if (order.Approved === false) {
            await db.run(UPDATE(Orders).set({ Status: 'C' }).where({ ClientEmail: clientEmail }));
            returnOrder.status = 'Succeeded';
            returnOrder.message = `The order placed by ${order.FirstName} ${order.LastName} was canceled`;
        } else {
            returnOrder.status = 'Failed';
            returnOrder.message = `The order placed by ${order.FirstName} ${order.LastName} was NOT canceled because was already approved`;
        }
        return returnOrder;
    });
};
