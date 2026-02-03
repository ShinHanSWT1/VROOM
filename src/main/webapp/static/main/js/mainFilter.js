/* Main page filter behavior (Location selection - AJAX) */
(function () {
    'use strict';

    if (typeof window === 'undefined' || !window.jQuery) {
        return;
    }

    var config = window.mainFilterConfig || {};
    var contextPath = config.contextPath || '';
    var selectedGuName = config.selectedGuName || '';

    $(document).ready(function () {
        $('.gu-chip').on('click', function () {
            $('.gu-chip').removeClass('active');
            $(this).addClass('active');
            selectedGuName = $(this).data('gu');
            filterPosts();
        });
    });

    function filterPosts() {
        var guName = selectedGuName;
        var param = guName ? '?guName=' + encodeURIComponent(guName) : '';

        // URL 변경 (새로고침 없이)
        history.pushState(null, '', contextPath + '/' + param);

        // 심부름 목록 갱신
        $.ajax({
            url: contextPath + '/api/main/errands' + param,
            type: 'GET',
            dataType: 'json',
            success: function (list) {
                var html = '';
                if (list && list.length > 0) {
                    list.forEach(function (task) {
                        html += '<a href="' + contextPath + '/errand/detail?errandsId=' + task.errandsId + '"'
                            + ' class="task-card" style="text-decoration: none; color: inherit;">';
                        html += '<img src="' + contextPath + task.imageUrl + '" alt="' + escapeHtml(task.title) + '" class="task-image">';
                        html += '<div class="task-info">';
                        html += '<h3 class="task-title">' + escapeHtml(task.title) + '</h3>';
                        html += '<div class="task-meta">';
                        html += '<span class="task-price">' + formatCurrency(task.rewardAmount) + '</span>';
                        html += '<span class="task-location">' + escapeHtml(task.dongFullName || '') + '</span>';
                        html += '</div></div></a>';
                    });
                }
                $('#taskGrid').html(html);
            }
        });

        // 커뮤니티 인기글 갱신
        $.ajax({
            url: contextPath + '/api/main/posts' + param,
            type: 'GET',
            dataType: 'json',
            success: function (list) {
                var html = '';
                if (list && list.length > 0) {
                    list.forEach(function (post, idx) {
                        html += '<a href="' + contextPath + '/community/detail/' + post.postId + '"'
                            + ' class="hot-post-item" style="text-decoration: none; color: inherit;">';
                        html += '<span class="hot-rank">BEST ' + (idx + 1) + '</span>';
                        html += '<span class="hot-title">' + escapeHtml(post.title) + '</span>';
                        html += '</a>';
                    });
                }
                $('#hotPostList').html(html);
            }
        });

        // 더보기 링크 갱신
        var errandLink = contextPath + '/errand/list' + (guName ? '?guName=' + encodeURIComponent(guName) : '');
        var communityLink = contextPath + '/community' + (guName ? '?guName=' + encodeURIComponent(guName) : '');
        $('#errandMoreLink').attr('href', errandLink);
        $('#communityMoreLink').attr('href', communityLink);
    }

    function formatCurrency(amount) {
        if (amount == null) return '';
        return '\u20A9' + Number(amount).toLocaleString();
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#039;');
    }
})();
