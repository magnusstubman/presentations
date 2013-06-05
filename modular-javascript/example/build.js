/*{
    dir: '../example-built',
    modules: [
        {
            name: 'script'
        }
    ]
}*/


{
    baseUrl: '.',
    name: 'almond.js',
    include: ['script'],
    insertRequire: ['script'],
    out: 'script-built.js',
    wrap: true
}