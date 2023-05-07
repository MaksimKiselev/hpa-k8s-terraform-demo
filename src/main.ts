import express from 'express';
import {BigQuery} from '@google-cloud/bigquery'

const app = express()

const bq = new BigQuery()
bq.dataset('test');

app.get('/', function (req, res) {
    console.log(req.query);

    // bq.dataset().table('events').insert(req.query)

    res.status(200);
    res.send();

})

app.listen(3000)
