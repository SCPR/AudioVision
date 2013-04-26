class audiovision.KpccReferenceBox
    constructor: ->
        popularArticles = $("#kpcc-popular-articles")

        $('.js-kpcc-reference-box').each (i) ->
            el = $(@)

            if _.isEmpty el.html().trim()
                el.html popularArticles.clone().show()
