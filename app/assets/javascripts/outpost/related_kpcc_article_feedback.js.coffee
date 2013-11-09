class audiovision.RelatedKpccArticleFeedback
    defaults:
        input: "input.kpcc-url"
        feedbackEl: ".js-article-feedback"

    constructor: (options={}) ->
        @options = _.defaults options, @defaults

        @input          = $(@options.input)
        @feedbackEl     = $(@options.feedbackEl)

        url = @input.val()

        @fetchArticle(url) if !_.isEmpty(url)

        @input.on blur: (event) =>
            @fetchArticle $(event.target).val()


    fetchArticle: (url) ->
        if _.isEmpty(url)
            @feedbackEl.empty().hide()
            return

        @feedbackEl.show().spin("small")

        $.getJSON("http://www.scpr.org/api/v2/articles/by_url", { url: url })
        .success((data, textStatus, jqXHR) =>
            @feedbackEl.html JST['outpost/templates/related_kpcc_article'](article: data)

        ).error((jqXHR, textStatus, errorThrown) =>
            new outpost.Notification(
                @feedbackEl,
                "error",
                "Not a valid URL for KPCC content"
            ).replace()

        ).complete((jqXHR, status) =>
            @feedbackEl.spin(false)
        )
