class audiovision.PopularKpccArticles
    @API_ENDPOINT = "http://www.scpr.org/api/v3/articles/most_viewed"

    defaults:
        wrapper: '.js-kpcc-popular-articles .popular-links'
        template: JST['templates/popular_kpcc_article']
        limit: 3

    constructor: (url, options={}) ->
        @options    = _.defaults options, @defaults
        @wrapper    = $(@options.wrapper)

        @fetchArticles(url)


    fetchArticles: (url) ->
        return if _.isEmpty(url)

        @wrapper.spin()

        $.getJSON(PopularKpccArticles.API_ENDPOINT)
        .success((data, textStatus, jqXHR) =>
            if data['articles'].length > 0
                for article in data['articles'][0..@options.limit]
                    @wrapper.append @options.template(article: article)
            else
                @wrapper.hide()

        ).error((jqXHR, textStatus, errorThrown) =>
            # Display an error? Maybe best just to ignore it.
            @wrapper.hide()

        ).complete((jqXHR, status) =>
            @wrapper.spin(false)
        )
