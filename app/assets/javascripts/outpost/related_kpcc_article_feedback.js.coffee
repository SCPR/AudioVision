class audiovision.RelatedKpccArticleFeedback
    defaults:
        input: "input.kpcc-url"
        feedbackEl: ".js-article-feedback"

    constructor: (options={}) ->
        @options = _.defaults options, @defaults
        
        @input          = $(@options.input)
        url             = @input.val()
        @feedbackEl     = $(@options.feedbackEl)

        @fetchArticle(url) if !_.isEmpty(url)
            
        @input.on blur: (event) => 
            @fetchArticle $(event.target).val()

    fetchArticle: (url) ->
        if _.isEmpty(url)
            @feedbackEl.empty()
            return

        $.getJSON("http://www.scpr.org/api/v2/content/by_url", { url: url })
        .success((data, textStatus, jqXHR) => 
            @feedbackEl.html JST['outpost/templates/related_kpcc_article'](article: data)

        ).error((jqXHR, textStatus, errorThrown) =>
            new outpost.Notification(
                @feedbackEl, 
                "error", 
                "Not a valid URL for KPCC content"
            ).replace()
        )
