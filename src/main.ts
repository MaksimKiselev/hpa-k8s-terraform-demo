import express from 'express';
import {BigQuery} from '@google-cloud/bigquery'

const app = express()

const bq = new BigQuery()
bq.dataset('test');

app.get('/', function (req, res) {
    console.log(req.query);

    // bq.dataset().table('events').insert(req.query)

    res.json({
        res: fact(100_000_000)
    })
    res.status(200);

})

app.listen(3000)


function fact(num: number) {
    let rval = 1;
    for (let i = 2; i <= num; i++) {
        rval = rval * i;
    }

    return rval;
}