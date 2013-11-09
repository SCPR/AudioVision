class audiovision.RelatedKpccArticle
    defaults:
        wrapper: '.js-related-kpcc-article .preview'
        template: JST['templates/related_kpcc_article']

    constructor: (@url, options={}) ->
        @options    = _.defaults options, @defaults
        @wrapper    = $(@options.wrapper)

        @fetchArticle(url) if !_.isEmpty(url)


    fetchArticle: (url) ->
        return if _.isEmpty(url)

        @wrapper.spin()

        $.getJSON("http://www.scpr.org/api/v2/articles/by_url", { url: url })
        .success((data, textStatus, jqXHR) =>
            @wrapper.html @options.template(article: data)

        ).error((jqXHR, textStatus, errorThrown) =>
            # Display an error? Maybe best just to ignore it.
            @wrapper.hide()

        ).complete((jqXHR, status) =>
            @wrapper.spin(false)
        )
