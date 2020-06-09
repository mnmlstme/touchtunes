const Airtable = require('airtable');
const base = new Airtable({
  apiKey: process.env.AIRTABLE_API_KEY,
}).base(process.env.AIRTABLE_BASE_ID);
const view = 'Grid view';

exports.list = (req, res) => {
    let json = []
    base('Scores').select({
        view: "Table",
        fields: ["Title"]
    }).eachPage( (records, fetchNextPage) => {
        json = json.concat(
            records.map(
                r => {
                    let partNames = (r.get('PartNames') || '').split(',')
                    return {
                        id: r.id,
                        title: r.get('Title'),
                        // key: {
                        //     Key: {
                        //         fifths: r.get('Key.fifths'),
                        //         mode: r.get('Key.mode')
                        //     }
                        // },
                        // time: {
                        //     Time: {
                        //         beats: r.get('Time.beats'),
                        //         beatType: r.get('Time.beatType'),
                        //     }
                        // },
                        // parts: (r.get('Parts') || []).map(
                        //     (id, i) => {
                        //         return {
                        //             id: id,
                        //             abbrev: partNames[i]
                        //         }
                        //     }
                        //)
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
                res.status(500).send(err);
            } else {
                let json = JSON.parse(record.get("Score JSON") || "{Score: {}}")
                json["id"] = id
                res.json(json)
            }
        })
}
