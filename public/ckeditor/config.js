CKEDITOR.editorConfig = function(config) {
  config.extraPlugins = 'codemirror';
  config.codemirror = {
    theme: 'monokai',
    lineNumbers: true,
    lineWrapping: false,
    matchBrackets: true,
    autoCloseTags: false,
    enableSearchTools: false,
    enableCodeFolding: false,
    enableCodeFormatting: true,
    autoFormatOnStart: false,
    autoFormatOnUncomment: false,
    highlightActiveLine: false,
    highlightMatches: false,
    showTabs: false,
    showFormatButton: false,
    showCommentButton: false,
    showUncommentButton: false
  };
  config.format_tags = 'p;h3;h4';
  config.allowedContent = true; // Disable Advanced Content Filter for oembed
  config.toolbar = [['Bold', 'Italic', 'Underline', 'Format', "RemoveFormat"], ['NumberedList', 'BulletedList', 'Blockquote'], ['Link', 'Unlink', 'Image'], ['Find', 'Paste'], ['Source', 'Maximize']];
  config.language = 'en';
  config.height = "400px";
  config.width = "635px";
  config.bodyClass = 'ckeditor-body prose';
  config.contentsCss = APPLICATION_CSS;
  config.disableNativeSpellChecker = false;
  config.forcePasteAsPlainText = true;
  return true;
};
