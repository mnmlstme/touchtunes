const Airtable = require('airtable')
const base = new Airtable({
  apiKey: process.env.AIRTABLE_API_KEY,
}).base(process.env.AIRTABLE_BASE_ID)
const view = 'Grid view'

exports.list = (req, res) => {
    let json = []
    base('Scores').select({
        view: "Table",
        fields: ["Title", "Part JSON", "Key JSON", "Time JSON", "Last Modified"],
        sort: [{field: "Last Modified", direction: "desc"}]
    }).eachPage( (records, fetchNextPage) => {
        json = json.concat(
            records.map(
                r => {
                    return {
                        id: r.id,
                        title: r.get('Title'),
                        part: JSON.parse(r.get('Part JSON') || '{"ScorePart": {}}'),
                        key: JSON.parse(r.get('Key JSON') || '{"Key": {}}'),
                        time: JSON.parse(r.get('Time JSON') || '{"Time": {}}')
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
                res.json( transformDown(record) )
            }
        })
}

function transformDown (rec) {
    let part = JSON.parse(rec.get("Part JSON") || '{"ScorePart": {}}')
    let measures = JSON.parse(rec.get("Measures JSON") || '[]')

    return {Score: {
        title: rec.get('Title'),
        "part-list" : [part],
        "measure-list": measures
    }}
}

exports.create = (req, res) => {
    let body = req.body

    base('Scores').create([
        {
            "fields": transformUp(body)
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

function transformUp (body) {
    let score = body["Score"]
    let title = score ? score["title"] : ""
    let partList = score ? score["part-list"] : [{ScorePart: {}}]
    let measureList = score ? score["measure-list"] : []
    let firstMeasure = measureList.length > 0 && measureList[0] && measureList[0]["Measure"]
    let attributes = firstMeasure ? firstMeasure["attributes"]["Attributes"] : {
       key: { Key: {} },
       time: { Time: {} }
    }

    return {
                "Title": title,
                "Part JSON": JSON.stringify(partList[0]),
                "Key JSON": JSON.stringify(attributes["key"]),
                "Time JSON": JSON.stringify(attributes["time"]),
                "Measures JSON": JSON.stringify(measureList),
                "Score JSON": JSON.stringify(body)
            }
}

exports.update = (req, res) => {
    // TODO; separate endpoint to update just the metadata or parts
    let id = req.params.id
    let body = req.body

    base('Scores').update([
        {
            "id": id,
            "fields": transformUp(body)
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
