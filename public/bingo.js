(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $(document).ready(function() {
    var Cell, CellView, Sheet, SheetView;
    Cell = (function() {
      function Cell() {
        Cell.__super__.constructor.apply(this, arguments);
      }
      __extends(Cell, Backbone.Model);
      Cell.prototype.initialize = function() {
        this.__defineGetter__('selected', function() {
          return this.get('selected');
        });
        return this.__defineSetter__('selected', function(value) {
          return this.set({
            selected: value
          });
        });
      };
      return Cell;
    })();
    Sheet = (function() {
      function Sheet() {
        Sheet.__super__.constructor.apply(this, arguments);
      }
      __extends(Sheet, Backbone.Collection);
      Sheet.prototype.initialize = function() {
        return this.__defineGetter__('size', function() {
          return Math.sqrt(this.length);
        });
      };
      Sheet.prototype.model = Cell;
      Sheet.prototype.url = '/sheet';
      Sheet.prototype.every_nth = function(n, offset, smallest, largest) {
        if (offset == null) {
          offset = 0;
        }
        if (smallest == null) {
          smallest = 0;
        }
        if (largest == null) {
          largest = this.length;
        }
        return this.select(__bind(function(cell) {
          return (this.indexOf(cell)) % n === offset && (this.indexOf(cell)) >= smallest && (this.indexOf(cell)) <= largest;
        }, this));
      };
      Sheet.prototype.check_match = function(cells) {
        if (_.pluck(cells, 'selected').reduce(function(p, c) {
          return p && c;
        })) {
          _.each(cells, function(cell) {
            return cell.set({
              winning: true
            });
          });
          return cells;
        }
      };
      Sheet.prototype.row_matches = function() {
        var results, row, start;
        return results = (function() {
          var _ref, _results;
          _results = [];
          for (row = 0, _ref = this.size; (0 <= _ref ? row < _ref : row > _ref); (0 <= _ref ? row += 1 : row -= 1)) {
            start = row * this.size;
            _results.push(this.check_match(this.models.slice(start, start + this.size)));
          }
          return _results;
        }).call(this);
      };
      Sheet.prototype.column_matches = function() {
        var results, row;
        results = (function() {
          var _ref, _results;
          _results = [];
          for (row = 0, _ref = this.size; (0 <= _ref ? row < _ref : row > _ref); (0 <= _ref ? row += 1 : row -= 1)) {
            _results.push(this.check_match(this.every_nth(this.size, row)));
          }
          return _results;
        }).call(this);
        return _.reduce(results, function(p, c) {
          return p || c;
        });
      };
      Sheet.prototype.diagonal_matches = function() {
        var results;
        results = [this.check_match(this.every_nth(this.size + 1)), this.check_match(this.every_nth(this.size - 1, 0, this.size - 1, this.length - this.size))];
        return _.reduce(results, function(p, c) {
          return p || c;
        });
      };
      Sheet.prototype.look_for_matches = function() {
        this.each(function(cell) {
          return cell.set({
            winning: false
          });
        });
        this.row_matches();
        this.column_matches();
        return this.diagonal_matches();
      };
      return Sheet;
    })();
    CellView = (function() {
      function CellView() {
        this.toggle_winning = __bind(this.toggle_winning, this);;
        this.toggle_selected = __bind(this.toggle_selected, this);;        CellView.__super__.constructor.apply(this, arguments);
      }
      __extends(CellView, Backbone.View);
      CellView.prototype.className = 'cell';
      CellView.prototype.events = {
        'click': 'click'
      };
      CellView.prototype.initialize = function() {
        this.model.bind('change:selected', this.toggle_selected);
        return this.model.bind('change:winning', this.toggle_winning);
      };
      CellView.prototype.render = function() {
        $(this.el).html(this.model.get('value'));
        if (this.model.selected) {
          $(this.el).addClass('selected');
        }
        return this;
      };
      CellView.prototype.click = function() {
        return this.model.set({
          selected: !this.model.selected
        });
      };
      CellView.prototype.toggle_selected = function() {
        this.collection.look_for_matches();
        if (this.model.selected) {
          return $(this.el).addClass('selected');
        } else {
          return $(this.el).removeClass('selected');
        }
      };
      CellView.prototype.toggle_winning = function() {
        if (this.model.get('winning')) {
          return $(this.el).addClass('winning');
        } else {
          return $(this.el).removeClass('winning');
        }
      };
      return CellView;
    })();
    SheetView = (function() {
      function SheetView() {
        this.add_one = __bind(this.add_one, this);;
        this.render = __bind(this.render, this);;        SheetView.__super__.constructor.apply(this, arguments);
      }
      __extends(SheetView, Backbone.View);
      SheetView.prototype.el = $("#sheet");
      SheetView.prototype.initialize = function() {
        return this.collection.bind('refresh', this.render);
      };
      SheetView.prototype.render = function() {
        return this.collection.each(this.add_one);
      };
      SheetView.prototype.add_one = function(cell) {
        var one;
        one = new CellView({
          model: cell,
          collection: this.collection
        });
        return this.el.append(one.render().el);
      };
      return SheetView;
    })();
    window.sheet = new Sheet;
    window.sheetview = new SheetView({
      collection: sheet
    });
    return sheet.fetch();
  });
}).call(this);
