(function(){
  window.Watchtower = {}

  var setupClickHandlers = function(){
    $('ul#nav li').click(function(){
      Watchtower.App.initBeam($(this).attr('data-service'))
    })
  }

  var getBeams = function(){
    var beams = {}
    $('ul#nav li').each(function(){
      var el = $(this)
      var service = el.attr('data-service')
      var title = el.attr('data-title')
      beams[service] = {service: service, title: title, navElement: el}
    })
    return beams
  }

  Watchtower.App = {
    currentBeam: null,

    init: function(){
      this.titleElement = $('h1')
      this.beams = getBeams()
      setupClickHandlers()
      this.initBeam('all')

      setInterval(Watchtower.App.poll, 60*1000)
      Watchtower.App.poll()
    },

    initBeam: function(service){
      if (this.currentBeam == this.beams[service]) return

      if (this.currentBeam) this.currentBeam.navElement.removeClass('selected')

      this.currentBeam = this.beams[service]
      this.currentBeam.navElement.addClass('selected')

      $('ul.events>li').each(function(){
        var el = $(this)
        if (el.hasClass(service) || service == 'all')
          el.show()
        else
          el.hide()
      });
    },

    poll: function(){
      $('p.status').show()
      $.ajax({
        type: 'GET',
        url: '/poll',
        success: function(html){
          $('ul.events').prepend(html)
          $('p.status').hide()
        }
      })
    }
  }

})();

$(function(){
  Watchtower.App.init()
});