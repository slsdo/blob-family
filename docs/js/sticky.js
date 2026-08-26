(function ($) {
    $.fn.stickySidebar = function (options) {

        var fixSidebar = function () {
            var sidebar = $(this);
            var viewport_y = $(window).height();
            var header_y = 160;
            var sidebar_y = sidebar.outerHeight();
            var scroll_top = $(window).scrollTop();

            // Calculate
            if (viewport_y < sidebar_y) {
                sidebar.css({'position':'absolute','top':header_y+'px'});
            }
            else if (scroll_top < header_y) {
                sidebar.css({'position':'absolute','top':header_y+'px'});
            }
            else if (scroll_top >= header_y) {
                sidebar.css({'position':'fixed','top':0+'px'});
            }

        };

        return this.each(function () {
            $(window).on('scroll', $.proxy(fixSidebar, this));
            $(window).on('resize', $.proxy(fixSidebar, this))
            $.proxy(fixSidebar, this)();
        });
        
    };
}(jQuery));