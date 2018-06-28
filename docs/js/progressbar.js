(function ($) {
    $.fn.progressBar = function (options) {
        // Calculate progress bar location
        var progress = function () {
            var local_y = [17, 55,  84,   113,  142,  171,  200,   200,   200];
            var page_y =  [0,  749, 2665, 4016, 6631, 8756, 10877, 11146, 20000];
            var pgbar = $(this);
            var page_top = $(window).scrollTop();
            var header_y = $('header').height() + 6;
            var local_top = local_y[0];

            if (page_top >= header_y - 20) {
                var len = page_y.length - 1;
                for (var i = 0; i < len; i++) {
                    if (page_top >= page_y[i] && page_top < page_y[i+1]) {
                        local_top = ((page_top - page_y[i]) * (local_y[i+1] - local_y[i]) / (page_y[i+1] - page_y[i]) + (local_y[i]));
                    }
                }
                pgbar.css('top', local_top+'px');
            }

        };

        return this.each(function () {
            $(window).on('scroll', $.proxy(progress, this));
            $(window).on('resize', $.proxy(progress, this))
            $.proxy(progress, this)();
        });
        
    };
}(jQuery));