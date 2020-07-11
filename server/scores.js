const Airtable = require('airtable')
const base = new Airtable({
  apiKey: process.env.AIRTABLE_API_KEY,
}).base(process.env.AIRTABLE_BASE_ID)
const view = 'Grid view'

exports.list = (req, res) => {
    let json = []
    base('Scores').select({
        view: "Table",
        fields: ["Title", "Last Modified"],
        sort: [{field: "Last Modified", direction: "desc"}]
    }).eachPage( (records, fetchNextPage) => {
        json = json.concat(
            records.map(
                r => {
                    let partNames = (r.get('PartNames') || '').split(',')
                    return {
                        id: r.id,
                        title: r.get('Title'),
                    }
                }
            )
        )
        fetchNextPage()
    }, function done(err) {
        if (err) {
            res.status(500).send(err);
        } else {
            res.json(json)
        }
    })
}

exports.getById = (req, res) => {
    let id = req.params.id
    base('Scores').find(id,
        function found(err, record) {
            if (err) {
                res.status(500).send(err)
            } else {
                res.json( parseRecord(record) )
            }
        })
}

const parseRecord = (rec) => {
    let json = JSON.parse(rec.get("Score JSON") || "{\"Score\": {}}")
    json["title"] = rec.get("Title")
    return json
}

exports.create = (req, res) => {
    let body = req.body
    let score = body["Score"]
    let title = score ? score["title"] : ""

    base('Scores').create([
        {
            "fields": {
                "Title": title,
                "Score JSON": JSON.stringify(body)
            }
        }
    ], function(err, records) {
        if (err) {
            res.status(500).send(err)
            return
        }

        let json = records.map(
            rec => [rec.getId(), parseRecord(rec)]
        )
        res.json(json)
    });
}

exports.update = (req, res) => {
    // TODO; separate endpoint to update just the metadata or parts
    let id = req.params.id
    let body = req.body
    let score = body["Score"]
    let title = score ? score["title"] : ""

    base('Scores').update([
        {
            "id": id,
            "fields": {
                "Title": title,
                "Score JSON": JSON.stringify(body)
            }
        }
    ], function(err, records) {
        if (err) {
            res.status(500).send(err)
            return
        }

        let json = records.map(
            rec => [rec.getId(), parseRecord(rec)]
        )
        res.json(json)
    });
}
