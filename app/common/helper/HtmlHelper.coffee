app.factory 'HtmlHelper', () ->
  htmlEntities: (text) ->
    String(text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
