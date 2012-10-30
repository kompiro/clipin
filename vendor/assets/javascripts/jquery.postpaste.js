$.fn.pasteEvents = function( delay ) {
  if (delay == undefined) delay = 20;
  return $(this).each(function() {
      var $el = $(this);
      $el.on("paste", function() {
        $el.trigger("prepaste");
        setTimeout(function() { $el.trigger("postpaste"); }, delay);
        });
      });
};
