import 'dotenv/config';
import cds from '@sap/cds';
import cors from 'cors';
import proxy from '@sap/cds-odata-v2-adapter-proxy';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const swagger = require('cds-swagger-ui-express');

cds.on('bootstrap', (app) => {
    app.use(cors());
    app.get('/alive', (_, res) => res.status(200).send('Server is Alive'));
    app.use(proxy());
    app.use(swagger());
});

export default cds.server;
