/**
 * Created by remco on 28/10/15.
 */
(function() {
    //init lightboxes
    $(document).delegate('*[data-toggle="lightbox"]', 'click', function (event) {
        event.preventDefault();
        $(this).ekkoLightbox();
    });

    //init elements fixed in viewport
    /**
     * This part handles the highlighting functionality.
     * We use the scroll functionality again, some array creation and
     * manipulation, class adding and class removing, and conditional testing
     */
    var $nav = $('nav[data-lockfixed="true"]');
    var aChildren = $('nav[data-lockfixed="true"] li').children(); // find the a children of the list items
    var aArray = []; // create the empty aArray
    for (var i=0; i < aChildren.length; i++) {
        var aChild = aChildren[i];
        var ahref = $(aChild).attr('href');
        aArray.push(ahref);
    } // this for loop fills the aArray with attribute href values

    if($('nav[data-lockfixed="true"]').length) {
        stickNav();
        $(window).scroll(function(){
            stickNav();
        });
        $(window).resize(function(){
            stickNav();
        });
    }

    function stickNav () {
        var window_top = $(window).scrollTop(); // the "12" should equal the margin-top value for nav.stick
        var div_top = $('#nav-anchor').offset().top - 30;
        var $nav = $('nav[data-lockfixed="true"]');

        if (window_top > div_top) {
            $nav.addClass('stick');
            if($nav.width() !== $('#nav-anchor').width()) {
                $nav.css({'width':$('#nav-anchor').width()});
            }
        } else {
            $nav.removeClass('stick');
        }

        var windowPos = $(window).scrollTop(); // get the offset of the window from the top of page
        var windowHeight = $(window).height(); // get the height of the window
        var docHeight = $(document).height();

        for (var i=0; i < aArray.length; i++) {
            var theID = aArray[i];
            var divPos = $(theID).offset().top; // get the offset of the div from the top of page
            var divHeight = $(theID).outerHeight(true); // get the height of the div in question
            var footerHeight = $('.page-footer').outerHeight();
            var navHeight = $nav.outerHeight();
            var navToBottom = windowHeight - navHeight;
            if (windowPos >= divPos && windowPos < (divPos + divHeight)) {
                $("a[href='" + theID + "']").addClass("nav-active");
            } else {
                $("a[href='" + theID + "']").removeClass("nav-active");
            }
        }

        if(windowPos + windowHeight == docHeight) {
            if (!$('nav[data-lockfixed="true"] li:last-child a').hasClass("nav-active")) {
                var navActiveCurrent = $(".nav-active").attr("href");
                $("a[href='" + navActiveCurrent + "']").removeClass("nav-active");
                $('nav[data-lockfixed="true"] li:last-child a').addClass("nav-active");
            }
        }

        if(windowPos + windowHeight >= docHeight - footerHeight) {
            var footerInSight =  (windowPos + windowHeight) - (docHeight - footerHeight);
            if(footerInSight > (navToBottom - 18)) {
                $nav.css({'top': (navToBottom - footerInSight - 18)})
            }else {
                $nav.css({'top': 30})
            }
        }
    }

    $('.input-group.date').each(function () {
        $(this).datetimepicker(
            {
                "format": "DD-MM-YYYY",
                "locale": "nl"
            }
        );
    });

    $('.input-group.date-en').each(function () {
        $(this).datetimepicker(
            {
                "format": "MM-DD-YYYY",
                "locale": "en"
            }
        );
    });

    $('.pageheader .toggle-search').on('click', function () {
        $('.pageheader').toggleClass('showsearch');
        $('.pageheader #search').focus();
    });

    if($('.login-page').length) {
        var $focusInput = $('.login-page').find('input[type=text]').filter(':visible:first');
        $focusInput.focus();
    }

    smoothScroll.init();

    //make table sortable
    $('.table-sortable').each(function () {
        $(this).tablesorter();
    });

    //init search-suggestions
    function substringMatcher(strs) {
        return function findMatches(q, cb) {
            var matches, substrRegex;

            // an array that will be populated with substring matches
            matches = [];
            // regex used to determine if a string contains the substring `q`
            substrRegex = new RegExp(q, 'i');
            // iterate through the pool of strings and for any string that
            // contains the substring `q`, add it to the `matches` array
            $.each(strs, function (i, str) {
                if (substrRegex.test(str)) {
                    matches.push(str);
                }
            });
            cb(matches);
        };
    };
    var searchTerms = [' Letteren en Wijsbegeerte',
        'Rechtsgeleerdheid',
        'Wetenschappen',
        'Geneeskunde en Gezondheidswetenschappen',
        'Ingenieurswetenschappen en Architectuur',
        'Economie en Bedrijfskunde',
        'Diergeneeskunde',
        'Psychologie en Pedagogische Wetenschappen',
        'Bio-ingenieurswetenschappen',
        'Farmaceutische Wetenschappen',
        'Politieke en Sociale Wetenschappen',
        'Homes Kantienberg',
        'Studentenhomes Kantienberg'];


    $('input.typeahead').each(function () {
        $(this).typeahead({
            hint: true,
            highlight: true,
            minLength: 1
        },
        {
            name: 'searchTerms',
            source: substringMatcher(searchTerms)
        });
    });
}());

