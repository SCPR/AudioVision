class audiovision.RelatedKpccArticle
    @API_ENDPOINT = "http://www.scpr.org/api/v3/articles/by_url"

    defaults:
        wrapper: '.js-related-kpcc-article .preview'
        template: JST['templates/related_kpcc_article']

    constructor: (url, options={}) ->
        @options    = _.defaults options, @defaults
        @wrapper    = $(@options.wrapper)

        @fetchArticle(url)


    fetchArticle: (url) ->
        return if _.isEmpty(url)

        @wrapper.spin()

        $.getJSON(RelatedKpccArticle.API_ENDPOINT, { url: url })
        .success((data, textStatus, jqXHR) =>
            if data['article']
                @wrapper.html @options.template(article: data['article'])
            else
                @wrapper.hide()

        ).error((jqXHR, textStatus, errorThrown) =>
            # Display an error? Maybe best just to ignore it.
            @wrapper.hide()

        ).complete((jqXHR, status) =>
            @wrapper.spin(false)
        )
