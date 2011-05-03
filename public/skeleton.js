(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  $(document).ready(function() {
    var App, Egyik, Page;
    Page = (function() {
      function Page() {
        Page.__super__.constructor.apply(this, arguments);
      }
      __extends(Page, Backbone.View);
      Page.prototype.render_template = function(p) {
        return _.template($('#' + this.template).html(), p);
      };
      Page.prototype.render = function() {
        console.log(this.render_template);
        $(this.el).html(this.render_template());
        return Page.__super__.render.apply(this, arguments);
      };
      return Page;
    })();
    Egyik = (function() {
      function Egyik() {
        Egyik.__super__.constructor.apply(this, arguments);
      }
      __extends(Egyik, Page);
      Egyik.prototype.template = 'egyik';
      return Egyik;
    })();
    App = (function() {
      function App() {
        App.__super__.constructor.apply(this, arguments);
      }
      __extends(App, Backbone.Controller);
      App.prototype.routes = {
        ':page': 'show'
      };
      App.prototype.initialize = function() {
        return this.egyik = new Egyik();
      };
      App.prototype.replace_body = function(page) {
        $('body').children().remove();
        return $('body').append(page);
      };
      App.prototype.show = function(page) {
        return this.replace_body(this[page].render().el);
      };
      return App;
    })();
    window.app = new App();
    return Backbone.history.start();
  });
}).call(this);
