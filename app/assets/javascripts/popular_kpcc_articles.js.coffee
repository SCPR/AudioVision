class audiovision.PopularKpccArticles
    defaults:
        wrapper: '.js-kpcc-popular-articles .popular-links ul'
        template: JST['templates/popular_kpcc_article']
        limit: 3
        
    constructor: (@articles, options={}) ->
        @options    = _.defaults options, @defaults
        @wrapper    = $(@options.wrapper)

        @populateList()


    populateList: ->
        for article in @articles[0..@options.limit]
            @wrapper.append @options.template(article: article)
