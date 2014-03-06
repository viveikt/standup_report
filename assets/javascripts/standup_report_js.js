//= require bootstrap-datepicker

function dateDiff(first, second) {

    // Copy date parts of the timestamps, discarding the time parts.
    var one = new Date(first.getFullYear(), first.getMonth(), first.getDate());
    var two = new Date(second.getFullYear(), second.getMonth(), second.getDate());

    // Do the math.
    var millisecondsPerDay = 1000 * 60 * 60 * 24;
    var millisBetween = two.getTime() - one.getTime();
    var days = millisBetween / millisecondsPerDay;

    // Round down.
    return Math.floor(days)
}

function getQueryStrings() {
    var q = window.location.search.substr(1), qs = {};
    if (q.length) {
        var keys = q.split("&"), k, kv, key, val, v;
        for (k = keys.length; k--; ) {
            kv = keys[k].split("=");
            key = kv[0];
            val = decodeURIComponent(kv[1]);
            if (qs[key] === undefined) {
                qs[key] = val;
            } else {
                v = qs[key];
                if (v.constructor != Array) {
                    qs[key] = [];
                    qs[key].push(v);
                }
                qs[key].push(val);
            }
        }
    }
    return qs;
}

function getNewCalandarDate(date,days_ago)
{
    var selecteddate = new Date(
        date.getFullYear(), 
        date.getMonth(), 
        date.getDate() - days_ago,
        date.getHours(),
        date.getMinutes(),
        date.getSeconds(),
        date.getMilliseconds()
    )
    return selecteddate;  
}

function add_Class_To_Selected_Date()
{
  $('.ui-datepicker-calendar tr td a.ui-state-default.ui-state-highlight').removeClass('ui-state-highlight');
  $('.ui-datepicker-calendar tr td a.ui-state-default.ui-state-active').addClass('ui-state-highlight').removeClass('ui-state-active');
}

$('.ui-dialog').live("dialogclose", function(){
  setTimeout(function(){ showHideText(); },300); 
});
$('.delete').live('click' , function() {
  setTimeout(function(){ showHideText(); },300);  
});

function showHideText() {
  if(parseInt($('#watchers > ul').length) > 0)
  {
    $('.daily_status_email_note').hide();
    $('#project_members').hide();
    $('#project_watchers').show();
    
  }else if(parseInt($('#watchers > ul').length) <= 0)
  {
    $('.daily_status_email_note').show();
    $('#project_members').show();
    $('#project_watchers').hide();    
  }
}

function qtipMakeOptions(container, ajax){
    var options = {
        content: {
            text: container.children('div.tooltip_text')
        },
        position: {
            my: 'top left',
            target: 'mouse',
            viewport: $(window), // Keep it on-screen at all times if possible
            adjust: {
                x: 10,  y: 10
            }
        },
        hide: {
           fixed: true // Helps to prevent the tooltip from hiding ocassionally when tracking!
        }
    };
    if (ajax) {
      var id = $('#standup_report_project_id').val();
      var standup_id = container.children('.id .standup_id').text();
      options['content'] = {
              text: '<div class="tooltip_text">Loading...</div>',
              ajax: {
                url: "/project/" + id + "/standup_reports/tooltip?standup_id=" + standup_id,
                type: 'GET',
                once: true
              }
            };
    }
    return options;
}

function initToolTip(){
    $('div.standup_tooltip_ajax').each(function(el) {
        var link = $(this);
        link.qtip(qtipMakeOptions(link, true));
    });
  }